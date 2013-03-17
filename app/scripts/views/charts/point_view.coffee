define [
	'backbone'
	'models/charts/point'
	'templates/charts/point_details'
], (Backbone, Point, PointDetailsTemp, PointEditView)->
	class PointView extends Backbone.View
		template: PointDetailsTemp

		events: 
			'dblclick': 'selected'
		
		initialize: ->
			@listenTo @model, 'change', @render

		render: ->
			@$el.html @template( @model.attributes )
			return this

		selected: ->
			@trigger 'selected', this

