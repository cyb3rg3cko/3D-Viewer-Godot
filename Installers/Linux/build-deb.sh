#!/bin/bash
# Build a simple .deb package for 3D Viewer
# Requires: dpkg-deb, and the exported binary + icon in the current directory
set -e

VERSION="0.1.0"
PKG_NAME="3d-viewer"
BUILD_DIR="deb-build"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/usr/share/applications"
mkdir -p "$BUILD_DIR/usr/share/icons/hicolor/128x128/apps"

# Control file
cat > "$BUILD_DIR/DEBIAN/control" << EOF
Package: $PKG_NAME
Version: $VERSION
Section: graphics
Priority: optional
Architecture: amd64
Maintainer: CYB3RG3CKO
Description: Simple offline 3D model viewer
 Supports GLB, glTF, FBX, VRM, STL, and OBJ.
EOF

# Copy binary
if [ -f "3D-Viewer.x86_64" ]; then
  cp "3D-Viewer.x86_64" "$BUILD_DIR/usr/bin/$PKG_NAME"
elif [ -f "3D-Viewer" ]; then
  cp "3D-Viewer" "$BUILD_DIR/usr/bin/$PKG_NAME"
else
  echo "Error: binary not found"
  exit 1
fi
chmod 755 "$BUILD_DIR/usr/bin/$PKG_NAME"

# Copy the data pack if present
if [ -f "3D-Viewer.pck" ]; then
  cp "3D-Viewer.pck" "$BUILD_DIR/usr/bin/$PKG_NAME.pck"
  chmod 644 "$BUILD_DIR/usr/bin/$PKG_NAME.pck"
fi

# Desktop file
cat > "$BUILD_DIR/usr/share/applications/$PKG_NAME.desktop" << EOF
[Desktop Entry]
Name=3D Viewer
Comment=View 3D models
Exec=/usr/bin/$PKG_NAME %U
Icon=$PKG_NAME
Type=Application
Categories=Graphics;3DGraphics;Viewer;
MimeType=model/gltf-binary;model/gltf+json;model/stl;application/octet-stream;model/obj;
EOF

# Icon
if [ -f "icon.png" ]; then
  cp "icon.png" "$BUILD_DIR/usr/share/icons/hicolor/128x128/apps/$PKG_NAME.png"
fi

# Build the deb
dpkg-deb --build "$BUILD_DIR" "${PKG_NAME}_${VERSION}_amd64.deb"
echo "Created ${PKG_NAME}_${VERSION}_amd64.deb"
echo "Install with: sudo dpkg -i ${PKG_NAME}_${VERSION}_amd64.deb"
