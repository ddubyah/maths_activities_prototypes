define [
	'backbone'
	'templates/charts/geometry_details'
	'templates/charts/point_details'
], (Backbone, GeometryDetailsTemp, PointTemp)->

	class GeometryView extends Backbone.View
		tagName: 'ul'
		template: GeometryDetailsTemp

		initialize: ->
			@$el.html @template()

		render: ->
			for point in @collection.models
				console.log "Rendering point "+ point.toJSON()
				@$el.append PointTemp point.toJSON()

	return GeometryView