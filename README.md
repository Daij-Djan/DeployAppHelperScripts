deployIPA
=========

builds an xcode scheme, packs it to IPA and dSYM and uploads it to testflight

#the script 
the deployApp.sh script
  1. builds a scheme (in a given configuration)
  2. then it optionally makes an ipa out of it and also deliver the dSYM (the archive is replaced by ipa+dsymzip)
   - for this you have to provide a valid _provisioning profile_
  3. then it optionally uploads both to testflight
   - for this you have to provide your _testflight upload token_ as well as _testflight team token_
   - you optionally have the possibility to specify a distribution list to grant permissions to existing users
  
the this can be incorporated in a script and that be run by you or it can be set to run on a cron schedule (or the like) The script is quite self-contained and only needs the standard XCode tools installed on your OSX system

#example
An example script I use, builds and uploads 3 Versions of my App:

	DIST_DIR="$HOME/dist-$(date +%Y-%m-%d-%T)"
	WORKSPACE="$HOME/Documents/Sources/myApp-trunk/"
	PROFILE="Dominik Pich Distribution"
	TESTFLIGHT_UPLOAD_TOKEN="a670f3633ad7bf4799c749b1354e2707_ODQ2NTM4MjAxMy0wMS0yNSAwODoyMDoyNC44NTgzMDg"
	TESTFLIGHT_TEAM_TOKEN="bf7414395f50690993d2d339a53ac9fe_MTYzNDgxMjAxMi0xMi0wNiAwNDoxNDo0NS44NTA4OTg"
	TESTFLIGHT_LIST="myAppTestFlightList"
	
	
	mkdir "$DIST_DIR"
	
	./deployApp.sh "myApp" "Release" "$WORKSPACE" "$DIST_DIR" "$PROFILE" "$TESTFLIGHT_UPLOAD_TOKEN" "$TESTFLIGHT_TEAM_TOKEN" "$TESTFLIGHT_LIST" || exit 1
	./deployApp.sh "myApp" "Debug" "$WORKSPACE" "$DIST_DIR" "$PROFILE" "$TESTFLIGHT_UPLOAD_TOKEN" "$TESTFLIGHT_TEAM_TOKEN" "$TESTFLIGHT_LIST" || exit 1
	./deployApp.sh "myApp ServerTest" "Debug" "$WORKSPACE" "$DIST_DIR" "$PROFILE" "$TESTFLIGHT_UPLOAD_TOKEN" "$TESTFLIGHT_TEAM_TOKEN" "$TESTFLIGHT_LIST" || exit 1
	
	/usr/bin/open "https://testflightapp.com/dashboard/builds/"
    
#parameters
the parameters are to be given in order:<br/>
- 1 scheme
- 2 configuration
- 3 workspace dir
- 4 dist dir

optional, !required for ipa:<br/>
- 5 provision profile

optional, !required for upload:<br/>
- 6 testflight upload token
- 7 testflight team token

optional:<br/>  
- 8 testflight distribution list
