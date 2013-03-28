define [
	'backbone'
	'localStorage'
	'../charts/shape'
	'../charts/geometry'
], (backbone, localStorage, Shape, Geometry)->

	class RATriangle extends Shape
		sync: Backbone.localSync
		localStorage: new Backbone.LocalStorage "raTriangles"

		defaults: 
			dx: 4
			dy: 3
			origin: 
				x: 0
				y: 0

		_geometry: null

		initialize: ->
			@set 'geometry': @_makeGeometry()
			@listenTo this, 'change:dx change:dy', @_updateGeometry
			window.triangle = this

		validate: (attrs, options)->
			 # console.log "Validating raTriangle: "
			return "dx and dy coordinates must be numeric" if isNaN(attrs.dx) or isNaN(attrs.dy)
			return null

		_updateGeometry: ->
			@set {'geometry': @_makeGeometry()}, { silent: true }

		_makeGeometry: ->
			 # console.log "Making geometry"
			dx = @get 'dx'
			dy = @get 'dy'
			origin = @get 'origin'

			pt1 = @_makePoint "a", origin.x, origin.y
			pt2 = @_makePoint "b", origin.x + dx, origin.y
			pt3 = @_makePoint "c", origin.x + dx, origin.y + dy
			
			[pt1, pt2, pt3]

		_makePoint: (label, x, y)->
			{
				label: label
				x: x
				y: y
			}

		# toJSON: ->
		# 	attrs = @attributes
		# 	attrs.geometry = @_makeGeometry()
		# 	attrs