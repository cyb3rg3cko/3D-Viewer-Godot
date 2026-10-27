; Inno Setup script for 3D Viewer
; Compile with Inno Setup (https://jrsoftware.org/isinfo.php)

[Setup]
AppName=3D Viewer
AppVersion=0.1.0
AppPublisher=CYB3RG3CKO
DefaultDirName={autopf}\3D Viewer
DefaultGroupName=3D Viewer
OutputBaseFilename=3D-Viewer-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\3D-Viewer.exe

[Files]
Source: "3D-Viewer.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "3D-Viewer.pck"; DestDir: "{app}"; Flags: ignoreversion
Source: "app-icon.png"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\3D Viewer"; Filename: "{app}\3D-Viewer.exe"
Name: "{autodesktop}\3D Viewer"; Filename: "{app}\3D-Viewer.exe"

[Registry]
; GLB / GLTF
Root: HKCU; Subkey: "Software\Classes\.glb"; ValueType: string; ValueName: ""; ValueData: "3DViewer.glb"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.glb"; ValueType: string; ValueName: ""; ValueData: "glTF 3D Model"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.glb\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\app-icon.png"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.glb\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\3D-Viewer.exe"" ""%1"""; Flags: uninsdeletekey

Root: HKCU; Subkey: "Software\Classes\.gltf"; ValueType: string; ValueName: ""; ValueData: "3DViewer.glb"; Flags: uninsdeletekey

; FBX
Root: HKCU; Subkey: "Software\Classes\.fbx"; ValueType: string; ValueName: ""; ValueData: "3DViewer.fbx"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.fbx"; ValueType: string; ValueName: ""; ValueData: "Autodesk FBX"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.fbx\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\app-icon.png"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.fbx\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\3D-Viewer.exe"" ""%1"""; Flags: uninsdeletekey

; VRM
Root: HKCU; Subkey: "Software\Classes\.vrm"; ValueType: string; ValueName: ""; ValueData: "3DViewer.vrm"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.vrm"; ValueType: string; ValueName: ""; ValueData: "VRM Avatar"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.vrm\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\app-icon.png"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.vrm\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\3D-Viewer.exe"" ""%1"""; Flags: uninsdeletekey

; STL
Root: HKCU; Subkey: "Software\Classes\.stl"; ValueType: string; ValueName: ""; ValueData: "3DViewer.stl"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.stl"; ValueType: string; ValueName: ""; ValueData: "STL Model"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.stl\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\app-icon.png"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.stl\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\3D-Viewer.exe"" ""%1"""; Flags: uninsdeletekey

; OBJ
Root: HKCU; Subkey: "Software\Classes\.obj"; ValueType: string; ValueName: ""; ValueData: "3DViewer.obj"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.obj"; ValueType: string; ValueName: ""; ValueData: "Wavefront OBJ"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.obj\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\app-icon.png"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\3DViewer.obj\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\3D-Viewer.exe"" ""%1"""; Flags: uninsdeletekey
