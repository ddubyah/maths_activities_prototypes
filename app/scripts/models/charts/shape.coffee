define [
	'backbone'
	'localStorage'
	'./geometry'
	'./point'
], (Backbone, localStorage, Geometry, Point)->

	class Shape extends Backbone.Model
		sync: Backbone.localSync
		localStorage: new Backbone.LocalStorage 'shapes'

		initialize: ->
			# unless @has('geometry')
			# 	console.log "Creating default shape"
			# 	@parse {
			# 		geometry: @_getDefaultGeo()
			# 		origin: @_getDefaultOrigin
			# 	}

		parse: (response)->
			@set 'geometry', new Geometry(response.geometry) if response.geometry?
			@set 'origin', new Point(response.origin) if response.origin?
 
		# toJSON: ->
		# 	serialized = _.clone @attributes
		# 	console.log "Serializing geometry"
		# 	serialized.geometry = serialized.geometry.toJSON()
		# 	serialized.origin = serialized.geometry.toJSON()
		# 	serialized

		_getDefaultOrigin: ->
			{ label: 'o', x: 0, y: 0 }

		_getDefaultGeo: ->
			[
				{ label: 'a', x: 5, y: 5 }
				{ label: 'b', x: 15, y: 5 }
				{ label: 'c', x: 10, y:  15 }
			]