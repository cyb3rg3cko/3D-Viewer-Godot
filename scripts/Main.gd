extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var model_root: Node3D = $ModelRoot
@onready var file_dialog: FileDialog = $UI/FileDialog
@onready var about_dialog: AcceptDialog = $UI/AboutDialog
@onready var drop_label: Label = $UI/DropLabel
@onready var file_menu: MenuButton = $UI/TopBar/FileMenu

var current_model: Node = null

# Orbit controls
var orbiting := false
var panning := false
var last_mouse := Vector2.ZERO
var distance := 5.0
var yaw := 0.0
var pitch := 0.3
var target := Vector3.ZERO

func _ready():
	DisplayServer.window_set_title("3D Viewer")
	get_viewport().files_dropped.connect(_on_files_dropped)
	
	# Connect file dialog
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	
	# Build File menu
	var popup = file_menu.get_popup()
	popup.add_item("Open…", 0)
	popup.add_item("About", 1)
	popup.id_pressed.connect(_on_menu_id_pressed)
	
	# Check command line args, ignore project/scene files
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("-") or arg.begins_with("--"):
			continue
		var ext = arg.get_extension().to_lower()
		if ext in ["glb", "gltf", "fbx", "vrm", "stl", "obj"] and FileAccess.file_exists(arg):
			load_model(arg)
			break

func _on_menu_id_pressed(id: int):
	match id:
		0: file_dialog.popup_centered()
		1: about_dialog.popup_centered()

func _on_files_dropped(files: PackedStringArray):
	if files.size() > 0:
		load_model(files[0])

func load_model(path: String):
	if current_model:
		current_model.queue_free()
		current_model = null
	
	var ext = path.get_extension().to_lower()
	var scene: Node = null
	
	match ext:
		"glb", "gltf", "vrm":
			var gltf = GLTFDocument.new()
			var state = GLTFState.new()
			if gltf.append_from_file(path, state) == OK:
				scene = gltf.generate_scene(state)
		"fbx":
			var fbx = FBXDocument.new()
			var fbx_state = FBXState.new()
			if fbx.append_from_file(path, fbx_state) == OK:
				scene = fbx.generate_scene(fbx_state)
		"obj":
			scene = _load_obj(path)
		"stl":
			scene = _load_stl(path)
		_:
			push_error("Unsupported format: " + ext)
			return
	
	if scene:
		model_root.add_child(scene)
		current_model = scene
		_fit_camera()
		drop_label.visible = false

func _load_obj(path: String) -> Node3D:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return null
	var vertices = PackedVector3Array()
	var faces = []
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.begins_with("v "):
			var parts = line.split(" ", false)
			if parts.size() >= 4:
				vertices.append(Vector3(parts[1].to_float(), parts[2].to_float(), parts[3].to_float()))
		elif line.begins_with("f "):
			var parts = line.split(" ", false)
			var face = []
			for i in range(1, parts.size()):
				var idx = parts[i].split("/")[0].to_int() - 1
				if idx >= 0 and idx < vertices.size():
					face.append(idx)
			if face.size() >= 3:
				faces.append(face)
	file.close()
	
	if vertices.is_empty() or faces.is_empty():
		return null
	
	var mesh = ArrayMesh.new()
	var verts = PackedVector3Array()
	var normals = PackedVector3Array()
	for face in faces:
		# Triangulate simple faces
		for i in range(1, face.size() - 1):
			var a = vertices[face[0]]
			var b = vertices[face[i]]
			var c = vertices[face[i + 1]]
			verts.append(a)
			verts.append(b)
			verts.append(c)
			var n = (b - a).cross(c - a).normalized()
			normals.append(n)
			normals.append(n)
			normals.append(n)
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = normals
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	var mi = MeshInstance3D.new()
	mi.mesh = mesh
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.8, 0.8)
	mi.material_override = mat
	return mi

func _load_stl(path: String) -> Node3D:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return null
	file.seek(80)
	var tri_count = file.get_32()
	var mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var normals = PackedVector3Array()
	
	for i in tri_count:
		var n = Vector3(file.get_float(), file.get_float(), file.get_float())
		for j in 3:
			vertices.append(Vector3(file.get_float(), file.get_float(), file.get_float()))
			normals.append(n)
		file.get_16()
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	var mi = MeshInstance3D.new()
	mi.mesh = mesh
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.8, 0.8)
	mi.material_override = mat
	return mi

func _fit_camera():
	if not current_model:
		return
	var aabb = _get_aabb(current_model)
	target = aabb.get_center()
	distance = aabb.size.length() * 1.6
	if distance < 1.0:
		distance = 5.0
	_update_camera()

func _get_aabb(node: Node) -> AABB:
	var aabb = AABB()
	if node is MeshInstance3D:
		var local = node.get_aabb()
		aabb = local
		aabb.position = node.global_transform * local.position
	for child in node.get_children():
		aabb = aabb.merge(_get_aabb(child))
	return aabb

func _update_camera():
	var offset = Vector3(
		sin(yaw) * cos(pitch),
		sin(pitch),
		cos(yaw) * cos(pitch)
	) * distance
	camera.position = target + offset
	camera.look_at(target)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			orbiting = event.pressed
			last_mouse = event.position
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			panning = event.pressed
			last_mouse = event.position
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = max(0.5, distance * 0.9)
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = min(100.0, distance * 1.1)
			_update_camera()
	elif event is InputEventMouseMotion:
		var delta = event.position - last_mouse
		if orbiting:
			yaw -= delta.x * 0.01
			pitch = clamp(pitch + delta.y * 0.01, -1.4, 1.4)  # reversed up/down
			last_mouse = event.position
			_update_camera()
		elif panning:
			var right = camera.global_transform.basis.x
			var up = camera.global_transform.basis.y
			var pan_speed = distance * 0.002
			target -= right * delta.x * pan_speed
			target += up * delta.y * pan_speed
			last_mouse = event.position
			_update_camera()

func _on_file_dialog_file_selected(path: String):
	load_model(path)
