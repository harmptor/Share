# Share:
<p align=right> 2022.12.31 17:43:51 </p>

```bash
#!/bin/bash
cd /config
echo -ne "# Powl's Home Assistant configuration: \n<p align="right"> $(date +"${1:-%Y.%m.%d %H:%M:%S}") </p>\n\n## Total lines of code: " > README.md 
( find . -maxdepth 2 -name '*.yaml' -print0 | xargs -0 cat ) | wc -l >> README.md
echo -e "\n<table>\n<tr valign="top"><td>\n\n| # | HA |\n| --: | -- |" >> README.md
find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\n</td><td>\n\n| # | ESPHome |\n| --: | -- |" >> README.md
find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
echo -e "\n</td></tr> </table>\n" >> README.md
sed -i -E -e "s/(\s*)([0-9]{1,5}) (\.\/)(\w*\/)?(\w*\/)?(\w*\/)?(\w*\/)?(.*\.yaml)/\1\2 [\5\6\7\8](\3\4\5\6\7\8)/" -e "s/(\s{2,10})([0-9]{1,5})/| \2 |/" -e "s/\| ([0-9]*) \| total/\| \*\*\1\*\* \| \*\*Total\*\*/" README.md
```
<details><summary>Line 1</summary>
<p>

```
echo -ne "# Powl's Home Assistant configuration: \n<p align="right"> $(date +"${1:-%Y.%m.%d %H:%M:%S}") </p>\n\n## Total lines of code: " > README.md 
```
echoes the strin and writes to README.md

flag `-e` means `\n` is expanded to a newline character instead of being literally printed

flag `-n` means no trailing new line.

resulting in
```
# Powl's Home Assistant configuration: 
<p align="right"> $(date +"${1:-%Y.%m.%d %H:%M:%S}") </p>

## Total lines of code: 
```
where `$(date + "")` renders current date in format given by `$1` or the default `%Y.%m.%d %H:%M:%S` if none given. 

(`$1` is BLABLA when executing `user@device: /home/ $ makereadme.sh BLABLA`)

Resulting in:

# Powl's Home Assistant configuration: 
<p align="right"> 2023.01.01 13:37:00 </p>

## Total lines of code: 


</p>
</details>


<details><summary>Line 2</summary>
<p>

```bash
( find . -maxdepth 2 -name '*.yaml' -print0 | xargs -0 cat ) | wc -l >> README.md
```
finds all files in `.` (here)

 max depth means only subdirs of that depth. I want files of current dir and one dir below (i.e. esphome)

 `-name` specifies the file name

 `-print0` means don't print to stdout I guess lol

 all that is piped via `cat` to `wc -l` which counts the total number of lines in all files that were found.
 
</p>
</details>


<details><summary>Line 3</summary>
<p>

### We want two tables, HA and ESPHome, nested inside a bigger table.
Tables in markdown look like this:
```
|  Title1  | Title2 |
| -------- | ------ |   <--- can specify horiz column alignment 
|  myrow1  | mydata |         with a colon on either side, see example
```

two of which are put into this html thingy

```html
<table>
<tr valign=top><td>   <--- this align prevents the shorter table from 
    mytable1                  scooting halfway down and looking ugly af lol
</td><td>
    mytable2
</td></tr>
</table>
```
so we begin to print

```bash
echo -e "\n<table>\n<tr valign="top"><td>\n\n| # | HA |\n| --: | -- |" >> README.md
```
resulting in
```
▐
<table>
<tr valign="top"><td>

|  #  | HA |
| --: | -- |
```
</p>
</details>



<details><summary>Line 4</summary>
<p>

```bash
find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
```
pretty self explanatory, finds files, counts lines, sorts numerically, writes

output looks like this:
```
User@DESKTOP: /home/config $ find . -maxdepth 1 -name '*.yaml' | xargs wc -l | sort -nr
  7934 total
  3435 ./automations.yaml
  1825 ./scripts.yaml
   802 ./automations-telegram.yaml
   300 ./configuration.yaml
etc...
```

</p>
</details>

<details><summary>Line 5</summary>
<p>
```bash
echo -e "\n</td><td>\n\n| # | ESPHome |\n| --: | -- |" >> README.md
```
same shit again, prints

```
▐
</td><td>   <-- divider between table1 and table2

|  #  | ESPHome |
| --: | -- |

```

</p>
</details>


<details><summary>Line 6</summary>
<p>

```bash
find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr >> README.md
```

again, self explanatory, finds files in subdir `esphome/ ` 

stdout is:

```
User@DESKTOP: /home/config $ find ./esphome -maxdepth 2 -name '*.yaml' | xargs wc -l | sort -nr
  2591 total
   572 ./esphome/gerald.yaml
   274 ./esphome/cora.yaml
   262 ./esphome/frieder.yaml
   237 ./esphome/berta.yaml
etc...
```

</p>
</details>

<details><summary>Line 7</summary>
<p>

```bash
echo -e "\n</td></tr> </table>\n" >> README.md
```

bruh

```
▐
</td></tr> </table>     <-- end of tableception
```

</p>
</details>



<details><summary>Line 8</summary>
<p>

Sed enables regex operations on files. Usually sed outputs to stdout, but

flag `-i` makes it write to the file it is reading from

falg `-E` enables extended patterns, used for grouping patterns with `(...)` and later referring to them with `\1` etc.

flag `-e` is just an identifyer of a regex pattern we wanna apply. We use it three times

```bash
sed -i -E 
-e "s/(\s*)([0-9]{1,5}) (\.\/)(\w*\/)?(\w*\/)?(\w*\/)?(\w*\/)?(.*\.yaml)/\1\2 [\5\6\7\8](\3\4\5\6\7\8)/" 
-e "s/(\s{2,10})([0-9]{1,5})/| \2 |/" 
-e "s/\| ([0-9]*) \| total/\| \*\*\1\*\* \| \*\*Total\*\*/" README.md
```

We want to replace text (`s`), so we use `-e "s/ search_pattern / replace_with /"`

## First pattern: Place links to the files

We can place links using this syntax: `[prettyname](link/to/file)`

Replace `(\s*)([0-9]{1,5}) (\.\/)(\w*\/)?(\w*\/)?(\w*\/)?(\w*\/)?(.*\.yaml)`

with `\1\2 [\5\6\7\8](\3\4\5\6\7\8)`

```
  7918 total
  3435 ./automations.yaml
   572 ./esphome/gerald.yaml
\1 \2  \3  \4\7      \8
```

`\1` contains `\s*` which is an arbitrary amount of whitespaces that are followed by a number (in \2). But regex is a greedy cunt so it takes em all lol

`\2` contains `[0-9]{1,5}` which is one to five digits, remember, greedy. This is the amount of lines in the file we're currently looking at.

`\3` contains `\.\/` which is just a full stop and a forwardslash, but both need to be escaped (coz `.` is *any* char)

`\4,\5,\6,\7` *can* contain `\w*\/` (quantified by ?, so either 0 or 1 occurance) which means an arbitrary amount of word chars, followed by a forwardslash. This is all subdirectories, **if there are any**.

finally, `\8` contains `.*\.yaml` which is any amount of any character followed by `.yaml` The filename.

After this, our text looks like this

```
  7918 total
  3435 [automations.yaml](./automations.yaml)
   572 [gerald.yaml](./esphome/gerald.yaml)
\1 \2  [ \5\6\7\8  ](    \3\4\5\6\7\8     )
```
Notice in the square brackets we intentionally left out some path variables but kept others.
We don't want `\3\4` (`./` and `esphome/`) but do wan't `\5\6\7`, because those can store any path beyond `esphome/`, for example esphome's subdir `common/`.
<details><summary>Have a look if you need</summary>
<p>

```
    1 ./esphome/common/build_path.yaml 
translates to:
    1 [common/build_path.yaml](./esphome/common/build_path.yaml)
\1 \2 [       \5\6\7\8       ](          \3\4\5\6\7\8          )
```
</p>
</details>

## Second pattern. Put pipes around line numbers

Replace `(\s{2,10})([0-9]{1,5})` with `| \2 |`

We lose `\1` which are the whitespaces and place pipes around `\2`. Bish bash bosh

Look rn:
```
| 7918 | total
| 3435 | [automations.yaml](./automations.yaml)
| 1825 | [scripts.yaml](./scripts.yaml)
```

## Third pattern. Make the titles bold face

> `s/\| ([0-9]*) \| total/\| \*\*\1\*\* \| \*\*Total\*\*/`

Replace `\| ([0-9]*) \| total` with `\| \*\*\1\*\* \| \*\*Total\*\*`

Find text `| xxxx | total` and put \*\*s around. We need to escape all asterisks because else they'd be quantifiers, obv. 


</p>
</details>