define [
	'backbone'
	'localStorage'
], (backbone, localStorage)->

	class RATriangle extends Backbone.Model
		sync: Backbone.localSync
		localStorage: new Backbone.LocalStorage "raTriangles"

		defaults: 
			dx: 4
			dy: 3
			origin: 
				x: 0
				y: 0

		initialize: ->
			@_makeGeometry()

		geometry: ->


		_makeGeometry: ->
			pt1 = @_makePoint "a", @get('origin').x, @get('origin').y
			console.log pt1

		_makePoint: (label, x, y)->
			{
				label: label
				x: x
				y: y
			}