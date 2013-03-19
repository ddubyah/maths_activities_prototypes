define [
	"backbone"
], (Backbone)->

	class Point extends Backbone.Model

		defaults: {
			label: "a"
			x: 50
			y: 50
		}

		validate: (attrs, options)->
			console.log "Validating point: "
			return "x and y coordinates must be numeric" if isNaN(attrs.x) or isNaN(attrs.y)
			return null

	return Point