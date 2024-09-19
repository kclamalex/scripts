#!/usr/bin/env/bash
# It is used for verifying downloaded package with gpg signature
check_command () {
	if ! command -v $1 &> /dev/null; then
	    echo "$1 could not be found"
	    exit 1
	fi

}

filepath=$1

if [ ! -f $filepath ]; then
    echo "$filepath not found!"
    exit 1
fi

folder=$( dirname "$filepath" )
filename=$( basename "$filepath" )

check_command gpg
check_command wget
check_command popd
check_command pushd

pushd $folder

read -p "Please enter the signing key link: " signing_key_link
wget -O key.asc --max-redirect 0 $signing_key_link
gpg --import key.asc 


echo $filename
read -p "Please enter the signature link: " signature_link
wget --trust-server-names --max-redirect 0 --output-document="$filename.asc" $signature_link
gpg --verify "$filename.asc"

rm key.asc
rm "$filename.asc"

popd

