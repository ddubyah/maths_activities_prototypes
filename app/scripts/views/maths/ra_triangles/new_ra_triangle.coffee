define [
	'backbone'
	'views/charts/index'
	'templates/maths/ra_triangles/ra_triangles'
], (Backbone, ChartViews, RATrianglesTemplate)->

	class NewRATriangleView extends Backbone.View

		template: RATrianglesTemplate

		render: ->
			@$el.html @template { title: 'Right Angle Triangle Builder' }
			

