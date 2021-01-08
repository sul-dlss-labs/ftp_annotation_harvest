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
collection.dig('manifests').take(1).select{|manifest| manifest['service']['pctComplete'].to_i == 100 }.each do |manifest|
  parsed_manifest = JSON.parse(HTTP.get(manifest['@id']).to_s)
  druid = parsed_manifest['metadata'].first['value'].split('/')[3]
  FileUtils.mkdir_p("files/#{druid}")

  # select canvases
  parsed_manifest.dig('sequences').each do |sequence|
    sequence.dig('canvases').each do |canvas|
      image_id = canvas.dig('images',0,'@id').split('/').last.gsub("#{druid}%2F",'')

      canvas['otherContent'].select {|content| content['@type'] == 'sc:AnnotationList'}.each do |content|
        annotation_id = content['@id']
        parsed_annotation_list = JSON.parse(HTTP.get(annotation_id).to_s)
      end
    end
  end
end

#   For each manifest
#     ID
#     pctComplete (maybe we want this for future stuff??)
#     Create a directory for the druid in our saved files
#
#     each canvas in manifest
#       save image ID
#       use for annotations file name
#
#       otherContent
#         @type sc:AnnotationList
#         ID (/list/transcription)
#
#           Save "resources" in a file per Andrew's
