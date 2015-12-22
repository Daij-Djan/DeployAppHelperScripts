#
# $1 ipa path
# $2 app id
# $3 access token

OUTPUT=/dev/stdout
#OUTPUT=/dev/null

#custom server replaces https://rink.hockeyapp.net IF wished

#upload
echo "*** upload to HOCKEY = $1"
curl -F "status=2" -F "notify=1" -F "ipa=@$1" -H "X-HockeyAppToken: $3" https://rink.hockeyapp.net/api/2/apps/$2/app_versions/upload > $OUTPUT || exit 1

#report
echo "*** uploaded $1"
