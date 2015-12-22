#
# $1 workspace_or_project_filename
# $2 scheme
# $3 workspace dir
# $4 dist dir

#optional, !required for ipa
# $5 provision profile

#OUTPUT=/dev/stdout
OUTPUT=/dev/null

if [[ $# -lt 5 ]]; then
echo "Usage: $0 workspace_or_project_filename scheme configuration workspace_dir distribution_dir" >&2
exit 1
fi

#0. cd to workspace
cd "$3" || exit 1

#1.: build the app and export it as archive
echo "*** build the app and export it as archive: scheme = $2 at at $4/app.xcarchive"

if [[ "$1" == *workspace ]]; then
xcodebuild -workspace "$1" -scheme "$2" archive -archivePath "$4/app.xcarchive" > $OUTPUT || exit 1
else
xcodebuild -project "$1" -scheme "$2" archive -archivePath "$4/app.xcarchive" > $OUTPUT || exit 1
fi

if [[ $# -lt 5 ]]; then
echo "*** built $2"
exit 0
fi

#2.: produce an ipa file
# Since -exportArchive without -exportOptionsPlist is deprecated we maybe
# should add a exportOptionsPlist. See http://www.matrixprojects.net/p/xcodebuild-export-options-plist
echo "*** produce an ipa file with profile = $5 at $4/app.ipa"
xcodebuild -exportArchive -exportFormat ipa -archivePath "$4/app.xcarchive" -exportPath "$4/app.ipa" -exportProvisioningProfile "$5" > $OUTPUT || exit 1

#3.zip DSYMS from archive
echo "*** produce zipped dSYM file at $4/app.dSYM.zip"
cd "$4/app.xcarchive/dSYMs/"
zip -r "../../app.dSYM.zip" * > $OUTPUT || exit 1
cd "../../../"
cd $3

#report
echo "*** built & made IPA for $2"
