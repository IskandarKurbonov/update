#!/usr/bin/env bash

MAIN_DIR=./update

ONLYOFFICE_REPOS=()
ONLYOFFICE_REPOS+=('document-server-integration')
ONLYOFFICE_REPOS+=('sdkjs')
ONLYOFFICE_REPOS+=('web-apps')

for REPO in ${ONLYOFFICE_REPOS[*]}
do
    ls -lha
    git clone https://github.com/$GITHUB_USER/$REPO.git
done


