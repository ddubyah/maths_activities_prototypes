define [
	"backbone"
], (Backbone)->

	class Point extends Backbone.Model
		defaults: {
			label: "a"
			x: 50
			y: 50
		}

	return Point