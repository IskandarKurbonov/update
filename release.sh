#!/usr/bin/env bash

OUTPUT_FILE_NAME=archive.zip

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')

for REPO in ${ONLYOFFICE_REPOS[*]}; do
    git clone --depth 1 https://github.com/$GITHUB_USER/$REPO.git

    find $REPO -type f \( \
        -name "*.js" -o -name "*.java" -o -name "*.css" -o -name "*.php" -o \
        -name "*.rb" -o -name "*.py" -o -name "*.html" -o -name "*.bat" -o \
        -name "*.sh" -o -name "*.scss" -o -name "*.cs" -o -name "*.cpp" -o \
        -name "*.jsp" \) | \
    while read -r file; do
        if grep -q "Copyright Ascensio System SIA 2024" "$file"; then
            perl -i -0777 -pe 's|/\*[^*]*\*+([^/*][^*]*\*+)*/||gs' "$file"
            perl -i -0777 -pe 's|"""(?:[^"]|"(?!"))*"""||gs' "$file"
            perl -i -0777 -pe 's|<!--(?:[^-]|-(?!->))*-->||gs' "$file"
            perl -i -0777 -pe 's|^#(?:.*?Copyright Ascensio System SIA 2024.*?$(?:\n?))*||gsm' "$file"
            perl -i -0777 -pe 's|=begin(?:.|\n)*?=end||gs' "$file"
            perl -i -0777 -pe 's|//(?:.*?Copyright Ascensio System SIA 2024.*?$(?:\n?))*||gsm' "$file"
            perl -i -0777 -pe 's|REM(?:.*?Copyright Ascensio System SIA 2024.*?$(?:\n?))*||gsm' "$file"
        fi
        reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
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
