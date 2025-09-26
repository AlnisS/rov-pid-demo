extends Spatial


# integral term of PID controller
var integral = Vector3.ZERO


func _ready():
	pass
	
	# if you want the ROV to start the simulation by already rotating, you
	# can uncomment this to give it an initial kick
#	$ROV.apply_torque_impulse(Vector3(1, .1, .2))


func _physics_process(delta):
	# by taking the cross product of each axis's displacement from its target
	# orientation, we get the torque vector that would get each axis to its
	# target orientation as efficiently as possible
	var x_displacement = $ROV.transform.basis.x.cross($Target.transform.basis.x)
	var y_displacement = $ROV.transform.basis.y.cross($Target.transform.basis.y)
	var z_displacement = $ROV.transform.basis.z.cross($Target.transform.basis.z)
	
	# by adding all of these together, we get an efficient direction in which
	# to rotate the ROV to get it to its target
	var proportional = x_displacement + y_displacement + z_displacement
	
	# update integrated error by adding current error multiplied by time since
	# the last update
	integral += proportional * delta
	
	# for the derivative, rather than looking at the derivative of our torque
	# vector, we can precisely know the ROV's angular velocity from the physics
	# engine (or in the case of a real ROV, from the IMU)
	var derivative = $ROV.angular_velocity
	
	# the constant coefficients are specified in the UI
	var P = float($ControlContainer/ControllerP/ValueText.text)
	var I = float($ControlContainer/ControllerI/ValueText.text)
	var D = float($ControlContainer/ControllerD/ValueText.text)
	
	# the overall controller response is each controller component multiplied
	# by its tuning coefficient
	var response = (
		proportional * P +
		integral * I +
		derivative * D
	)
	
	# make the simulated motors push around the ROV
	# in an actual ROV, this would be a call to the motor controller system
	# to run the motors such that they produce the desired torque vector
	$ROV.add_torque(response)
	
	# report the magnitude of the error from the setpoint to the UI
	$ControlContainer/ErrorReport/ValueText.text = str(proportional.length())
	
	# an optional confounding force to simulate something interfering with the
	# ROV (to demonstrate the purpose of an integral term in a PID controller)
	if $ControlContainer/ConfoundingForceButton.pressed:
		$ROV.add_torque(Vector3(1.0, 0.0, 0.0))
	
	# make the 3D view spinnable with arrow keys/a joystick
	var visual_rotation = Input.get_axis("rotate_left", "rotate_right") * 2
	$PerspectiveViewportContainer/Viewport/CameraBase.rotate_y(delta * visual_rotation)


# randomizes the setpoint for the ROV's orientation (the arrow onscreen)
func _on_RandomizeTargetButton_pressed():
	$Target.rotation_degrees = Vector3(
		rand_range(-180, 180),
		rand_range(-180, 180),
		rand_range(-180, 180)
	)
