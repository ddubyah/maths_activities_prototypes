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
			dragPoints: false
			decimals: 3
			dasharray: null
			symbolSize: (d, i)->
				65
		}
				
		initialize: (options)->
			@options = _.defaults options, @defaults

			# NB - If you can't find it here, look in the 
			@_applyMixins D3Mixins

			@lineGroup = @makePaddedGroup('line')
			@pointsGroup = @makePaddedGroup 'points'

			@_pointSymbol = d3.svg.symbol()
				.type(@options.pointStyle)
				.size @options.symbolSize

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

			symbols = target.selectAll("path")
				.data(@collection.models)

			newsymbols = symbols.enter()
				.append("svg:path")
				.attr 
					d: @_pointSymbol
					transform: "scale(2)"

			@_dragHandler = @_dragPointSetup() unless @_dragHandler?

			newsymbols.call @_dragHandler if @options.dragPoints

			symbols.exit().transition()
				.duration(500)
				.attr({
					transform: @_getSymbolTransform 0
				})

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
					})

			path.transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.attr {
					d: (d)->
						lineBuilder(d)
				}

		_dragPointSetup: ->
			console.log "Setting up drag"
			parentView = this
			xscale = @_xScale
			yscale = @_yScale
			options = @options
			drag = D3.behavior.drag()
				.on "drag", (d, i)->
					x = d3.event.x
					y = d3.event.y
					mapX = parentView.xScale().invert(x)
					mapY = parentView.yScale().invert(y)
					d3.select(this).attr "transform",	"translate(#{x},#{y})"
					# console.log "translate(#{x},#{y}) - (#{mapX}, #{mapY})"
					d.set 'x', Number mapX.toFixed(options.decimals)
					d.set 'y', Number mapY.toFixed(options.decimals)

			drag.on "dragend", (d, i)=>
				# console.log "Complete"
				@trigger "dragend", d, i
			drag



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
