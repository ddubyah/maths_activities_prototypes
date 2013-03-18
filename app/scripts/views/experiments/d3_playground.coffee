define [
	'backbone'
	'underscore'
	'models/charts/index'
	'views/charts/index'
	'templates/experiments/playground'
], (Backbone, _,ChartModels, ChartViews, PlaygroundTemplate)->

	class D3Playground extends Backbone.View
		template: PlaygroundTemplate

		initialize: ->
			@sampleGeometry = @_makeGeo()
			window.geometry = @sampleGeometry
			@geometrySvg = new ChartViews.GeometrySVG collection: @sampleGeometry, className: 'chart'
			@geometryControls = new ChartViews.Geometry collection: @sampleGeometry, className: 'controls'
			
		render: ->
			console.log "Rendering"
			@$el.html @template { title: 'D3 Playground' }
			@_createDiagram()			
			@_createControls()

		_createDiagram: ->
			figureElement = @$el.find('figure').first()
			figureElement.empty()
			figureElement.append @geometrySvg.el

			@_renderDiagram()
			@listenTo @sampleGeometry, 'change', @_renderDiagram

			@listenTo @geometrySvg, 'hoverPoint', (point)->
				console.log "%s hovererd", point.get 'label'
			# @listenTo @geometrySvg, 'clickPoint'

			@xAxis = @_createAxis {
				scale: @geometrySvg.xScale()
				padding: @geometrySvg.padding()
				orient: 'bottom'
			}

			@yAxis = @_createAxis {
				scale: @geometrySvg.yScale()
				padding: @geometrySvg.padding()
				orient: 'left'
			}

			@geometrySvg.$el.append @xAxis.el
			@geometrySvg.$el.append @yAxis.el

			@_positionAxis()
			@listenTo @geometrySvg, 'rescale', @_positionAxis


		_createAxis: (options)->
			myAxis = new ChartViews.AxisSVG options
			myAxis.render()
			myAxis

		_positionAxis: =>
			console.log "Posistioning axis"
			@xAxis.translate( 0, @geometrySvg.yScale()(0))
			@yAxis.translate( @geometrySvg.xScale()(0), 0 )
			@xAxis.render @geometrySvg.xScale()
			@yAxis.render @geometrySvg.yScale()

		_renderDiagram: =>
			@geometrySvg.calculateScales()
			@geometrySvg.render()

		_createControls: ->
			@$el.find('#controls').html(@geometryControls.$el)
			@geometryControls.render()

		_makeGeo: ->
			geo = new ChartModels.Geometry [
				{ label: 'a', x: -20, y: 0 }
				{ label: 'b', x: 60, y: 40 }
				{ label: 'c', x: 0, y: 60 }
			]
			geo

	return D3Playground