#!/usr/bin/env bash

RELEASE_TAG=v${VERSION%.*}
OUTPUT_FILE_NAME=archive.zip
MASTER=master.zip

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')

for REPO in ${ONLYOFFICE_REPOS[*]}; do
    wget https://github.com/$GITHUB_USER/$REPO/archive/refs/heads/$MASTER

    unzip $MASTER

    mv $REPO-master $REPO

    find $REPO -type f \( \
        -name "*.js" -o -name "*.java" -o -name "*.css" -o -name "*.php" -o \
        -name "*.rb" -o -name "*.py" -o -name "*.html" -o -name "*.bat" -o \
        -name "*.sh" -o -name "*.scss" -o -name "*.cs" -o -name "*.cpp" -o  \
        -name "*.jsp" -o -name "*.aspx" -o -name "*.ejs" -o -name "*.c" -o \
        -name "*.h" -o -name "*.cxx" -o -name "*.m" -o -name "*.mm" \) | \
    while read -r file; do
        if grep -q "Ascensio System SIA" "$file"; then
            perl -i -0777 -pe 's|/\*.*?Ascensio System SIA.*?\*/||gs' "$file"
            perl -i -0777 -pe 's|""".*?Ascensio System SIA.*?"""||gs' "$file"  
            perl -i -0777 -pe 's|<!--.*?Ascensio System SIA.*?-->||gs' "$file"  
            perl -i -0777 -pe 's|^#.*?Ascensio System SIA.*?$.*?^#.*?$||gs' "$file"  
            perl -i -0777 -pe 's|=begin.*?Ascensio System SIA.*?=end||gs' "$file"  
            perl -i -0777 -pe 's|//.*?Ascensio System SIA.*?$.*?//.*?$||gs' "$file"  
            perl -i -0777 -pe 's|//.*?Ascensio System SIA.*?$.*?//.*?$||gs' "$file"
            perl -i -0777 -pe 's|REM.*?Ascensio System SIA.*?$.*?REM.*?$||gs' "$file"  
        fi
        reuse annotate --year $YEAR --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
        perl -i -0777 -pe 's/^# Copyright Ascensio System SIA.*\n//gm' "$file"
        perl -i -0777 -pe 's/^* Copyright Ascensio System SIA.*\n//gm' "$file"
    done
    find $REPO -type f -name "onlyoffice.header" -exec reuse annotate --style=css --year $YEAR --license Ascensio-System --copyright="Ascensio System SIA" --template="license" {} \;
    
    rm -rf $REPO/.git*
    
    zip -r -q ${OUTPUT_FILE_NAME} $REPO
    rm -rf $REPO
done

cat << EOF >> release_hash.txt
"Size: $(wc -c ${OUTPUT_FILE_NAME} | awk '{print $1}')"
"md5sum: $(md5sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
"sha256sum: $(sha256sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
EOF
