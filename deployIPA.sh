#
# $1 scheme
# $2 configuration
# $3 workspace dir
# $4 dist dir

#optional, !required for ipa
# $5 provision profile

#optional, !required for upload
# $6 testflight upload token
# $7 testflight team token
#optional
# $8 testflight distribution list

if [[ $# -lt 4 ]]; then
echo "Usage: $0 scheme configuration workspace_dir distribution_dir" >&2
exit 1
fi

#0. cd to workspace
cd "$3" || exit 1

#1.: build the app and export it as archive
echo "build the app and export it as archive: $1, $2"
xcodebuild -scheme "$1" -configuration "$2" archive -archivePath "$4/$1.xcarchive" > /dev/null || exit 1


if [[ $# -lt 5 ]]; then
echo "Quit, IPA & testflight upload skipped"
exit 0
fi

#2.: produce an ipa file
echo "produce an ipa file: $5"
xcodebuild -exportArchive -exportFormat ipa -archivePath "$4/$1.xcarchive" -exportPath "$4/$1.ipa" -exportProvisioningProfile "$5" > /dev/null || exit 1

#3.zip DSYMS from archive
echo "produce zipped dSYM file"
cd "$4/$1.xcarchive/dSYMs/"
zip -r "$4/$1.dSYM.zip" * > /dev/null || exit 1

#4.cleanup
rm -r "$4/$1.xcarchive" || exit 1

if [[ $# -lt 7 ]]; then
echo "Quit, testflight upload skipped"
exit 0
fi

# 5. Testflight upload
if [[ $# -lt 8 ]]; then 
    echo "upload to testflight (no permissions)"

    /usr/bin/curl "http://testflightapp.com/api/builds.json" \
    -F file=@"$4/$1.ipa" \
    -F dsym=@"$4/$1.dSYM.zip" \
    -F api_token="$6" \
    -F team_token="$7" \
    -F notes="Build uploaded automatically from deploy script."> /dev/null  || exit 1
else
    echo "upload to testflight ($8)"

    /usr/bin/curl "http://testflightapp.com/api/builds.json" \
    -F file=@"$4/$1.ipa" \
    -F dsym=@"$4/$1.dSYM.zip" \
    -F api_token="$6" \
    -F team_token="$7" \
    -F distribution_lists="$8" \
    -F notes="Build uploaded automatically from deploy script."> /dev/null  || exit 1
fi

echo "done with $1, $2"
