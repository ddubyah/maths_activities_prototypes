define [
	'backbone'
	'models/maths/ra_triangle'
	'views/charts/index'
	'templates/maths/ra_triangles/ra_triangles'
	'./ra_triangle_edit'
], (Backbone, RaTriangle, ChartViews, RATrianglesTemplate, RATriangleEditView)->

	class NewRATriangleView extends Backbone.View

		template: RATrianglesTemplate

		initialize: ->
			@raTriangle = @_getTriangleInstance()
			@formView = @_makeFormView @raTriangle

			window.myshape = @raTriangle

		render: ->
			@$el.html @template { title: 'Right Angle Triangle Builder' }
			@$el.find('#triangleControls')
				.empty()
				.append @formView.render().el



		_getTriangleInstance: ->
			if @options.shape_id?
				console.log "Requested shape = "+ @options.shape_id
				raTri = new RaTriangle { id: @options.shape_id }
				raTri.fetch()
			else
				raTri = new RaTriangle()

			raTri

		_makeFormView: (aTriangle, el)->
			formView = new RATriangleEditView model: aTriangle
			formView


