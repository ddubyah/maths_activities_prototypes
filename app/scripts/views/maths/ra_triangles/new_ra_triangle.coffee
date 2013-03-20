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
			@model = @_getTriangleInstance()
			@$el.html @template { title: 'Right Angle Triangle Builder' }

			@formView = @_makeFormView @model
			@_diagramView = @_makeDiagram()

			@listenTo @formView, 'update', @render


			window.myshape = @model
			window.mydiagram = @_diagramView

		render: ->
			@formView.render().el
			# force a reset on the geometry
			myGeo = @model.get 'geometry'
			@_diagramView.ensureBoundsToWidth()

			@_diagramView.render()

		_getTriangleInstance: ->
			if @options.shape_id?
				console.log "Requested shape = "+ @options.shape_id
				raTri = new RaTriangle { id: @options.shape_id }
				raTri.fetch()
			else
				raTri = new RaTriangle()

			raTri

		_makeFormView: (aTriangle, el)->
			formView = new RATriangleEditView model: aTriangle, el: @$el.find('#triangleControls')
			formView

		_makeDiagram: ->
			geometry = @model.get 'geometry'
			geometryView = new ChartViews.GeometrySVG 
				collection: geometry
				className: 'chart'
				padding: 50

			@$el.find('figure').first().append geometryView.el

			geometryView
