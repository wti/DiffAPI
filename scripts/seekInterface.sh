#!/usr/bin/env bash

all=()
find2ra all "/Volumes/beta/Applications/Xcode.app" -name \*.swiftinterface -type f
echo ${#all[@]}
for i in "${all[@]}"; do 
  [[ "$i" =~ oundat ]] && echo "$i"; 
done \
  | sed -n 's|.*/\([^/]*Foundation\).swiftmodule.*|\1|p' \
  | sort -u

echo "- 1: ${all[0]}"

