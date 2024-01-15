extends Panel

var time: float = 0.0 
var minutos: int = 0
var segundos: int = 0
var mseg: int = 0

func _process(delta) -> void:
	time += delta
	mseg = fmod(time, 1) * 100
	segundos = fmod(time, 60)
	minutos = fmod(time, 3600) / 60
	
	$Minutos.text = "%02d:" % minutos
	$Segundos.text = "%02d." % segundos
	$Miliseg.text = "%03d" % mseg
	
func stop() -> void:
	set_process(false)
	
func formateo_tiempo() -> String:
	return "%02d:%02d.%03d" % [minutos, segundos, mseg]
	

