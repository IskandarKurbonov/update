#!/usr/bin/env bash

RELEASE_TAG=v${VERSION%.*}
OUTPUT_FILE_NAME=archive.zip

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')

for REPO in ${ONLYOFFICE_REPOS[*]}
do

    git clone --depth 1 https://github.com/$GITHUB_USER/$REPO.git

    find $REPO -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" -o -name "*.php" -o -name "*.rb" -o -name "*.py" -o -name "*.html" -o -name "*.bat" -o -name "*.sh" \) \
         | while read -r file; do
      if grep -q "Ascensio System SIA" "$file"; then
          perl -i -0777 -pe 's|/\*.*?Ascensio System SIA.*?\*/||gs' "$file"
          perl -i -0777 -pe 's|""".*?Ascensio System SIA.*?"""||gs' "$file"
          perl -i -0777 -pe 's|<!--.*?Ascensio System SIA.*?-->||gs' "$file"
          reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
      else
          reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
      fi
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
