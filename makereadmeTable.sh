# cd /config
echo -ne "# Share: \n `date +'%B %Y'`\n\n## Total lines of code: " > README.md 
( find . -maxdepth 2 -name '*.yaml' -print0 | xargs -0 cat ) | wc -l >> README.md
echo -e "\n<table>\n<tr valign="top"><td>\n\n| # | Home Assistant |\n| --: | -- |" >> README.md
find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\n</td><td>\n\n| # | ESPHome |\n| --: | -- |" >> README.md
find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\n</td></tr> </table>\n" >> README.md
