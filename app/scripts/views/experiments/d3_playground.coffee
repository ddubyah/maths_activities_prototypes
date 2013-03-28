define [
	'backbone'
	'underscore'
	'models/charts/index'
	'views/charts/index'
	'templates/experiments/playground'
], (Backbone, _,ChartModels, ChartViews, PlaygroundTemplate)->

	class D3Playground extends Backbone.View
		template: PlaygroundTemplate

		events:
			"click a.save": "_saveGeometry"
			"click a.load": "_loadGeometry"
			"click a.reset": "_resetGeometry"

		initialize: ->
			@sampleGeometry = new ChartModels.Geometry @_defaultGeo()
			window.geometry = @sampleGeometry
			@geometrySvg = new ChartViews.GeometrySVG collection: @sampleGeometry, className: 'chart', padding:50
			window.diagram = @geometrySvg
			@geometryControls = new ChartViews.Geometry collection: @sampleGeometry
			@listenTo @sampleGeometry, 'error', (e)->
				alert "Error: "+e
			@_createLabels()

			
		render: ->
			 # console.log "Rendering"
			@$el.html @template { title: 'D3 Playground' }
			@_createDiagram()			
			@_createControls()
			@sampleGeometry.fetch()

		_createDiagram: ->
			figureElement = @$el.find('figure').first()
			figureElement.empty()
			figureElement.append @geometrySvg.el

			@_renderDiagram()
			@listenTo @sampleGeometry, 'change reset', =>
				@_renderDiagram()
				@_createControls()

			@listenTo @geometrySvg, 'hoverPoint', (point)->
				 # console.log "%s hovererd", point.get 'label'
			# @listenTo @geometrySvg, 'clickPoint'
			@_createAxis()


		_createAxis: ->
			@xAxis = @_makeAxis {
				scale: @geometrySvg.xScale()
				padding: @geometrySvg.padding()
				orient: 'bottom'
			}

			@yAxis = @_makeAxis {
				scale: @geometrySvg.yScale()
				padding: @geometrySvg.padding()
				orient: 'left'
			}

			@geometrySvg.$el.append @xAxis.el
			@geometrySvg.$el.append @yAxis.el

			@_positionAxis()
			@listenTo @geometrySvg, 'rescale', @_positionAxis

		_createLabels: ->
			@labelsView = new ChartViews.PointLabelsSVG {
				collection: @geometrySvg.collection
				xScale: @geometrySvg.xScale()
				yScale: @geometrySvg.yScale()
			}
			@geometrySvg.$el.append @labelsView.el
			# @labelsView.render()

			@listenTo @geometrySvg, 'rescale', (xScale, yScale)=>
				@labelsView.render(xScale, yScale)
			

		_makeAxis: (options)->
			myAxis = new ChartViews.AxisSVG options
			myAxis.render()
			myAxis

		_positionAxis: =>
			 # console.log "Posistioning axis"
			@xAxis.translate( 0, @geometrySvg.yScale()(0))
			@yAxis.translate( @geometrySvg.xScale()(0), 0 )
			@xAxis.render @geometrySvg.xScale()
			@yAxis.render @geometrySvg.yScale()

		_renderDiagram: =>
			 # console.log "Rendering!"
			@geometrySvg.calculateScales()
			@geometrySvg.render()

		_createControls: ->
			@$el.find('section#pointControls').html(@geometryControls.$el)
			@geometryControls.render()

		_saveGeometry: (e)=>
			e.preventDefault() if e?
			 # console.log @sampleGeometry
			@sampleGeometry.forEach (point)->
				point.save()
			# 
		_loadGeometry: (e)=>
			e.preventDefault() if e?
			 # console.log "Loading"
			@sampleGeometry.fetch()

		_resetGeometry: (e)=>
			e.preventDefault() if e?
			 # console.log "Reseting"
			# @sampleGeometry.invoke 'destroy'
			while aPoint = @sampleGeometry.first()
				aPoint.destroy()
			@sampleGeometry.reset @_defaultGeo(), validate: false

		_defaultGeo: ->
			[
				{ label: 'a', x: 5, y: 5 }
				{ label: 'b', x: 10, y: 8 }
				{ label: 'c', x: 3, y: 7 }
			]
			

	return D3Playground