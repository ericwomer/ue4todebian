#
# Unreal Engine 4 debian package creator by Cengiz Terzibas (yaakuro)
# At the moment it is installing it into /opt/epic/UnrealEngine/...
# but it should install later to /opt/epic/4.10 ....


#!/bin/bash

# Where is the cloned/downloaded UnrealEngine/ root folder?
UE4_ROOT=../../../..

# Where do we want install the Unreal Engine?
UE4_INSTALL_DIR=/opt/epic

# Where do we install the *.desktop file?
UE4_DESKTOP_DIR=/usr/share/applications

# Where do we install the icon file?
UE4_PIXMAPS_DIR=/usr/share/icons

UE4_MIME_DIR=/usr/share/mime/packages

# Get the version number from the Engine/Build/Build.version file
UE4_MAJOR=`cat $UE4_ROOT/Engine/Build/Build.version | grep MajorVersion | cut -d ":" -f2 | sed "s/,//" | sed "s/ //"`
UE4_MINOR=`cat $UE4_ROOT/Engine/Build/Build.version | grep MinorVersion | cut -d ":" -f2 | sed "s/,//" | sed "s/ //"`
UE4_PATCH=`cat $UE4_ROOT/Engine/Build/Build.version | grep PatchVersion | cut -d ":" -f2 | sed "s/,//" | sed "s/ //"`

#Create version variable and string representation that will be used in the debian control file.
UE4_VERSION=$UE4_MAJOR.$UE4_MINOR.$UE4_PATCH
UE4_VERSION_STRING="Version: "$UE4_VERSION
UE4_PACKAGE_NAME=UnrealEngine-$UE4_VERSION
UE4_PACKAGE_DIR=$UE4_ROOT

mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN

mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/Binaries
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/Config
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/Build
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/Content
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/Plugins
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/Shaders
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine/DerivedDataCache


rsync -aqz --progress $UE4_ROOT/Engine/Binaries $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine
rsync -aqz --progress $UE4_ROOT/Engine/Config $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine
rsync -aqz --progress $UE4_ROOT/Engine/Build $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine
rsync -aqz --progress $UE4_ROOT/Engine/Content $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine
rsync -aqz --progress $UE4_ROOT/Engine/Plugins $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine
rsync -aqz --progress $UE4_ROOT/Engine/Shaders $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine
rsync -aqz --progress $UE4_ROOT/Engine/DerivedDataCache $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Engine

#
# Create all examples and template stuff
#
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Templates
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/Samples
mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine/FeaturePacks

rsync -aqz --progress $UE4_ROOT/Templates $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine
rsync -aqz --progress $UE4_ROOT/Samples $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine
rsync -aqz --progress $UE4_ROOT/FeaturePacks $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_INSTALL_DIR/UnrealEngine



#
# Generate the DEBIAN/control file
#

# Get package size.
UE4_PACKAGE_SIZE=`du -c $UE4_PACKAGE_NAME | grep total | cut -f1`
UE4_PACKAGE_SIZE_STRING="Installed-Size: "$UE4_PACKAGE_SIZE

rm -f $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control

UE4_DEBIAN_INTERNAL_PACKAGE_NAME_STRING="Package: unrealengine-"$UE4_VERSION

#
# This is the section where we tell the debian installer the needed stuff as dependencies
# architecture etc.
#
echo $UE4_DEBIAN_INTERNAL_PACKAGE_NAME_STRING >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo $UE4_VERSION_STRING >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo $UE4_PACKAGE_SIZE_STRING >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo "Section: stable" >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo "Priority: optional" >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo "Architecture: amd64" >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo "Depends: libc6 (>= 2.19)" >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo "Maintainer: Cengiz Terzibas <yaakuro@codeposer.net>" >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control
echo "Description: Unreal Engine the overkill Game Engine" >> $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/DEBIAN/control




#
# Generate the .desktop file that is used to find gnome apps. This will of course
# use the latest version of Unreal Engine 4 to locate icons and other resources.
#
UE4_DESKTOP_FILE_NAME=unrealengine-$UE4_VERSION.desktop
UE4_DESKTOP_PACKAGE_LOCATION=$UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_DESKTOP_DIR/$UE4_DESKTOP_FILE_NAME

mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_DESKTOP_DIR
rm -f $UE4_DESKTOP_PACKAGE_LOCATION

echo "[Desktop Entry]" >> $UE4_DESKTOP_PACKAGE_LOCATION

UE4_DESKTOP_FILE_VERSION_STRING="Version="$UE4_VERSION
echo $UE4_DESKTOP_FILE_VERSION_STRING >> $UE4_DESKTOP_PACKAGE_LOCATION

echo "Type=Application" >> $UE4_DESKTOP_PACKAGE_LOCATION

UE4_DESKTOP_FILE_NAME="Name=Unreal Engine "$UE4_VERSION" Editor"
echo $UE4_DESKTOP_FILE_NAME >> $UE4_DESKTOP_PACKAGE_LOCATION
echo "Comment=A super extreme killer game engine for reallz :D" >> $UE4_DESKTOP_PACKAGE_LOCATION

UE4_ICON_FILE=$UE4_INSTALL_DIR/UnrealEngine/Engine/Content/Editor/Slate/About/UE4Icon.png
UE4_ICON_FILE_STRING="Icon="$UE4_ICON_FILE

echo $UE4_ICON_FILE_STRING >> $UE4_DESKTOP_PACKAGE_LOCATION

# Set the UE4Editor path and file variables
UE4_EDITOR_PATH=$UE4_INSTALL_DIR/UnrealEngine/Engine/Binaries/Linux
UE4_EDITOR_FILE=$UE4_EDITOR_PATH/UE4Editor

# Specify the executable
UE4_EDITOR_FILE_STRING="Exec="$UE4_EDITOR_FILE
echo $UE4_EDITOR_FILE_STRING >> $UE4_DESKTOP_PACKAGE_LOCATION

# Specify the path of the executable
UE4_EDITOR_PATH_STRING="Path="$UE4_EDITOR_PATH
echo $UE4_EDITOR_PATH_STRING >> $UE4_DESKTOP_PACKAGE_LOCATION

# TODO For now we use the same association for the application mime type.
echo "MimeType=application/unrealengine" >> $UE4_DESKTOP_PACKAGE_LOCATION

echo "NoDisplay=false" >> $UE4_DESKTOP_PACKAGE_LOCATION
echo "Categories=3DGraphics;Graphics" >> $UE4_DESKTOP_PACKAGE_LOCATION
echo "StartupNotify=false" >> $UE4_DESKTOP_PACKAGE_LOCATION
echo "Terminal=false" >> $UE4_DESKTOP_PACKAGE_LOCATION



#
# Create mime association file. This is used to open a file with a specific
# application.
#


UE4_MIME_FILE_NAME=unrealengine-$UE4_VERSION.xml
UE4_MIME_PACKAGE_LOCATION=$UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_MIME_DIR/$UE4_MIME_FILE_NAME

mkdir -p $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME/$UE4_MIME_DIR
rm -f $UE4_MIME_PACKAGE_LOCATION

echo '<?xml version="1.0"?>' >> $UE4_MIME_PACKAGE_LOCATION
echo '<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">' >> $UE4_MIME_PACKAGE_LOCATION

# TODO For now we use the same association for the application mime type.
echo '  <mime-type type="application/unrealengine">' >> $UE4_MIME_PACKAGE_LOCATION

echo '    <comment>Unreal Engine 4 project file</comment>' >> $UE4_MIME_PACKAGE_LOCATION
echo '    <glob pattern="*.uproject"/>' >> $UE4_MIME_PACKAGE_LOCATION
echo '		<icon>UE4Icon</icon>' >> $UE4_MIME_PACKAGE_LOCATION
echo '  </mime-type>' >> $UE4_MIME_PACKAGE_LOCATION
echo '</mime-info>' >> $UE4_MIME_PACKAGE_LOCATION


# Here I am not sure. We have to do root right?
sudo chown -R root:root $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME
# Same goes here? No clue here. Have to figure out.
sudo dpkg-deb --build $UE4_PACKAGE_DIR/$UE4_PACKAGE_NAME
