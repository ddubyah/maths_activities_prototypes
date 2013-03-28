define [
	"backbone"
], (Backbone)->

	class Point extends Backbone.Model

		defaults: {
			label: "a"
			x: 50
			y: 50
			selected: false
		}

		translate: (dx=0, dy=0)->
			@set 'x', @get('x') + dx
			@set 'y', @get('y') + dy

		scale: (scalor, origin={x:0, y:0})->
			dx = @get('x') - origin.x
			dy = @get('y') - origin.y

			dx *= scalor
			dy *= scalor

			@set 'x', Number(origin.x) + dx
			@set 'y', Number(origin.y) + dy 

		validate: (attrs, options)->
			console.log "Validating point: "
			return "x and y coordinates must be numeric" if isNaN(attrs.x) or isNaN(attrs.y)
			return null

	return Point