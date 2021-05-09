#
#!/bin/bash

echo "Setting Up Environment"
echo ""
export ARCH=arm64
export SUBARCH=arm64
export ANDROID_MAJOR_VERSION=r
export PLATFORM_VERSION=11.0.0

# Export KBUILD flags
export KBUILD_BUILD_USER=el0xren
export KBUILD_BUILD_HOST=heaven

# CCACHE
export CCACHE="$(which ccache)"
export USE_CCACHE=1
ccache -M 50G
export CCACHE_COMPRESS=1

# TC LOCAL PATH
#export CROSS_COMPILE=$(pwd)/gcc/bin/aarch64-linux-android-
#export CLANG_TRIPLE=$(pwd)/clang/bin/aarch64-linux-gnu-
#export CC=$(pwd)/clang/bin/clang

export CROSS_COMPILE=/home/el0xren/toolchain/linaro/bin/aarch64-linux-gnu-
export CLANG_TRIPLE=/home/el0xren/toolchain/clang/bin/aarch64-linux-gnu-
export CC=/home/el0xren//toolchain/clang/bin/clang

# Export toolchain/cross flags
#export TOOLCHAIN="aarch64-linux-android-"
#export CLANG_TRIPLE="aarch64-linux-gnu-"
#export CROSS_COMPILE="$(pwd)/gcc/bin/${TOOLCHAIN}"
#export CROSS_COMPILE_ARM32="$(pwd)/gcc32/bin/arm-linux-androideabi-"
#export WITH_OUTDIR=true

# Export PATH flag
#export PATH="${PATH}:$(pwd)/clang/bin:$(pwd)/gcc/bin:$(pwd)/gcc32/bin"

# Check if have gcc/32 & clang folder
#if [ ! -d "$(pwd)/gcc/" ]; then
#   git clone --depth 1 git://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc
#fi

#if [ ! -d "$(pwd)/gcc32/" ]; then
#   git clone --depth 1 git://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 gcc32
#fi

#if [ ! -d "$(pwd)/clang/" ]; then
#   git clone --depth 1 https://github.com/PrishKernel/toolchains.git -b proton-clang12 clang
#fi

clear
echo "                                                     "
echo "             _     _                     _       _   "
echo "  _ __  _ __(_)___| |__    ___  ___ _ __(_)_ __ | |_ "                                              
echo " | '_ \| '__| / __| '_ \  / __|/ __| '__| | '_ \| __|"                                              
echo " | |_) | |  | \__ \ | | | \__ \ (__| |  | | |_) | |_ "                                              
echo " | .__/|_|  |_|___/_| |_| |___/\___|_|  |_| .__/ \__|"
echo " |_|                                      |_|        "
echo "                                                     "
echo "            coded by Neel0210, DAvinash97, Durasame  "
echo "                                                     "
echo "Select"
echo "1 = Clear"
echo "2 = Clean Build"
echo "3 = Dirty Build"
echo "4 = Kernel+zip"
echo "5 = AIK+ZIP"
echo "6 = Anykernel"
echo "7 = Exit"
read n

if [ $n -eq 1 ]; then
echo "========================"
echo "Clearing & making clear"
echo "========================"
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/ramdisk-new.cpio.empty
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./PRISH/ZIP/PRISH/D/A50/boot.img
rm ./PRISH/AK/1.zip
rm -rf A50
fi

if [ $n -eq 2 ]; then
echo "==============="
echo "Building Clean"
echo "==============="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/ramdisk-new.cpio.empty
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./PRISH/ZIP/PRISH/D/A50/boot.img
rm ./PRISH/AK/*.zip
rm -rf A50
clear
############################################
# If other device make change here
############################################
echo "==============="
echo "Building Clean"
echo "==============="
make a50_defconfig
make -j$(nproc --all)
echo ""
echo "Kernel Compiled"
echo ""
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
fi

if [ $n -eq 3 ]; then
echo "============"
echo "Dirty Build"
echo "============"
############################################
# If other device make change here
############################################
make a50_defconfig
make -j$(nproc --all)
echo ""
echo "Kernel Compiled"
echo ""
rm ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
echo "====================="
echo "Dirty Build Finished"
echo "====================="
fi

if [ $n -eq 4 ]; then
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/ramdisk-new.cpio.empty
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./PRISH/ZIP/PRISH/D/A50/boot.img
rm ./PRISH/AK/*.zip
clear
############################################
# If other device make change here
############################################
echo "===="
echo "A50"
echo "===="
make a50_defconfig
make -j$(nproc --all)
echo "Kernel Compiled"
echo ""
echo "======================="
echo "Packing Kernel Into ZIP"
echo "======================="
echo ""
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
./PRISH/AIK/repackimg.sh
cp -r ./PRISH/AIK/image-new.img ./PRISH/ZIP/PRISH/D/A50/boot.img
cd PRISH/ZIP
echo "==========================="
echo "Packing Into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./PRISH/ZIP/1.zip ./output/CarbonKernel-A50-1.0.zip
cd output
echo ""
pwd
cd ..
echo " "
echo "======================================================="
echo "Get zip from upper given path"
echo "======================================================="
fi

if [ $n -eq 5 ]; then
echo "====================="
echo "Transfering Files"
echo "====================="
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./output/Pri*
cp -r ./arch/arm64/boot/Image ./output/Zimage/Image
cp -r ./arch/arm64/boot/Image ./AIK/split_img/boot.img-zImage
./PRISH/AIK/repackimg.sh
cp -r ./PRISH/AIK/image-new.img ./PRISH/ZIP/PRISH/D/A50/boot.img
cd PRISH/ZIP
echo " "
echo "==========================="
echo "Packing Into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./PRISH/ZIP/1.zip ./output/CarbonKernel-A50-1.0.zip
cd output
cd ..
echo " "
pwd
echo "======================================================"
echo "Get from upper given path"
echo "======================================================"
fi

if [ $n -eq 6 ]; then
echo "===================="
echo "ADDING IN ANYKERNEL"
echo "===================="
rm ./output/Any*
rm ./PRISH/AK/Image
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
cd PRISH/AK
echo " "
echo "=========================="
echo "Packing Into Anykernelzip"
echo "=========================="
./zip.sh
cd ../..
cp -r ./PRISH/AK/1*.zip ./output/CarbonKernel-A50-1.0.zip
cd output
cd ..
echo " "
pwd
echo "============================================"
echo "get Anykernel.zip from upper given path"
echo "============================================"
fi

if [ $n -eq 7 ]; then
echo "========"
echo "Exiting"
echo "========"
exit
fi
