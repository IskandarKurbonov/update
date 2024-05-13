#!/usr/bin/env bash

MAIN_DIR=./update

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')
ONLYOFFICE_REPOS+=('sdkjs')
ONLYOFFICE_REPOS+=('web-apps')

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
    
    for file in "$REPO"/*; do
        if [ -f "$file" ]; then
            echo "File: $file"
            echo "Size: $(wc -c "$file" | awk '{print $1}')"
            echo "md5sum: $(md5sum -b "$file" | awk '{print $1}')"
            echo "sha256sum: $(sha256sum -b "$file" | awk '{print $1}')"
        fi
    done >> "$REPO/release_hash.txt"

    zip -r master.zip $REPO
    rm -rf $REPO
done


