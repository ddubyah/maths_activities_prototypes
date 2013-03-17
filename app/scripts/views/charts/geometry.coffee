define [
	'backbone'
	'views/charts/point_view'
], (Backbone, PointView)->

	class GeometryView extends Backbone.View
		tagName: 'ul'

		initialize: ->

		render: ->
			for point in @collection.models
				pointView = new PointView model: point
				@$el.append pointView.render().$el
			return this

	return GeometryView