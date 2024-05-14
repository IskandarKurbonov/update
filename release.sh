#!/usr/bin/env bash

MAIN_DIR=./update
REPO_TAG=v$VERSION
RELEASE_TAG=v${VERSION%.*}

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')
# ONLYOFFICE_REPOS+=('sdkjs')
# ONLYOFFICE_REPOS+=('web-apps')

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

    zip -r master.zip $REPO
    rm -rf $REPO

cat << DAO >> release_hash.txt
"Size: $(wc -c master.zip | awk '{print $1}')"
"md5sum: $(md5sum -b master.zip | awk '{print $1}')"
"sha256sum: $(sha256sum -b master.zip | awk '{print $1}')"
DAO

done


git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/update.git ./update/update
cd ./update/update
git tag ${RELEASE_TAG}
git push origin ${RELEASE_TAG}
gh release create ${RELEASE_TAG} ../../master.zip ../../release_hash.txt


