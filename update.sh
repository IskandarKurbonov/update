#!/bin/bash

find /home/runner/work/update/update/$REPO -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" \) \
  -not \( -path "$REPO/.git/*" -o -path "$REPO/.github/*" \) | while read -r file; do
    if grep -q "Ascensio System SIA" "$file"; then
        perl -i -0777 -pe 's|/\*.*?Ascensio System SIA.*?\*/||gs' "$file"
        echo "$file" >> success.log
        reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="template" "$file"
    fi
done
