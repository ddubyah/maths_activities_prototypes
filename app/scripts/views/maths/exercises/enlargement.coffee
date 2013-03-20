define [
	'backbone'
	'models/maths/ra_triangle'
	'views/charts/d3_mixins'
	'views/charts/index'
	'templates/maths/exercises/enlargement'

], (Backbone, RaTriangle, D3Mixins, ChartViews, EnlargementTemplate)->

	class EnlargementView extends Backbone.View

		template: EnlargementTemplate

		initialize: ->
			@_applyMixins D3Mixins
			window.enlargementView = this

			@$el.html @template { title: 'Enlargement' }
			@model = @_getSourceModel()
			@_diagram = @_makeDiagram @model.get 'geometry'
			@_establishScales @_diagram
			# @_diagram.clampBoundsToWidth()
			@_diagram.render()
			@_drawAxis @_diagram

		_applyMixins: (mixins...)->
			_.extend this, mixin for mixin in arguments

		render: ->
			@_refreshAxis @_diagram

		_getSourceModel: ->
			if @options.shape_id?
				raTri = new RaTriangle id: @options.shape_id
				raTri.fetch()
			else
				raTri = new RaTriangle()

			raTri

		_makeDiagram: (geometry)->
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

		_refreshAxis: (parentView)->
			@xAxis.translate( 0, parentView.yScale()(0))
			@yAxis.translate( parentView.xScale()(0), 0 )
			@xAxis.render(parentView.xScale())
			@yAxis.render(parentView.yScale())

		_establishScales: (diagrams...)->
			@clampBoundsToWidth diagrams[0].el$
