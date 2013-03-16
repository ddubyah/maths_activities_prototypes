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
		_width: 640
		_height: 480
		
		initialize: ->
			console.log "initializing geo"
			@stage = @_makeStage()
			window.d3 = D3

		render: ->
			@_drawPoints()
			this

		rescale: ->
			# set element scale
			# @$el.attr 'width', @_width
			# @$el.attr 'height', @_height
			xMax = D3.max @collection.models, (d)->
				d.get 'x'
			yMax = D3.max @collection.models, (d)->
				d.get 'y'

			@xScale @_makeScale [0, xMax], [0, 500]
			@yScale @_makeScale [0, yMax], [0, 400]

		stageSize: (dx, dy, padding)->
			return [ @_width, @_height, @_padding ] unless arguments.length
			@_width = dx if dx?
			@_height = dy if dy?
			@_padding = padding if padding?

		padding: (dx)->
			return @_padding unless arguments.length
			@_padding = dx

		stageWidth: (dx)->
			return @_width unless arguments.length
			@_width = dx
		
		stageHeight: (dy)->
			return @_height unless arguments.length
			@_height = dy

		xScale: (aScale)->
			return @_xScale unless arguments.length 
			@_xScale = aScale		

		yScale: (aScale)->
			return @_yScale unless arguments.length 
			@_yScale = aScale

		_makeStage: ->
			stage = d3.select(@el)
				.append('g')
					.attr({
						# class: 'chart'
						# height: 400
						# width: 500
					})
					# .append('g').attr {
					# 	# transform: "translate(#{@_padding}, #{@_padding})"
					# }
			stage


		_makeScale: (domain, range)->
			console.log "Making scale for %s -> %s", domain, range
			D3.scale.linear()
				.domain(domain)
				.range(range)
				.nice()

		_drawPoints: ->
			xscale = @_xScale
			yscale = @_yScale

			circles = @stage.selectAll('circle')
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

		_drawLine: ->
			line = @_line
			@chart.append('g')
				.data([@collection.models])
			.append('svg:path')
				.attr({
					d: (d)->
						line d
					})

	return Geometry
