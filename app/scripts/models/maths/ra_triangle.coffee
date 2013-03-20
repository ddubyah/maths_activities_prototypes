define [
	'backbone'
	'localStorage'
	'../charts/geometry'
], (backbone, localStorage, Geometry)->

	class RATriangle extends Backbone.Model
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
			@_geometry = new Geometry @_makeGeometry()

		get: (attr)->
			if attr is 'geometry'
				@_geometry.reset @_makeGeometry()
				return @_geometry
			else
				return @attributes[attr]


		_makeGeometry: ->
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