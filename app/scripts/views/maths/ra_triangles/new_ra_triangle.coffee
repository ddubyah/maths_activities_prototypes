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
			@_diagramView.clampBoundsToWidth()
			@_diagramView.render()
			@listenTo @formView, 'update', @render

		render: ->
			@formView.render().el
			# force a reset on the geometry
			@_diagramView.collection = @model.get 'geometry'
			@_diagramView.clampBoundsToWidth()
			@_refreshAxis()

			@_diagramView.render()

		_getTriangleInstance: ->
			if @options.shape_id?
				raTri = new RaTriangle { id: @options.shape_id }
				raTri.fetch()
			else
				raTri = new RaTriangle()

			raTri

		_refreshAxis: ->
			@_drawAxis @_diagramView unless @xAxis
			@xAxis.translate( 0, @_diagramView.yScale()(0))
			@yAxis.translate( @_diagramView.xScale()(0), 0 )
			@xAxis.render(@_diagramView.xScale())
			@yAxis.render(@_diagramView.yScale()) 

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

		_drawAxis: (diagram)->
			console.log "Creating axis"
			@xAxis = @_makeAxis {
				scale: diagram.xScale()
				padding: diagram.padding()
				orient: 'bottom'
			}

			@yAxis = @_makeAxis {
				scale: diagram.yScale()
				padding: diagram.padding()
				orient: 'left'
			}
			diagram.$el.append @xAxis.el
			diagram.$el.append @yAxis.el



		_makeAxis: (options)->
			console.log "New axis with "+ options
			myAxis = new ChartViews.AxisSVG options
			myAxis.render()
			myAxis
