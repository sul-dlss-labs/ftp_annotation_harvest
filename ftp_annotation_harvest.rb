require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'http'
  gem 'byebug'
end

puts 'Gems installed and loaded!'

# require 'http'
require 'fileutils'

# Fetch collection manifest
collection = JSON.parse(HTTP.get("https://fromthepage.com/iiif/collection/762").to_s)
# Select manifests w/ 100% completion
completed_manifests = collection.dig('manifests').select{|manifest| manifest['service']['pctComplete'].to_i == 100 }
puts "#{completed_manifests.size} completed manifests to download"
completed_manifests.each do |manifest|
  parsed_manifest = JSON.parse(HTTP.get(manifest['@id']).to_s)
  druid = parsed_manifest['metadata'].first['value'].split('/')[3]
  FileUtils.mkdir_p("files/#{druid}")

  ##
  # Select canvases
  parsed_manifest.dig('sequences').each do |sequence|
    sequence.dig('canvases').each do |canvas|
      image_id = canvas.dig('images',0,'@id').split('/').last.gsub("#{druid}%2F",'')
      otherContent = canvas.dig('otherContent')
      otherContent.select {|content| content['@type'] == 'sc:AnnotationList'}.each do |content|
        annotation_id = content['@id']
        parsed_annotation_list = JSON.parse(HTTP.get(annotation_id).to_s)
        ##
        # Note: Per Andrew, the accessioning scripts can only associate these things if they have the same filename as the image_id
        # This means that we can only have 1 annotation file. For many reasons this is suboptimal, but turns out it seems like FTP only
        # has one annotation resource.. So it is ok?
        puts "WARNING: The annotation resource contains more than one annotation object!!!" if parsed_annotation_list['resources'].size > 1
        puts "Writing #{druid}/#{image_id}.json"
        File.write("files/#{druid}/#{image_id}.json", JSON.pretty_generate(parsed_annotation_list['resources'].first))
      end if otherContent
    end
  end
end
