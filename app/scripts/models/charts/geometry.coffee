define [
	'backbone'
	'models/charts/point'
], (Backbone, Point)->
	class Geometry extends Backbone.Collection
		model: Point
		
