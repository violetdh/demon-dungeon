extends Behaviour

var party_builder = PartyBuilder.new()

func use():
	print("bone")
	print("strength: " + str(strength))
	# make this create a new party member of equivalent level to item qual and add it to the list
	#PartyBuilder class?
	party_builder.build(strength)
