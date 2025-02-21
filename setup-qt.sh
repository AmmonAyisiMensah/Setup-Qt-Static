#!/bin/bash

####################################################################################################
#                  ONLY MAKE CHANGES TO THE QT_VERSION and QT_DEV_DIR VARIABLE !                   #
####################################################################################################



# Change this varable to the right release tag, see here: https://github.com/qt/qt5/tags
QT_VERSION=6.5.4-lts-lgpl

# Change this variable to the right output location for the sources and builds
QT_DEV_DIR=$HOME/dev



####################################################################################################



# Qt label for the directory and messages
QT_MAJOR_VERSION=$(echo $QT_VERSION | cut -d. -f1)
QT_MINOR_VERSION=$(echo $QT_VERSION | cut -d. -f2)
QT_UPDATE_VERSION=$( echo $(echo $QT_VERSION | cut -d. -f3) | cut -d- -f1)
QT_LABEL=$QT_MAJOR_VERSION.$QT_MINOR_VERSION.$QT_UPDATE_VERSION
echo $QT_LABEL

# Directories for the source and builds
QT_SOURCE_DIR=$QT_DEV_DIR/qt-$QT_LABEL-sources
QT_BUILD_DIR_RELEASE=$QT_DEV_DIR/qt-$QT_LABEL-static-release
QT_BUILD_DIR_DEBUG=$QT_DEV_DIR/qt-$QT_LABEL-static-debug




echo "+------------------------------------------------------------------------------+"
echo "|                         Install Qt Requirements                              |"
echo "+------------------------------------------------------------------------------+"
sudo apt update
sudo apt install -y ninja-build cmake build-essential git \
    libfontconfig1-dev libfreetype-dev libx11-dev libx11-xcb-dev \
    libxcb-cursor-dev libxcb-glx0-dev libxcb-icccm4-dev libxcb-image0-dev \
    libxcb-keysyms1-dev libxcb-randr0-dev libxcb-render-util0-dev \
    libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev libxcb-util-dev \
    libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb1-dev \
    libxext-dev libxfixes-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
    libxrender-dev
echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                Clone Qt $QT_LABEL Repository + Init Submodules             |"
echo "+------------------------------------------------------------------------------+"

mkdir -p $QT_SOURCE_DIR
cd $QT_SOURCE_DIR

if [ ! -d ".git" ]; then
    git clone --branch v$QT_VERSION git://code.qt.io/qt/qt5.git .
    
    # Check Qt version for initialization method
    if (( QT_MAJOR_VERSION == 6 && QT_MINOR_VERSION < 8 )); then
        ./init-repository
    else
        $QT_SOURCE_DIR/configure -init-submodules
    fi
else
    echo "Qt repository already cloned, skipping..."
fi
echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                         Configuring Qt for Release                           |"
echo "+------------------------------------------------------------------------------+"
mkdir -p $QT_BUILD_DIR_RELEASE
cd $QT_BUILD_DIR_RELEASE
$QT_SOURCE_DIR/configure \
    -prefix $QT_BUILD_DIR_RELEASE \
    -static \
    -release \
    -opensource \
    -confirm-license \
    -nomake tests \
    -nomake examples \
    -opengl desktop \
    -skip qtwebengine \
    -platform linux-g++ \
    -cmake-generator "Ninja" 

echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                           Building Qt for Release                            |"
echo "+------------------------------------------------------------------------------+"
cmake --build . --parallel $(nproc)
echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                          Installing Qt for Release                           |"
echo "+------------------------------------------------------------------------------+"
cmake --install .
echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                         Configuring Qt for Debug                             |"
echo "+------------------------------------------------------------------------------+"
mkdir -p $QT_BUILD_DIR_DEBUG
cd $QT_BUILD_DIR_DEBUG
$QT_SOURCE_DIR/configure \
    -prefix $QT_BUILD_DIR_DEBUG \
    -static \
    -debug \
    -opensource \
    -confirm-license \
    -nomake tests \
    -nomake examples \
    -opengl desktop \
    -skip qtwebengine \
    -platform linux-g++ \
    -cmake-generator "Ninja" 

echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                           Building Qt for Debug                              |"
echo "+------------------------------------------------------------------------------+"
echo ""
cmake --build . --parallel $(nproc)
echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                          Installing Qt for Debug                             |"
echo "+------------------------------------------------------------------------------+"
cmake --install .
echo ""
echo ""

echo "+------------------------------------------------------------------------------+"
echo "|                        Qt $QT_LABEL Static Build Completed!                      |"
echo "+------------------------------------------------------------------------------+"
echo ""
echo "   To use Release:"
echo "       export PATH=$QT_BUILD_DIR_RELEASE/bin:\$PATH"
echo "       export CMAKE_PREFIX_PATH=$QT_BUILD_DIR_RELEASE"
echo ""
echo "   To use Debug:"
echo "       export PATH=$QT_BUILD_DIR_DEBUG/bin:\$PATH"
echo "       export CMAKE_PREFIX_PATH=$QT_BUILD_DIR_DEBUG"

