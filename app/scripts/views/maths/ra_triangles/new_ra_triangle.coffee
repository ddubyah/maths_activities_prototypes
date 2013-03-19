define [
	'backbone'
	'models/charts/shape'
	'views/charts/index'
	'templates/maths/ra_triangles/ra_triangles'
], (Backbone, Shape, ChartViews, RATrianglesTemplate)->

	class NewRATriangleView extends Backbone.View

		template: RATrianglesTemplate

		initialize: ->
			myShape = new Shape {geometry: @_defaultGeo()}, parse: false
			window.shape = myShape

		render: ->
			@$el.html @template { title: 'Right Angle Triangle Builder' }


		_defaultGeo: ->
			[
				{ label: 'a', x: 5, y: 5 }
				{ label: 'b', x: 15, y: 5 }
				{ label: 'c', x: 10, y:  15 }
			]