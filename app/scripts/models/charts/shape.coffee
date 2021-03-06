define [
	'backbone'
	'localStorage'
	'./geometry'
	'./point'
], (Backbone, localStorage, Geometry, Point)->

	class Shape extends Backbone.Model
		sync: Backbone.localSync
		localStorage: new Backbone.LocalStorage 'shapes'

		defaults:
			geometry: 
				[
					{ label: 'a', x: 5, y: 5 }
					{ label: 'b', x: 15, y: 5 }
					{ label: 'c', x: 10, y:  15 }
				]

		set: (attributes, options)->
			if attributes.geometry
				unless attributes.geometry instanceof Geometry
					attributes.geometry = new Geometry attributes.geometry

			Backbone.Model.prototype.set.call this, attributes, options

		translate: (dx, dy)->
			for point in @get('geometry').models
				point.translate dx, dy

		scale: (scalor, origin={x:0, y:0})->
			 # console.log "Scaling"
			for point in @get('geometry').models
				point.scale scalor, origin


		_getDefaultGeo: ->
			[
				{ label: 'a', x: 5, y: 5 }
				{ label: 'b', x: 15, y: 5 }
				{ label: 'c', x: 10, y:  15 }
			]