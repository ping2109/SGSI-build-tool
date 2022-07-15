#!/bin/bash

LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR

systemdir="../../out/system/system"
configdir="../../out/config"

rm -rf $systemdir/lib/vndk-29 $systemdir/lib/vndk-sp-29
rm -rf $systemdir/lib/vndk-30 $systemdir/lib/vndk-sp-30
rm -rf $systemdir/lib64/vndk-29 $systemdir/lib64/vndk-sp-29
rm -rf $systemdir/lib64/vndk-30 $systemdir/lib64/vndk-sp-30

ln -s  /apex/com.android.vndk.v29/lib $systemdir/lib/vndk-29
ln -s  /apex/com.android.vndk.v30/lib $systemdir/lib/vndk-30
ln -s  /apex/com.android.vndk.v29/lib $systemdir/lib/vndk-sp-29
ln -s  /apex/com.android.vndk.v30/lib $systemdir/lib/vndk-sp-30

ln -s  /apex/com.android.vndk.v29/lib64 $systemdir/lib64/vndk-29
ln -s  /apex/com.android.vndk.v30/lib64 $systemdir/lib64/vndk-30
ln -s  /apex/com.android.vndk.v29/lib64 $systemdir/lib64/vndk-sp-29
ln -s  /apex/com.android.vndk.v30/lib64 $systemdir/lib64/vndk-sp-30

rm -rf $systemdir/apex/com.android.vndk.current*
7z x ./com.android.vndk.current.apex.7z -o$systemdir/apex/ > /dev/null 2>&1
mkdir -p $systemdir/system_ext/apex
7z x ./com.android.vndk.v29.apex.7z -o$systemdir/system_ext/apex/ > /dev/null 2>&1
