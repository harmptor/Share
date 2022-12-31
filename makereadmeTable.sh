# cd /config
echo -ne "# Share: \n `date +'%B %Y'`\n\n## Total lines of code: " > README.md 
( find . -maxdepth 2 -name '*.yaml' -print0 | xargs -0 cat ) | wc -l >> README.md
echo -e "\nconsisting of HA:\n\n| Section | Home Assistant |\n| -- | -- |" >> README.md
find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\nand ESPHome:\n\n| Section | ESPHome |\n| -- | -- |" >> README.md
find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
