#!/bin/bash

file=clean-$1
cp $1 $file

sed -i 's/,/;/g' $file
sed -i 's/\(^[0-9]*\);"/\1,"/g' $file
sed -i 's/";\([0-9]*.[0-9]*$\)/",\1/g' $file
sed -i 's/";$/",/g' $file

