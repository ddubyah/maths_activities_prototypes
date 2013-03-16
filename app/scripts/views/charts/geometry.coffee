define [
	'backbone'
	'templates/charts/point_details'
], (Backbone, PointTemp)->

	class GeometryView extends Backbone.View
		tagName: 'ul'

		initialize: ->

		render: ->
			for point in @collection.models
				console.log "Rendering point "+ point.toJSON()
				@$el.append PointTemp point.toJSON()

	return GeometryView