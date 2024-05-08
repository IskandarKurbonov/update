#!/usr/bin/env bash

set -e

OUTPUT_DIR=./update

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')
ONLYOFFICE_REPOS+=('sdkjs')
ONLYOFFICE_REPOS+=('web-apps')

for REPO in ${ONLYOFFICE_REPOS[@]}
do
  curl -H 'Authorization: token '$GITHUB_TOKEN \
  -H 'Accept: application/vnd.github.v3.raw' \
  -O \
  -s \
  -L https://github.com/$GITHUB_USER/$REPO/

done

ls -lha
pwd
tree
unzip main.zip
ls -lha
ls -lha main


  # Run update.sh script
  # chmod +x ./update.sh
  # ./update.sh $REPO

# URL=https://github.com/IskandarKurbonov/update/releases/download/${RELEASE_TAG}/${OUTPUT_FILE_NAME}
     
# cat << EOF >> release_hash.txt
# "Size: $(wc -c ${OUTPUT_FILE_NAME} | awk '{print $1}')"
# "md5sum: $(md5sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
# "sha256sum: $(sha256sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
# EOF

# git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/IskandarKurbonov/update.git ${OUTPUT_DIR}/update
# cd ${OUTPUT_DIR}/update
# git tag ${RELEASE_TAG}
# git push origin ${RELEASE_TAG}
# gh release create ${RELEASE_TAG} ../../${OUTPUT_FILE_NAME} ../../release_hash.txt
