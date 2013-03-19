define [
	'backbone'
	'localStorage'
	'models/charts/point'
], (Backbone, localStorage, Point)->

	class Geometry extends Backbone.Collection
		model: Point
		localStorage: new Backbone.LocalStorage "geometry"


	return Geometry

