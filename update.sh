#!/bin/bash

FILE_FORMATS=".js|.java|.css|.php|.rb|.py|.html"

IGNORE_PATHS=".git|.github"

find ../$REPO -type f \( -name "*$FILE_FORMATS" \) \
  -not \( -path "$REPO/$IGNORE_PATHS*" \) | while read -r file; do
    if grep -q "Copyright Ascensio System SIA" "$file"; then
        perl -i -0777 -pe 's|/\*.*?Ascensio System SIA.*?\*/||gs' "$file"
        perl -i -0777 -pe 's|""".*?Ascensio System SIA.*?"""||gs' "$file"
        perl -i -0777 -pe 's|<!--.*?Ascensio System SIA.*?-->||gs' "$file"
        reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
    fi
done
