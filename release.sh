#!/usr/bin/env bash

MAIN_DIR=./update
REPO_TAG=$VERSION
RELEASE_TAG=${VERSION%.*}
OUTPUT_FILE_NAME=$REPO_TAG.zip

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')

for REPO in ${ONLYOFFICE_REPOS[*]}
do

    git clone https://github.com/$GITHUB_USER/$REPO.git

    find $REPO -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" -o -name "*.php" -o -name "*.rb" -o -name "*.py" -o -name "*.html" -o -name "*.bat" -o -name "*.sh" \) \
        -not \( -path "$REPO/.git/*" -o -path "$REPO/.github/*" \) | while read -r file; do
      if grep -q "Ascensio System SIA" "$file"; then
          perl -i -0777 -pe 's|/\*.*?Ascensio System SIA.*?\*/||gs' "$file"
          perl -i -0777 -pe 's|""".*?Ascensio System SIA.*?"""||gs' "$file"
          perl -i -0777 -pe 's|<!--.*?Ascensio System SIA.*?-->||gs' "$file"
          reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
      else
          reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
      fi
    done

    zip -r -q ${OUTPUT_FILE_NAME} $REPO
    rm -rf $REPO

done

cat << EOF >> release_hash.txt
"Size: $(wc -c ${OUTPUT_FILE_NAME} | awk '{print $1}')"
"md5sum: $(md5sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
"sha256sum: $(sha256sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
EOF
