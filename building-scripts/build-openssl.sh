#!/bin/bash

#################################################################################
#    build-openssl.sh usage:
#	$ ./build-openssl.sh api=21
#	- api=21:	specify the version number of android API 
#	Note: Arguments order should stictly be followed
##################################################################################

oldPWD=$PWD
cd ../openssl
currPWD=$PWD
outputDir=$currPWD/../prebuilt-libs/openssl
orgPATH=$PATH
export ANDROID_NDK="/Users/wangyinuo/env/ndk-r16b"

openssl_options="no-asm no-cast no-idea no-camellia no-whirlpool"
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
			;;
		arch-arm64)
			ARCH=arm64
			ARCHTOOLCHAIN=aarch64-linux-android-4.9
			;;
		arch-x86)
			ARCH=x86
			ARCHTOOLCHAIN=x86-4.9
			;;
			
	esac
	echo "###################################################"
	echo "# Build openssl for android-$APIn arch $ARCH"
	echo "###################################################"
	make clean
	PATH=$ANDROID_NDK/toolchains/$ARCHTOOLCHAIN/prebuilt/darwin-x86_64/bin:$orgPATH
	./Configure android-$ARCH -D__ANDROID_API__=$APIn $openssl_options --prefix=$outputDir/android-$APIn/$ARCH
	make
	make install
done


cd $oldPWD

