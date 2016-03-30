#build script for all targets there are

#where the sources are
WORKSPACEDIR="`pwd`/myApp/"
PROJECT="myApp.xcworkspace"#can also be a project

#where to generate the output
DIST_DIR="`pwd`/__releases/dist-$(date)"
mkdir -p "$DIST_DIR"

#=================
# bump versions
#=================

#PLISTS
PLISTS[0]="./subpath/to/plist_for_scheme1_and_1a.plist"
#PLISTS[1]="./subpath/to/plist_for_scheme2_and_2a.plist"
#PLISTS[2]="./subpath/to/plist_for_scheme3_and_3a.plist"

#build & upload.
for plist in "${PLISTS[@]}"
do
    echo "Set new version for plist: $file"

	#increase the build no. AND increase the beta version
	#(in RL you'd increase either or :D and Also if you use jenkins, try the J option to take its job's BUILD_NUMBER)
    ./DeployAppHelperScripts/writeNewVersion.sh "$WORKSPACEDIR/$plist" "([0-9]*)"  1 I "(.* Beta_)([0-9]*)" 2 I
done

#=================
# Crashlytics
#=================

#where the Crashlytics framework is
CL_FRAMEWORK="$WORKSPACEDIR/Vendor/Crashlytics/Crashlytics.framework"

#the Crashlytics API Key & secret for your organization
CL_APIKEY="XXXXYYYYYZZZZ"
CL_SECRET="YYYYd12848d058be6bcecbe88148"

#group of testers
CL_TESTGROUPS="xyz-eg-first-responders"

#SCHEMES (name:provisioning_profile)
SCHEMES_CRASHLYTICS[0]="scheme 1 (for Fabric):ME myProvision profile 1 Distribution"
#SCHEMES_CRASHLYTICS[1]="scheme 2 (for Fabric):ME myProvision profile 2 Distribution"
#SCHEMES_CRASHLYTICS[2]="scheme 3 (for Fabric):ME myProvision profile 3 Distribution"

#build & upload.
for s in "${SCHEMES_CRASHLYTICS[@]}"
do
    IFS=':' read scheme profile <<< "$s"
    echo "Build & Upload Scheme: $scheme [$profile]"
    ./DeployAppHelperScripts/build.sh "$PROJECT" "$scheme" "$WORKSPACEDIR" "$DIST_DIR/$scheme" "$profile"
    ./DeployAppHelperScripts/uploadToCL.sh "$DIST_DIR/$scheme/app.ipa" "$CL_FRAMEWORK" "$CL_APIKEY" "$CL_SECRET" "$CL_TESTGROUPS"
done

#=================
# hockey app
#=================

#the hockey access token
HOCKEY_ACCESSTOKEN="XXXYYYZZZ"

#SCHEMES (name:provisioning_profile:appid)
SCHEMES_HOCKEY[0]="scheme 1a (for HOCKEYStore):ME myProvision profile 1 Distribution:XYZa2137c88b549"
#SCHEMES_HOCKEY[1]="scheme 2a (for HOCKEYStore):ME myProvision profile 2 Distribution:Zed1c13ae787ab3ae5ddb"
#SCHEMES_HOCKEY[2]="scheme 3a (for HOCKEYStore):ME myProvision profile 3 Distribution:X8a74bf4cfed86830ce7c1391"

#build & upload.
for s in "${SCHEMES_HOCKEY[@]}"
do
   IFS=':' read scheme profile appid <<< "$s"
   echo "Build & Upload Scheme: $scheme [$profile] -> ($appid)"
   ./DeployAppHelperScripts/build.sh "$PROJECT" "$scheme" "$WORKSPACEDIR" "$DIST_DIR/$scheme" "$profile"
   ./DeployAppHelperScripts/uploadToHOCKEY.sh "$DIST_DIR/$scheme/app.ipa" "$appid" "$HOCKEY_ACCESSTOKEN"
done
