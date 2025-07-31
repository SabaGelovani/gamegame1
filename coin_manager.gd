extends Node

signal money_changed(new_money)
signal fuel_changed(new_fuel)

var money = 100  # საწყისი ქოინები
var fuel = 10    # საწყისი საწვავი

func _ready():
	# თავდაპირველი სიგნალების გამოცემა, რომ HUD გადახედოს
	emit_signal("money_changed", money)
	emit_signal("fuel_changed", fuel)

func update_money(amount):
	money += amount
	emit_signal("money_changed", money)
	print("Money updated to:", money)

func get_money():
	return money

func set_money(value):
	money = value
	emit_signal("money_changed", money)
	print("Money set to:", money)

func update_fuel(amount):
	fuel += amount
	emit_signal("fuel_changed", fuel)
	print("Fuel updated to:", fuel)

func get_fuel():
	return fuel

func set_fuel(value):
	fuel = value
	emit_signal("fuel_changed", fuel)
	print("Fuel set to:", fuel)
