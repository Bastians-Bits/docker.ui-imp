#!/bin/bash
# requieres md5
# requieres basename

PLUGIN=$1

function calc_version() {
    local archive_dir=$1
    local date=$(date +"%Y.%m.%d")

    # Check if there was already a release today
    # If not, return a new one
    if [[ ! $(ls $archive_dir) =~ $date ]]; then
        echo ${date}a
        exit 0
    fi

    # Get all versions (only the characters after the current date)
    local previous=$(ls $archive_dir | grep -E -i -o $date"\w+" | grep -E -i -o "[a-z]+" | sort)
    # Get the latest version
    local latest=$(echo "$previous" | tail -n 1)
    # Get the latest character (if already looped)
    local latest_char=$(echo ${latest:(-1)})
    
    if [ "$latest_char" == "z" ]; then
        # Loop ...
        echo ${date}${latest}a
        exit 0
    else
        # ... or increase
        local next=$(echo "$latest_char" | tr "0-9a-z" "1-9a-z_")
        echo ${date}$(echo $latest | sed "s/.$/${next}/" )
        exit 0
    fi
}

TARGET=./archive/${PLUGIN}/
SOURCE=./${PLUGIN}/source/
NAME=$(basename $(ls ${PLUGIN}/*.plg) .plg)

# Create the archive directory if not yet exists
if [ ! -d ${TARGET} ]; then mkdir ${TARGET}; fi

VERSION=$(calc_version $TARGET)

if [ -z $VERSION ]; then
    echo "Could not calculate version"
    exit 1
fi

NEXT=${NAME}-${VERSION}.txz

# Create the txt archive
cd ${SOURCE}
tar -cJf ../../${TARGET}${NEXT} .
cd -

# Get the checksum of the archive
CHECKSUM=$(md5 -q ${TARGET}${NEXT})

# Edit the plg file to include the new version and checksum
OLD_VERSION=$(grep "<!ENTITY version" ${PLUGIN}/*.plg)
OLD_CHECKSUM=$(grep  "<!ENTITY md5" ${PLUGIN}/*.plg)

sed -i '' "s/${OLD_VERSION}/    <!ENTITY version \"${VERSION}\">/g" ${PLUGIN}/*.plg
sed -i '' "s/${OLD_CHECKSUM}/    <!ENTITY md5 \"${CHECKSUM}\">/g" ${PLUGIN}/*.plg
