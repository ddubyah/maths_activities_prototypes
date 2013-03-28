define [
	'jquery'
	'backbone'
	'd3'
	'models/charts/point'
	'models/charts/geometry'
	'templates/experiments/d3'
], ($, Backbone, d3, Point, Geometry, d3Template)->

	class D3View extends Backbone.View
		_padding: 30	

		tagName: 'svg'

		events: {
			'click': (e)->
				 # console.log "Whoop"
				@_movePoints 5
				@_drawPoints()
		}

		initialize: ->
			window.d3 = d3
			 # console.log "Creating new d3 view"
			@collection = @_makeGeo()	
			@chart = @_makeChart()
			@_makeLine()

			@_updateScales() if @collection.length
		
		render: ->
			@_drawLine()
			@_drawPoints()
			return this

		_drawPoints: ->
			xscale = @_xScale
			yscale = @_yScale

			circles = @chart.selectAll('circle')
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

		_makeLine: ->
			xscale = @_xScale
			yscale = @_yScale
			line = d3.svg.line()
			line.x (d)->
					xscale d.get('x')

			line.y (d)->
					yscale d.get('y')

			line.interpolate "linear-closed"
			@_line = line


		_drawLine: ->
			line = @_line
			@chart.append('g')
				.data([@collection.models])
			.append('svg:path')
				.attr({
					d: (d)->
						line d
					})

		_makeGeo: ->
			geo = new Geometry [
				{ x: 20, y: 20 }
				{ x: 50, y: 20 }
				{ x: 20, y: 50 }
			]
			geo

		_makeChart: ->
			@$el.html d3Template({ title: 'D3 Rocks' })
			chart = d3.select(@el).select('figure')
				.append('svg')
					.attr({
						class: 'chart'
						# height: 400
						# width: 500
					})
					.append('g').attr {
						transform: "translate(#{@_padding}, #{@_padding})"
					}

			@xScale(@makeScale [0, 500], [0, (500 - (2 * @_padding))]) # 1:1
			@yScale(@makeScale [0, 400], [0, (400 - (2 * @_padding))]) # 1:1
			
			chart

		_updateScales: ->
			 # console.log "Updating Scales"
			models = @collection.models
			xMax = d3.max models, (d)->
				d.get 'x'

			yMax = d3.max models, (d)->
				d.get 'y'

			@xScale().domain [0, xMax]
			@yScale().domain [yMax, 0]

		_movePoints: (range)->
			for point in @collection.models
				dx = @_randomize range
				dy = @_randomize range
				point.set 'x', point.get('x') + dx
				point.set 'y', point.get('y') + dy

		_randomize: (range=50)->
			range - (Math.round(Math.random()*(range*2)))
			

		makeScale: (domain, range)->
			 # console.log "scaling #{domain} to #{range}"
			d3.scale.linear()
				.domain(domain)
				.range(range)
				.nice()

		xScale: (aScale)->
			return @_xScale unless arguments.length 
			@_xScale = aScale		

		yScale: (aScale)->
			return @_yScale unless arguments.length 
			@_yScale = aScale

		padding: (num)->
			return @_padding unless arguments.length
			@padding = num



	D3View
