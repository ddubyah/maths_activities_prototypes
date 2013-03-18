define [
	'backbone'
	'underscore'
	'd3'
	'./svg_canvas'
	'models/charts/index'
	'./d3_mixins'
], (Backbone, _, D3, SVGCanvasView, ChartModels, D3Mixins)->

	class GeometrySVG extends SVGCanvasView

		tagName: 'svg'
		
		defaults: {
			padding: 30	
			transitionDuration: 500
			transitionEase: 'elastic'
		}
				
		initialize: ->
			super()
			# NB - If you can't find it here, look in the 
			@_applyMixins D3Mixins

			@lineGroup = @makePaddedGroup('line')
			@pointsGroup = @makePaddedGroup 'points'

			# @line = @_makeLine @lineGroup
			# @listenTo @collection, 'change', @render

		_applyMixins: (mixins...)->
			_.extend this, mixin for mixin in arguments

		render: ->
			@_setCanvasHeightByXScale()
			@_drawPoints(@pointsGroup)
			@_drawLine(@lineGroup)
			this

		_drawPoints: (target=(D3.select(@el)))->
			xscale = @_xScale
			yscale = @_yScale

			circles = target.selectAll('circle')
				.data(@collection.models)

			newCircles = circles.enter()
				.append('circle')
				.attr('r', 2)
			
			newCircles.on 'mouseover', (d, i)=>
				@trigger "hoverPoint", d, i

			newCircles.on 'click', (d, i)=>
				@trigger "selectPoint", d, i
				
			circles.attr 'r': 8

			circles.transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.attr({
						cx: (d)->
							xscale d.get('x')
						cy: (d)->
							yscale d.get('y')
						r: 4
						class: 'point'
					})

		_drawLine: (target=(D3.select(@el)))->
			lineBuilder = @_makeLineBuilder()
			path = target.selectAll('path').data([@collection.models])

			path.enter()
				.append('svg:path')
				.attr({
					class: 'shape'
					# d: (d)->
					# 	lineBuilder(d)
					})

			path.transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.attr {
					d: (d)->
						lineBuilder(d)
				}



		_makeLineBuilder: ()->
			xscale = @_xScale
			yscale = @_yScale

			lineBuilder = d3.svg.line()
			lineBuilder.x (d)->
					xscale d.get('x')

			lineBuilder.y (d)->
					yscale d.get('y')

			lineBuilder.interpolate "linear-closed"

			lineBuilder

	return GeometrySVG
