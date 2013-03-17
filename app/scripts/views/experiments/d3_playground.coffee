define [
	'backbone'
	'models/charts/index'
	'views/charts/index'
	'templates/experiments/playground'
], (Backbone, ChartModels, ChartViews, PlaygroundTemplate)->

	class D3Playground extends Backbone.View
		template: PlaygroundTemplate

		initialize: ->
			$(window).resize (e)->
				console.log "Resized!"
			@sampleGeometry = @_makeGeo()
			window.geometry = @sampleGeometry
			@geometrySvg = new ChartViews.GeometrySVG collection: @sampleGeometry, className: 'chart'
			@geometryControls = new ChartViews.Geometry collection: @sampleGeometry, className: 'controls'
			
		render: ->
			console.log "Rendering"
			@$el.html @template { title: 'D3 Playground' }
			@_renderDiagram()			
			@_renderControls()

		_renderDiagram: ->
			figureElement = @$el.find('figure').first()
			figureElement.empty()
			figureElement.append @geometrySvg.el

			@geometrySvg.calculateScales()
			@geometrySvg.render()

		_renderControls: ->
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