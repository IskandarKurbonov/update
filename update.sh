#!/bin/bash

find ../$REPO -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" -o -name "*.php" \) \
  -not \( -path "$REPO/.git/*" -o -path "$REPO/.github/*" \) | while read -r file; do
    if grep -q "Copyright Ascensio System SIA" "$file"; then
        perl -i -0777 -pe 's|/\*.*?Copyright Ascensio System SIA.*?\*/||gs' "$file"
        echo "$file" >> success.log
        reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
    fi
done
