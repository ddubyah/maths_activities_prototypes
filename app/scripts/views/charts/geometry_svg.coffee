define [
	'backbone'
	'd3'
	'./svg_canvas'
	'models/charts/index'
], (Backbone, D3, SVGCanvasView, ChartModels)->

	class GeometrySVG extends SVGCanvasView

		tagName: 'svg'
		transitionDuration: 500
		transitionEase: 'elastic'

		# defaults for stage size
		_padding: 30
		
		initialize: ->
			@lineGroup = @_makePaddedGroup('line')
			@pointsGroup = @_makePaddedGroup 'points'
			# @line = @_makeLine @lineGroup
			@listenTo @collection, 'change', @render

		render: ->
			@calculateScales()
			@_setCanvasHeightByXScale()
			@_drawPoints(@pointsGroup)
			@_drawLine(@lineGroup)
			this

		calculateScales: ->
			paddedWidth = @$el.width() - (@_padding * 2)
			paddedHeight = @$el.height() - (@_padding * 2)

			# paddedHeight = paddedWidth if paddedHeight > paddedWidth

			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'

			xMin = @getMinModelProperty 'x', 0
			yMin = @getMinModelProperty 'y', 0

			# make minimums at least 0
			xMin = D3.min [xMin, 0]
			yMin = D3.min [yMin, 0]
			
			@xScale @_makeScale [xMin, xMax], [0, paddedWidth]
			@yScale @_makeScale [yMax, yMin], [0, paddedWidth]
			window.xScale = @xScale()
			window.yScale = @yScale()

		getMaxModelProperty: (modelProperty)->
			max = D3.max @collection.models, (d)->
				d.get modelProperty
			max

		getMinModelProperty: (modelProperty, ensureZero)->
			min = D3.min @collection.models, (d)->
				d.get modelProperty

			if ensureZero
				console.log "Forcing minimum"
				min = D3.min [min, 0]
			min

		padding: (dx)->
			return @_padding unless arguments.length
			@_padding = dx

		xScale: (aScale)->
			return @_xScale unless arguments.length 
			@_xScale = aScale		

		yScale: (aScale)->
			return @_yScale unless arguments.length 
			@_yScale = aScale

		_setCanvasHeightByXScale: ->
			availableWidth = @$el.width()
			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'
			xMin = @getMinModelProperty 'x', true
			yMin = @getMinModelProperty 'y', true

			scale = @_makeScale [yMin, yMax], [0, availableWidth]

			window.scale = scale
			dy = scale(yMax)
			console.log "Setting height to %d", dy
			@$el.height dy

		_makePaddedGroup: (className)->
			group = d3.select(@el)
				.append('g')
					.attr({
						class: className
						transform: "translate(#{@_padding}, #{@_padding})"
					})
			group


		_makeScale: (domain, range)->
			console.log "Making scale for %s -> %s", domain.toString(), range.toString()
			D3.scale.linear()
				.domain(domain)
				.range(range)
				.nice()

		_drawPoints: (target=(D3.select(@el)))->
			xscale = @_xScale
			yscale = @_yScale

			circles = target.selectAll('circle')
					.data(@collection.models)

			circles.enter()
				.append('circle')
				.attr('r', 2)

			circles.attr 'r': 8

			circles.transition()
				.duration(500)
				.ease('elastic')
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
				.duration(500)
				.ease('elastic')
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
