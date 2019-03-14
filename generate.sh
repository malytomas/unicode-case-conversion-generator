#!/bin/bash

function generate
{

cat data/SpecialCasing.txt | \
sed -e 's/; /;/g' | \
awk 'BEGIN { FS=";" } $1 ~ /^#/ { next } $6 { next } $'$2'==$1 { next } $'$2'' | \
awk 'BEGIN { FS=";" } { split($'$2', a, " "); v = "0x"a[1]; for (i = 2; i <= length(a); i++) v = v", 0x"a[i]; printf "\t\tcase 0x%s: { static const std::uint32_t a[] = { %s, 0 }; return a; };\n", $1, v }' | \
cat - >> tmp.txt

cat data/UnicodeData.txt | \
sed -e 's/; /;/g' | \
awk 'BEGIN { FS=";" } $'$1'==$1 { next } $'$1'' | \
awk 'BEGIN { FS=";" } { printf "\t\tcase 0x%s: { static const std::uint32_t a[] = { 0x%s, 0 }; return a; };\n", $1, $'$1' }' | \
cat - >> tmp.txt

cat tmp.txt | sort -u -t: -k1,1 >> tmp2.txt
#cat tmp.txt >> tmp2.txt

echo "const std::uint32_t *$3(std::uint32_t value)" >> $4
echo "{" >> $4
echo "	switch (value)" >> $4
echo "	{" >> $4
cat tmp2.txt >> $4
echo "		default: return nullptr;" >> $4
echo "	}" >> $4
echo "}" >> $4

rm tmp.txt
rm tmp2.txt

}

rm -R gen
mkdir gen

generate 13 4 "unicodeUpperCase" "gen/upper.hpp"
generate 14 2 "unicodeLowerCase" "gen/lower.hpp"
generate 15 3 "unicodeTitleCase" "gen/title.hpp"
