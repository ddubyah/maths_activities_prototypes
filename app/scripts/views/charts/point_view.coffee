define [
	'backbone'
	'models/charts/point.coffee'
	'templates/charts/point_details'
], (Backbone, Point, PointDetailsTemp)->
	class PointView extends Backbone.View
		template: PointDetailsTemp

		render: ->
			@$el.html @template @model
