#!/bin/bash

##################################################################################
#    build-zlib.sh usage:
#	$ ./build-zlib.sh api=21 
#	- api=21:	specify the version number of android API 9, 12, ...
#	Note: Arguments order should stictly be followed
###################################################################################

oldPWD=$PWD
cd ../zlib
currPWD=$PWD
outputDir=$currPWD/../prebuilt-libs/zlib
orgPATH=$PATH

export ANDROID_NDK="/Users/wangyinuo/env/ndk-r16b/"

APIn=21
if [[ -n "$1" ]]; then 
	APIn=${1#*=};
fi

archlist=$(ls $ANDROID_NDK/platforms/android-$APIn);

for andrarch in $archlist
do
	case $andrarch in
		arch-arm)
			ARCH=arm
			ARCHTOOLCHAIN=arm-linux-androideabi-4.9
			CROSSCOMPILER=arm-linux-androideabi
			;;
		arch-arm64)
			ARCH=arm64
			ARCHTOOLCHAIN=aarch64-linux-android-4.9
			CROSSCOMPILER=aarch64-linux-android
			;;
		arch-x86)
			ARCH=x86
			ARCHTOOLCHAIN=x86-4.9
			CROSSCOMPILER=i686-linux-android
			;;
	esac
	echo "###################################################"
	echo "# Build zlib for android-$APIn arch $ARCH"
	echo "###################################################"
	make clean
	PATH=$ANDROID_NDK/toolchains/$ARCHTOOLCHAIN/prebuilt/darwin-x86_64/bin:$orgPATH
	CC=${CROSSCOMPILER}-gcc
	AR=${CROSSCOMPILER}-ar
	AS=${CROSSCOMPILER}-as
	LD=${CROSSCOMPILER}-ld
	RANLIB=${CROSSCOMPILER}-ranlib
	NM=${CROSSCOMPILER}-nm
	CFLAGS="--sysroot=${ANDROID_NDK}/platforms/android-${APIn}/${andrarch}"
	./configure --prefix=$outputDir/android-$APIn/$ARCH
	make
	make install
done

cd $oldPWD