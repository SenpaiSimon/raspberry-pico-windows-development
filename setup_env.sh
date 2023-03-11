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
admin=$($EXTSCRIPTS_PATH/adminCheck.bat)
if [[ "$admin" == 1 ]]; then
    echo -e "${RED}Please run as administrator!${NOCOLOR}"
    exit
fi

# ------------------------------------------------------------------------------------ #

rm -rf $FOLDER_NAME
echo "Downloading Git Repositories..."
echo ""
mkdir $FOLDER_NAME

cd $FOLDER_NAME
mkdir $TEMP_FOLDER

# ------------------------------------------------------------------------------------ #

echo "Updating pacman and installing packages..."
echo "Accept prompts if asked :)"
echo ""

pacman -Syu 
pacman -Su
pacman -S mingw-w64-x86_64-toolchain git make libtool pkg-config autoconf automake texinfo wget
echo ""

# ------------------------------------------------------------------------------------ #

echo "Pulling Pico-Sdk and Setting Path..."
git clone https://github.com/raspberrypi/pico-sdk.git -q
setx $SETXPARAM PICO_SDK_PATH "$SKRIPT_PATH/$FOLDER_NAME/pico-sdk" > nul
echo -e "${GREEN}Path for Pico-Sdk set!${NOCOLOR}"
echo ""

# ------------------------------------------------------------------------------------ #

echo "Pulling Pico-Examples..."
git clone https://github.com/raspberrypi/pico-examples.git -q
echo -e "${GREEN}Done${NOCOLOR}"
echo ""

# ------------------------------------------------------------------------------------ #

echo "Pulling Picotool..."
git clone https://github.com/raspberrypi/picotool.git -q
echo -e "${GREEN}Done${NOCOLOR}"
echo ""

# ------------------------------------------------------------------------------------ #

echo "Pulling Pimoroni-Libraries and setting path..."
git clone https://github.com/pimoroni/pimoroni-pico.git -q
setx $SETXPARAM PIMORONI_PICO_PATH "$SKRIPT_PATH/$FOLDER_NAME/pimoroni-pico" > nul
echo -e "${GREEN}Path for pimoroni-pico set!${NOCOLOR}"
echo ""

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
echo -e "${GREEN}Path for libusb set!${NOCOLOR}"
echo ""

# ------------------------------------------------------------------------------------ #

echo "Downloading gcc-arm-none-eabi Compiler and adding it to path"
echo ""
cd $SKRIPT_PATH/$FOLDER_NAME/$TEMP_FOLDER
wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-win32.zip
echo -e "Unzipping.. ${RED}(this may take some time)${NOCOLOR}"
unzip -q gcc-arm-none-eabi-10.3-2021.10-win32.zip > nul
echo -e "${GREEN}Done!${NOCOLOR}"

mv gcc-arm-none-eabi-10.3-2021.10 ..
cd $SKRIPT_PATH/$FOLDER_NAME/
posixPath="$SKRIPT_PATH/$FOLDER_NAME/gcc-arm-none-eabi-10.3-2021.10/bin"
gcc_Path=$(echo "$posixPath" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

bash $EXTSCRIPTS_PATH/refreshPath.sh > nul

echo ""
echo -e "${GREEN}gcc-arm-none-eabi Compiler added to your path variable! ${NOCOLOR}"
echo ""


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
cmake -G"MSYS Makefiles" .. > cmakeCompile.log
make
mv picotool.exe ../bin

posixPath="$SKRIPT_PATH/$FOLDER_NAME/picotool/bin"
clearPath=$(echo "$posixPath" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

# TODO COMMENT BACK IN
$EXTSCRIPTS_PATH/path.bat $clearPath $gcc_Path
bash $EXTSCRIPTS_PATH/refreshPath.sh > nul
echo ""
echo -e "${GREEN}Picotool added to your path variable! ${NOCOLOR}"

# ------------------------------------------------------------------------------------ #