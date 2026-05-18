class_name Snowball extends RigidBody3D

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5;
	continuous_cd = true
	

func _physics_process(delta):
	# snowball grows when moving on ground but grows less the larger it gets
	# scale limit is disabled for now because big balls are cool
	var growth_speed := linear_velocity.length() / 15
	#const max_scale := 15
	
	var can_grow := true #scale.length() < max_scale
	var is_on_ground := get_contact_count() > 0
	
	if can_grow and is_on_ground:
		scale += Vector3(1,1,1) * growth_speed * delta
