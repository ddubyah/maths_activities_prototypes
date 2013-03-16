define [
	'backbone'
	'd3'
	'./svg_canvas'
	'models/charts/index'
], (Backbone, D3, SVGCanvasView, ChartModels)->

	class Geometry extends SVGCanvasView
		tagName: 'svg'

		# defaults for stage size
		_padding: 30
		
		initialize: ->
			console.log "initializing geo"
			@lineGroup = @_makePaddedGroup 'line'
			@pointsGroup = @_makePaddedGroup 'points'

			window.d3 = D3

		render: ->
			@_setCanvasHeightByXScale()
			@calculateScales()
			@_drawPoints(@pointsGroup)
			@_drawLine(@lineGroup)
			this

		calculateScales: ->
			paddedWidth = @$el.width() - (@_padding * 2)
			paddedHeight = @$el.height() - (@_padding * 2)

			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'

			xMin = @getMinModelProperty 'x', 0
			yMin = @getMinModelProperty 'y', 0

			# make minimums at least 0
			xMin = D3.min [xMin, 0]
			yMin = D3.min [yMin, 0]
			
			@xScale @_makeScale [xMin, xMax], [0, paddedWidth]
			@yScale @_makeScale [yMin, yMax], [0, paddedHeight]

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

			xScale = @_makeScale [0, xMax], [0, availableWidth]
			dy = xScale yMax
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
			console.log "Making scale for %s -> %s", domain, range
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
			lineBuilder = @_makeLine()
			path = target
				.data([@collection.models])
			.append('svg:path')

			path.transition()
				.duration(500)
				.ease('elastic')
				.attr({
					class: 'shape'
					d: (d)->
						lineBuilder(d)
					})

		_makeLine: (lineGroup)->
			xscale = @_xScale
			yscale = @_yScale
			line = d3.svg.line()
			line.x (d)->
					xscale d.get('x')

			line.y (d)->
					yscale d.get('y')

			line.interpolate "linear-closed"
			line
	return Geometry
