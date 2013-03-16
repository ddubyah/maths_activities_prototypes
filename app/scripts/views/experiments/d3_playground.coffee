define [
	'backbone'
	'models/charts/index'
	'views/charts/index'
	'templates/experiments/playground'
], (Backbone, ChartModels, ChartViews, PlaygroundTemplate)->

	class D3Playground extends Backbone.View
		initialize: ->
			$(window).resize (e)->
				console.log "Resized!"
			@sampleGeometry = @_makeGeo()
			@geoView = new ChartViews.Geometry collection: @sampleGeometry, className: 'chart'
			
		render: ->
			console.log "Rendering"
			@$el.html PlaygroundTemplate { title: 'D3 Playground' }
			@_createGeometryView()			

		_createGeometryView: ->
			dx = @$el.width()
			dy = Math.round((dx/4) * 3)
			# console.log "dx.dy -> %d.%d", dx, dy
			# @geoView.$el.attr 'width', dx
			# @geoView.$el.attr 'height', dy

			figureElement = @$el.find('figure').first()
			figureElement.empty()
			figureElement.append @geoView.el

			@geoView.calculateScales()
			@geoView.render()

		_makeGeo: ->
			geo = new ChartModels.Geometry [
				{ x: -20, y: 0 }
				{ x: 50, y: 30 }
				{ x: 20, y: 10 }
			]
			geo

	return D3Playground