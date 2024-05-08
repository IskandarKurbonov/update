#!/bin/bash

for file in $(find "$REPO" -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" -o -name "*.php" -o -name "*.rb" -o -name "*.py" -o -name "*.html" -o -name "*.bat" -o -name "*.sh" \) \
  -not \( -path "$REPO/.git/*" -o -path "$REPO/.github/*" \)); do
    if grep -q "Ascensio System SIA" "$file"; then
        perl -i -0777 -pe 's|/\*.*?Ascensio System SIA.*?\*/||gs' "$file"
        perl -i -0777 -pe 's|""".*?Ascensio System SIA.*?"""||gs' "$file"
        perl -i -0777 -pe 's|<!--.*?Ascensio System SIA.*?-->||gs' "$file"
        reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
    else
        reuse annotate --year 2024 --license Ascensio-System --copyright="Ascensio System SIA" --template="license" "$file"
    fi
done
