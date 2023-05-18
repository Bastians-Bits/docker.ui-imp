#!/bin/bash
# requieres md5
# requieres basename

function calc_version() {
    local archive_dir=$1
    local date=$(date +"%Y.%m.%d")

    # Check if there was already a release today
    # If not, return a new one
    if [[ ! $(ls $archive_dir) =~ $date ]]; then
        echo ${date}a
        exit 0
    fi

    # Get latest version from today
    local previous=$(ls $archive_dir | grep -E -i -o $date"\w{1}" | grep -E -i -o "[a-z]{1}" | sort)
    local latest=$(echo "$previous" | tail -n 1)
    
    # Check if end of alphabet
    if [ "$latest" == "z" ]; then
        exit 1
    fi

    # Increase to the next letter
    local next=$(echo "$latest" | tr "0-9a-z" "1-9a-z_")
    echo ${date}${next}
    exit 0
}

TARGET=./archive/
SOURCE=./source/
NAME=$(basename $(ls *.plg) .plg)
VERSION=$(calc_version $TARGET)

if [ -z $VERSION ]; then
    echo "Could not calculate version"
    exit 1
fi

NEXT=${NAME}-${VERSION}.txz

# Create the txt archive
cd ${SOURCE}
tar -cJf ../${TARGET}${NEXT} .
cd -

# Get the checksum of the archive
CHECKSUM=$(md5 -q ${TARGET}${NEXT})

# Edit the plg file to include the new version and checksum
OLD_VERSION=$(grep "<!ENTITY version" *.plg)
OLD_CHECKSUM=$(grep  "<!ENTITY md5" *.plg)

sed -i '' "s/${OLD_VERSION}/    <!ENTITY version \"${VERSION}\">/g" *.plg
sed -i '' "s/${OLD_CHECKSUM}/    <!ENTITY md5 \"${CHECKSUM}\">/g" *.plg
