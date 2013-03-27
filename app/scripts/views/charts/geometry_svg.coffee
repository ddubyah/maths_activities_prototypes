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
			path: true
			pointStyle: 'circle'
		}
				
		initialize: (options)->
			@options = _.defaults options, @defaults

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
			@_drawLine(@lineGroup) if @options.path
			this

		_drawPoints: (target=(D3.select(@el)))->
			xscale = @_xScale
			yscale = @_yScale

			console.log "Creating point symbol"

			symbol = d3.svg.symbol()
				.type(@options.pointStyle)
				.size 65


			symbols = target.selectAll("path")
				.data(@collection.models)

			newsymbols = symbols.enter()
				.append("svg:path")
				.attr 
					d: symbol
					transform: "scale(2)"
				# .attr('r', 2)
			
			# newsymbols.on 'mouseover', (d, i)=>
			# 	@trigger "hoverPoint", d, i

			# newsymbols.on 'click', (d, i)=>
			# 	@trigger "selectPoint", d, i
				

			symbols.exit().transition()
				.duration(500)
				.attr({
					transform: @_getSymbolTransform 0
				})
				.remove()

			# symbols.attr transform: @_getSymbolTransform 2

			symbols.transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.attr {
					class: 'point'
					transform: @_getSymbolTransform 1
				}


		_getSymbolTransform: (scale = 1)->
			xscale = @_xScale
			yscale = @_yScale

			transformFunction = (d, i)->
				x = xscale d.get('x')
				y = yscale d.get('y')
				"translate(#{x}, #{y}) scale(1)"

			return transformFunction

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
