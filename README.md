# ftp_annotation_harvest

> ⚠️ **ATTENTION!** This repository predates the creation of the [FromThePage structured data API for harvesting contributions](https://github.com/benwbrum/fromthepage/wiki/Structured-Data-API-for-Harvesting-Crowdsourced-Contributions). 

This is a (proof of concept) script to harvest from a transcription projects hosted on [FromThePage](https://fromthepage.com/) for accessioning with existing image or book objects in the Stanford Digital Repository. Originally based on two Gists ([1](https://gist.github.com/camillevilla/4d19805f564092ffc64a7653893d47d5), [2](https://gist.github.com/mejackreed/7546c2947d94ffce5fa3d1c38fbde6d7)).

## Best case scenario

As described by our [proposed approach](https://docs.google.com/document/d/1-pFteFv1bZJE4h0a2OtIcrZa4cN3TB5mOZ78PbT8l7Y/edit):

1. Ensure the FTP project is “public”. This is needed as it will allow for canvas level transcription harvesting and is only needed while harvesting the transcriptions. The current export options from FTP are insufficient for this approach.
2. Use this script to download all project/object transcriptions at the canvas level.
   1. Access FromThePage project collection manifest (assumed to be public)
   2. Find every FromThePage manifest that correlates to an SDR object that is transcribed and access that.
   3. For every canvas in that manifest, download the `otherContent.AnnotationList`. The script saves the file to a filename that relates to the trailing path of the canvas ID.
 4. Accession the files into SDR under the original objects, an das additiona files within each canvas resource with `role="annotation"`.
