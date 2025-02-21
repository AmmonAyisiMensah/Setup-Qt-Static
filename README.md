# Qt Static Build Script

This repository provides a Bash script to **statically build Qt 6.5.4** from source on Linux, but other version may also be used supported.  
The script automates the installation of dependencies, cloning the Qt source code, configuring, building, and installing both **Release** and **Debug** versions.

## Features
✅ **Static Build** – No external Qt dependencies required when building and deploying applications
✅ **Configures & Builds Both Release and Debug Versions**  
✅ **Uses Ninja for Faster Compilation**  

## Prerequisites
Ensure your system has the required development tools:  
- **Ubuntu/Debian-based systems**: The script installs dependencies automatically.  
- **Other distributions**: You may need to adjust the package installation commands in the section `Install Qt Requirements`.

## Installation & Usage

1. **Clone this repository**  
```sh
git clone https://github.com/AmmonAyisiMensah/Setup-Qt-Static.git
```

2. **Change the qt version and outpur directory(optional)**
```sh
QT_VERSION=6.5.4-lts-lgpl
QT_DEV_DIR==$HOME/dev
```

3. **Run the script**
```sh
cd Setup-Qt-Static
./setup-qt.sh
```

