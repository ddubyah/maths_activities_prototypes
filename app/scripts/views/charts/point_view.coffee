define [
	'backbone'
	'models/charts/point'
	'templates/charts/point_details'
], (Backbone, Point, PointDetailsTemp)->
	class PointView extends Backbone.View
		template: PointDetailsTemp

		initialize: ->
			@listenTo @model, 'change', @render

		render: ->
			@$el.html @template( @model.toJSON())
			return this
