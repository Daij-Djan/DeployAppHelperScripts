#
# $1 ipa path
# $2 crashlytics framework
# $3 api key
# $4 build secret
# $5 groupAliases

OUTPUT=/dev/stdout
#OUTPUT=/dev/null

#upload
echo "*** upload to crashlytics = $1, releasing to $5"
$2/submit $3 $4 -ipaPath "$1" -groupAliases "$5" -notifications YES > $OUTPUT || exit 1

#report
echo "*** uploaded $1"
