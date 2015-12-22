release.sh
=========

builds an xcode scheme, packs it to IPA and dSYM.zip. The artifacts are placed in a 'dated' distribution folder and if you want it, it can upload the ipa & zipped dsym to crashlytics and/or ockey app.

#the scripts
the main release.sh script 'orchestrates' the deployment of an app. Unrelated to the no. of targets and schemes and deployment platforms used.

e.g. in one of my cases, I use the release.sh script to build my app in 6 flavors, 3 go to crashlytics, 3 go to hockey app.

the main script uses 3 helper scripts to do this in a modular way: 
- the build.sh script produces the archive, a signed IPA and zipped DSYMs in a specified folder
- the uploadToCL script uploads an IPA & dsym to crashlytics, notifying a specific distribution group
- the uploadToHOCKEY script uploads an IPA & dsym to crashlytics, notifying previously invited users of the new release

###### The included release.sh is fully documented and should show to use the script

