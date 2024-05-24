#!/usr/bin/env bash

RELEASE_TAG=v${VERSION%.*}
OUTPUT_FILE_NAME=archive.zip
BRANCH+=('main')
BRANCH+=('master')

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')

for REPO in ${ONLYOFFICE_REPOS[*]}; do
    for BRANCH in ${BRANCH[*]}; do
        wget https://github.com/$GITHUB_USER/$REPO/archive/refs/heads/$BRANCH.zip; then

        unzip $REPO-$BRANCH.zip

        mv $REPO-$BRANCH $REPO
    done

    find $REPO -type f \( \
        -name "*.aspx" \
        -o -name "*.bat" \
        -o -name "*.c" \
        -o -name "*.cs" \
        -o -name "*.css" \
        -o -name "*.cpp" \
        -o -name "*.cxx" \
        -o -name "*.h" \
        -o -name "*.html" \
        -o -name "*.java" \
        -o -name "*.js" \
        -o -name "*.jsp" \
        -o -name "*.m" \
        -o -name "*.mm" \
        -o -name "*.php" \
        -o -name "*.py" \
        -o -name "*.rb" \
        -o -name "*.sh" \
        -o -name "*.scss" \) | \
    while read -r file; do
        if grep -q "Copyright Ascensio System" "$file"; then
            perl -i -0777 -pe 's|/\*.*?Copyright Ascensio System.*?\*/||gs' "$file"
            perl -i -0777 -pe 's|""".*?Copyright Ascensio System.*?"""||gs' "$file"  
            perl -i -0777 -pe 's|<!--.*?Copyright Ascensio System.*?-->||gs' "$file"  
            perl -i -0777 -pe 's|^#.*?Copyright Ascensio System.*?$.*?^#.*?$||gs' "$file"  
            perl -i -0777 -pe 's|=begin.*?Copyright Ascensio System.*?=end||gs' "$file"  
            perl -i -0777 -pe 's|//.*?Copyright Ascensio System.*?$.*?//.*?$||gs' "$file"  
            perl -i -0777 -pe 's|//.*?Copyright Ascensio System.*?$.*?//.*?$||gs' "$file"
            perl -i -0777 -pe 's|REM.*?Copyright Ascensio System.*?$.*?REM.*?$||gs' "$file"  
        fi
        reuse annotate --year $YEAR --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
        perl -i -0777 -pe 's/^# Copyright Ascensio System SIA.*\n//gm' "$file"
    done
    
    rm -rf $REPO/.git*
    
    zip -r -q ${OUTPUT_FILE_NAME} $REPO
    rm -rf $REPO
done

cat << EOF >> release_hash.txt
"Size: $(wc -c ${OUTPUT_FILE_NAME} | awk '{print $1}')"
"md5sum: $(md5sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
"sha256sum: $(sha256sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
EOF
