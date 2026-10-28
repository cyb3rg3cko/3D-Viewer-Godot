# Update

This Repo is going to be stale, but i will leave it up in case someone wants to use the code. After trying o wrap a three.js script in Tauri/Rust and having issues, I wanted to try using my favorite game engine. Ultimately, this approach worked but wasn't very usable on systems will very little graphics capabilities. How ever I was able to get a wrapped version of three.js working better using Electron for desktop and Capacitor for android. You can see that project here -> https://github.com/cyb3rg3cko/3D-Viewer-Electron-Capacitor

***

# 3D Viewer (Godot)

Simple offline 3D model viewer built with Godot 4.

## Features
- Dark UI with top bar and File menu
- Supports: GLB, glTF, FBX, VRM (as glTF), STL, OBJ
- Drag and drop
- File associations (via export settings)
- Offline

## Open in Godot
1. Install Godot 4.3+
2. Open this folder as a project
3. Press F5 to run

## Export
- Windows / Linux: Project → Export → Add preset
- Android: Add Android preset and set up the SDK

## File Associations
Set them in the export preset under **Application → File Types** (or the platform-specific section).
