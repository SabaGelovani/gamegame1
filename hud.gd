extends CanvasLayer

@onready var coin_label = $CoinLabel
@onready var fuel_label = $FuelLabel

func _ready():
	var cm = CoinManager  # AutoLoad (Singleton) - უნდა იყოს Project Settings -> AutoLoad-ში დამატებული

	if cm:
		# სიგნალებზე დაკავშირება
		var err1 = cm.connect("money_changed", Callable(self, "_on_money_changed"))
		var err2 = cm.connect("fuel_changed", Callable(self, "_on_fuel_changed"))

		if err1 != OK:
			print("Failed to connect money_changed signal")
		if err2 != OK:
			print("Failed to connect fuel_changed signal")

		# თავდაპირველი სტრუქტურის ჩვენება
		if coin_label:
			coin_label.text = "Coins: " + str(cm.get_money())
		else:
			print("CoinLabel node not found!")

		if fuel_label:
			fuel_label.text = "Fuel: " + str(cm.get_fuel())
		else:
			print("FuelLabel node not found!")
	else:
		print("CoinManager not found!")

func _on_money_changed(new_money):
	if coin_label:
		coin_label.text = "Coins: " + str(new_money)

func _on_fuel_changed(new_fuel):
	if fuel_label:
		fuel_label.text = "Fuel: " + str(new_fuel)
