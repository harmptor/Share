cd /config
echo -ne "# Powl's Home Assistant configuration: \n <div style='text-align: right'> `date +'%B %Y'` </div>\n\n## Total lines of code: " > README.md 
( find . -maxdepth 2 -name '*.yaml' -print0 | xargs -0 cat ) | wc -l >> README.md
echo -e "\nconsisting of HA:\n\n" >> README.md
find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\nand ESPHome:\n\n" >> README.md
find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
