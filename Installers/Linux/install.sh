#!/bin/bash
# Simple user-level installer for 3D Viewer (Linux)
set -e

APP_NAME="3d-viewer"
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons"

echo "Installing 3D Viewer..."

mkdir -p "$INSTALL_DIR" "$DESKTOP_DIR" "$ICON_DIR"

# Copy binary (rename to something clean)
if [ -f "3D-Viewer.x86_64" ]; then
  cp "3D-Viewer.x86_64" "$INSTALL_DIR/$APP_NAME"
elif [ -f "3D-Viewer" ]; then
  cp "3D-Viewer" "$INSTALL_DIR/$APP_NAME"
else
  echo "Error: Could not find exported binary (3D-Viewer.x86_64 or 3D-Viewer)"
  exit 1
fi
chmod +x "$INSTALL_DIR/$APP_NAME"

# Copy the data pack if it exists (required unless PCK is embedded)
if [ -f "3D-Viewer.pck" ]; then
  cp "3D-Viewer.pck" "$INSTALL_DIR/$APP_NAME.pck"
  echo "Copied 3D-Viewer.pck"
fi

# Copy icon if present
if [ -f "icon.png" ]; then
  cp "icon.png" "$ICON_DIR/$APP_NAME.png"
  ICON_PATH="$ICON_DIR/$APP_NAME.png"
else
  ICON_PATH="application-x-executable"
fi

# Create desktop file
cat > "$DESKTOP_DIR/$APP_NAME.desktop" << EOF
[Desktop Entry]
Name=3D Viewer
Comment=View 3D models
Exec=$INSTALL_DIR/$APP_NAME %U
Icon=$ICON_PATH
Type=Application
Categories=Graphics;3DGraphics;Viewer;
MimeType=model/gltf-binary;model/gltf+json;model/stl;application/octet-stream;model/obj;
StartupWMClass=3D Viewer
EOF

# Update desktop database
update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

echo ""
echo "Installed successfully!"
echo "You can now double-click .glb, .fbx, .vrm, .stl, and .obj files."
echo "To uninstall: rm $INSTALL_DIR/$APP_NAME $DESKTOP_DIR/$APP_NAME.desktop"
