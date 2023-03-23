#!/bin/sh

SKRIPT_PATH=$(pwd);
EXTSCRIPTS_PATH="$SKRIPT_PATH/Scripts"
FOLDER_NAME="PicoEnviroment"
TEMP_FOLDER="TempDir"
# TODO add -m
SETXPARAM="-m"

# ------------------------------------------------------------------------------------ #

# Colors
RED='\033[0;31m'   #'0;31' is Red's ANSI color code
GREEN='\033[0;32m'   #'0;32' is Green's ANSI color code
YELLOW='\033[1;32m'   #'1;32' is Yellow's ANSI color code
BLUE='\033[0;34m'   #'0;34' is Blue's ANSI color code
NOCOLOR='\033[0m'

# ------------------------------------------------------------------------------------ #

# check for admin
# admin=$($EXTSCRIPTS_PATH/adminCheck.bat)
# if [[ "$admin" == 1 ]]; then
#     echo -e "${RED}Please run as administrator!${NOCOLOR}"
#     exit
# fi

# ------------------------------------------------------------------------------------ #

rm -rf $FOLDER_NAME
echo "Downloading Git Repositories..."
echo ""
mkdir $FOLDER_NAME

cd $FOLDER_NAME
mkdir $TEMP_FOLDER

# ------------------------------------------------------------------------------------ #

# echo "Updating pacman and installing packages..."
# echo "Accept prompts if asked :)"
# echo ""

# pacman -Syu 
# pacman -Su
# pacman -S mingw-w64-x86_64-toolchain git make libtool pkg-config autoconf automake texinfo wget
# echo ""

# printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Pulling Pico-Sdk and Setting Path..."
git clone https://github.com/raspberrypi/pico-sdk.git -q
cd $SKRIPT_PATH/$FOLDER_NAME/pico-sdk
git submodule update --init -q
setx $SETXPARAM PICO_SDK_PATH "$SKRIPT_PATH/$FOLDER_NAME/pico-sdk" > nul
export PICO_SDK_PATH="$SKRIPT_PATH/$FOLDER_NAME/pico-sdk" > nul
echo -e "${GREEN}Path for Pico-Sdk set!${NOCOLOR}"
echo ""

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Pulling Pico-Examples..."
git clone https://github.com/raspberrypi/pico-examples.git -q
echo -e "${GREEN}Done${NOCOLOR}"
echo ""

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Pulling Picotool..."
git clone https://github.com/raspberrypi/picotool.git -q
echo -e "${GREEN}Done${NOCOLOR}"
echo ""

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Pulling Pimoroni-Libraries and setting path..."
git clone https://github.com/pimoroni/pimoroni-pico.git -q
setx $SETXPARAM PIMORONI_PICO_PATH "$SKRIPT_PATH/$FOLDER_NAME/pimoroni-pico" > nul
export PIMORONI_PICO_PATH="$SKRIPT_PATH/$FOLDER_NAME/pimoroni-pico" > nul
echo -e "${GREEN}Path for pimoroni-pico set!${NOCOLOR}"
echo ""

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Downloading libusb for Windows and Setting Path..."
mkdir libusb
cd $SKRIPT_PATH/$FOLDER_NAME/$TEMP_FOLDER
wget https://github.com/libusb/libusb/releases/download/v1.0.26/libusb-1.0.26-binaries.7z -q

echo "Unzipping..."
7z x libusb-1.0.26-binaries.7z > nul

cp -r libusb-1.0.26-binaries/VS2015-x64/* ../libusb
cp -r libusb-1.0.26-binaries/libusb-MinGW-x64/* ../libusb

cd $SKRIPT_PATH/$FOLDER_NAME
setx $SETXPARAM LIBUSB_ROOT "$SKRIPT_PATH/$FOLDER_NAME/libusb" > nul
export LIBUSB_ROOT="$SKRIPT_PATH/$FOLDER_NAME/libusb" > nul
echo -e "${GREEN}Path for libusb set!${NOCOLOR}"
echo ""

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

# echo "Downloading gcc-arm-none-eabi Compiler"
# echo ""
# cd $SKRIPT_PATH/$FOLDER_NAME/$TEMP_FOLDER
# echo -e "Downloading.. ${RED}(this may take some time)${NOCOLOR}"
# wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-win32.zip -q
# echo -e "Unzipping.. ${RED}(this may take some time)${NOCOLOR}"
# unzip -q gcc-arm-none-eabi-10.3-2021.10-win32.zip > nul
# echo -e "${GREEN}Done!${NOCOLOR}"

# mv gcc-arm-none-eabi-10.3-2021.10 ..
# cd $SKRIPT_PATH/$FOLDER_NAME/
# posixPath="$SKRIPT_PATH/$FOLDER_NAME/gcc-arm-none-eabi-10.3-2021.10/bin"
# gccPath=$(echo "$posixPath" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

# printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Downloading cmake"
echo ""
cd $SKRIPT_PATH/$FOLDER_NAME/$TEMP_FOLDER
echo -e "Downloading.. ${RED}(this may take some time)${NOCOLOR}"
wget https://github.com/Kitware/CMake/releases/download/v3.26.0-rc6/cmake-3.26.0-rc6-windows-x86_64.zip -q
echo -e "Unzipping.. ${RED}(this may take some time)${NOCOLOR}"
unzip -q cmake-3.26.0-rc6-windows-x86_64.zip > nul
echo -e "${GREEN}Done!${NOCOLOR}"

mv cmake-3.26.0-rc6-windows-x86_64 ..
posixPath="$SKRIPT_PATH/$FOLDER_NAME/cmake-3.26.0-rc6-windows-x86_64/bin"
cmakePath=$(echo "$posixPath" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Downloading make"
echo ""
cd $SKRIPT_PATH/$FOLDER_NAME/$TEMP_FOLDER
mkdir make
echo -e "Downloading.. ${RED}(this may take some time)${NOCOLOR}"
wget https://deac-fra.dl.sourceforge.net/project/gnuwin32/make/3.81/make-3.81-bin.zip -q
unzip -q make-3.81-bin.zip -d make
echo -e "${GREEN}Done!${NOCOLOR}"

mv make ..
posixPath="$SKRIPT_PATH/$FOLDER_NAME/make/bin"
makePath=$(echo "$posixPath" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Downloading Zadig"
echo ""
cd $SKRIPT_PATH/$FOLDER_NAME
wget https://github.com/pbatard/libwdi/releases/download/v1.5.0/zadig-2.8.exe -q
echo -e "${GREEN}Done!${NOCOLOR}"

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Compiling PicoTool..."

echo ""
echo -e "${RED}IMPORTANT NOTE${NOCOLOR}"
echo -e "If you want to use ${BLUE}-f${NOCOLOR} option on Windows you need to now edit the main.cpp"
posixPath="$SKRIPT_PATH/$FOLDER_NAME/picotool/main.cpp"
echo -e "The file is: ${GREEN}$posixPath${NOCOLOR}"
echo -e "Edit line ${GREEN}301${NOCOLOR} to say ${BLUE}#if defined(_WIN32)${NOCOLOR} and not ${RED}#if !defined(_WIN32)${NOCOLOR}"
echo ""

echo "Press any key if you are done..."
# wait for keypress
read -n 1 s
echo "Continuing!"

cd $SKRIPT_PATH/$FOLDER_NAME/picotool
mkdir build
mkdir bin
cd $SKRIPT_PATH/$FOLDER_NAME/picotool/build
touch cmakeCompile.log
$EXTSCRIPTS_PATH/path.bat $cmakePath > nul
cmake -G"MSYS Makefiles" .. > cmakeCompile.log
$EXTSCRIPTS_PATH/path.bat $makePath > nul
make
mv picotool.exe ../bin

posixPath="$SKRIPT_PATH/$FOLDER_NAME/picotool/bin"
picotoolPath=$(echo "$posixPath" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo "Cleaning up..."
cd $SKRIPT_PATH/$FOLDER_NAME
rm -rf $TEMP_FOLDER
echo "All done :)"

printf "\n${BLUE}-----------------------------------------------------${NOCOLOR}\n"

# ------------------------------------------------------------------------------------ #

echo ""
echo -e "${RED}IMPORTANT NOTE${NOCOLOR}"
echo "Add the following paths to your windows path variable"
echo ""
# echo "$gccPath"
echo "$cmakePath"
echo "$makePath"
echo "$picotoolPath"