#!/bin/bash
cd /config
echo -ne "# Powl's Home Assistant configuration: \n<p align="right"> $(date +"${1:-%Y.%m.%d %H:%M:%S}") </p>\n\n## Total lines of code: " > README.md 
( find . -maxdepth 2 -name '*.yaml' -print0 | xargs -0 cat ) | wc -l >> README.md
echo -e "\n<table>\n<tr valign="top"><td>\n\n| # | Home Assistant |\n| --: | -- |" >> README.md
find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\n</td><td>\n\n| # | ESPHome |\n| --: | -- |" >> README.md
find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\n</td></tr> </table>\n" >> README.md
sed -i -E -e "s/(\s*)([0-9]{1,5}) (\.\/)(\w*\/)?(\w*\/)?(\w*\/)?(\w*\/)?(.*\.yaml)/\1\2 [\5\6\7\8](\3\4\5\6\7\8)/" -e "s/(\s{2,10})([0-9]{1,5})/| \2 |/" -e "s/\| ([0-9]*) \| total/\| \*\*\1\*\* \| \*\*Total\*\*/" README.md
