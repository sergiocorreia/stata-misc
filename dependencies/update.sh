#!/bin/bash
# unzip:
#  -q is quiet mode
#  -j does not preserve relative paths

clear
set -e
echo
echo "==== Download Stata programs from Github ===="
echo

rm -rf ftools
rm -rf gtools
rm -rf reghdfe
rm -rf ivreghdfe
rm -rf sumup

wget -O master.zip https://github.com/sergiocorreia/ftools/archive/master.zip
unzip -q -j master.zip '*/src/*' -d ./ftools

wget -O master.zip https://github.com/sergiocorreia/reghdfe/archive/master.zip
unzip -q -j master.zip '*/src/*' -d ./reghdfe

wget -O master.zip https://github.com/sergiocorreia/ivreg2_demo/archive/master.zip
unzip -q -j master.zip '*/*' -d ./ivreghdfe

wget -O master.zip https://github.com/mcaceresb/stata-gtools/archive/master.zip
unzip -q -j master.zip '*/build/*' -d ./gtools

wget -O master.zip https://github.com/matthieugomez/sumup.ado/archive/master.zip
unzip -q -j master.zip '*' -d ./sumup

rm master.zip

echo "==== Done! ===="
echo