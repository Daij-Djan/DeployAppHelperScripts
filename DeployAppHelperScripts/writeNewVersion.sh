#
# $1 plist

# $2 BUILD_VERSION pattern
# $3 1 based index of capture group to replace OR -1
# $4 J (tries jenkins BUILD_NUMBER) (or a fixed number or I for increase by 1)

# $5 USER_VERION pattern
# $6 index of capture group to replace OR -1
# $7 J (tries jenkins BUILD_NUMBER) (or a fixed number or I for increase by 1)
#

PLIST_PATH=$1

#handle build number
BUILD_VERSION_GROUP_INDEX=$3
if [[ $BUILD_VERSION_GROUP_INDEX != -1 ]] ; then
    BUILD_VERSION=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST_PATH"`
    BUILD_VERSION_PATTERN=$2

    if [[ $BUILD_VERSION =~ $BUILD_VERSION_PATTERN ]] ; then
        NEW_BUILD_VERSION=""

        for i in "${!BASH_REMATCH[@]}"
        do
            if [[ $i != 0 ]] ; then #0 is the whole string
                part=${BASH_REMATCH[$i]}
                if [[ $i == $BUILD_VERSION_GROUP_INDEX ]] ; then
                    if [[ $4 == "J" ]] ; then
						part=$BUILD_NUMBER
                    elif [[ $4 == "I" ]] ; then
	                    part=$((part+1))
                    else 
                    	part=$4
                    fi	
                fi
                NEW_BUILD_VERSION="$NEW_BUILD_VERSION$part"
            fi
        done
    fi

    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_BUILD_VERSION" "$PLIST_PATH"
fi

#handle visible number
USER_VERSION_GROUP_INDEX=$6
if [[ $USER_VERSION_GROUP_INDEX != -1 ]] ; then
    USER_VERSION=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST_PATH"`
    USER_VERSION_PATTERN=$5

    if [[ $USER_VERSION =~ $USER_VERSION_PATTERN ]] ; then
        NEW_USER_VERSION=""

        for i in "${!BASH_REMATCH[@]}"
        do
            if [[ $i != 0 ]] ; then #0 is the whole string
                part=${BASH_REMATCH[$i]}
                if [[ $i == $USER_VERSION_GROUP_INDEX ]] ; then
                    if [[ $7 == "J" ]] ; then
						part=$BUILD_NUMBER
                    elif [[ $7 == "I" ]] ; then
	                    part=$((part+1))
                    else 
                    	part=$7
                    fi	
                fi
                NEW_USER_VERSION="$NEW_USER_VERSION$part"
            fi
        done
    fi

  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_USER_VERSION" "$PLIST_PATH"
fi