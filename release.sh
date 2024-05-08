#!/usr/bin/env bash

set -e

OUTPUT_DIR=./update

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')
ONLYOFFICE_REPOS+=('sdkjs')
ONLYOFFICE_REPOS+=('web-apps')

for REPO in ${ONLYOFFICE_REPOS[*]}
do
    git clone https://github.com/$GITHUB_USER/$REPO.git
done

    ./update.sh

# URL=https://github.com/$GITHUB_USER/$OUTPUT_DIR/releases/download/${RELEASE_TAG}/${OUTPUT_FILE_NAME}
     
# cat << EOF >> release_hash.txt
# "Url: ${URL}"
# "Size: $(wc -c ${OUTPUT_FILE_NAME} | awk '{print $1}')"
# "md5sum: $(md5sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
# "sha256sum: $(sha256sum -b ${OUTPUT_FILE_NAME} | awk '{print $1}')"
# EOF

# git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/$GITHUB_USER/update.git ${OUTPUT_DIR}/update
# cd ${OUTPUT_DIR}/update
# git tag ${RELEASE_TAG}
# git push origin ${RELEASE_TAG}
# gh release create ${RELEASE_TAG} ../../${OUTPUT_FILE_NAME} ../../release_hash.txt
