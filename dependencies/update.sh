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
rm -rf stata-misc
rm -rf sumup

# FTOOLS
wget -O master.zip https://github.com/sergiocorreia/ftools/archive/master.zip
unzip -q -j master.zip '*/src/*' -d ./ftools

# REGHDFE
wget -O master.zip https://github.com/sergiocorreia/reghdfe/archive/master.zip
unzip -q -j master.zip '*/src/*' -d ./reghdfe

# IVREGHDFE
wget -O master.zip https://github.com/sergiocorreia/ivreghdfe/archive/master.zip
unzip -q -j master.zip '*/*' -d ./ivreghdfe

# GTOOLS
wget -O master.zip https://github.com/mcaceresb/stata-gtools/archive/master.zip
unzip -q -j master.zip '*/build/*' -d ./gtools

# MISC STATA TOOLS (DOA, KOSI, MATA_FILEFILTER, HSHELL, etc)
wget -O master.zip https://github.com/sergiocorreia/stata-misc/archive/master.zip
# Only extract certain files; don't extract subdirectories
unzip -q -j master.zip '*.pkg' '*.ado' '*.toc' '*.sthlp' -x '*/*/*' -d ./stata-misc

wget -O master.zip https://github.com/matthieugomez/sumup.ado/archive/master.zip
unzip -q -j master.zip '*' -d ./sumup

rm master.zip

echo "==== Done! ===="
echo
