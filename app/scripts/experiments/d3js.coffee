'use strict'
jQuery ->
	data = [4, 8, 15, 16, 23, 42]
	triangles = [
		{ x: 20, y: 5 }
		{ x: 25, y: 40 }
		{ x: 60, y: 20 }
	]	

	triangles2 = [
		{ x: 60, y: 15 }
		{ x: 5, y: 40 }
		{ x: 70, y: 30 }
	]

	x1 = d3.scale.linear()
		.domain([0, d3.max(data)])
		.range(['0px', '420px'])

	fig1 = d3.select('figure#fig1').append('svg')
		.attr('class', 'chart')
		.attr('width', '420px')
		.attr('height', 20 * data.length)

	console.log "Fig 1 height: %d", 20 * data.length

	fig1.selectAll('rect')
		.data(data)
		.enter().append('rect')
		.attr('height', 20)
		.attr('width', x1)
		.attr('y', (d, i)->
			i * 20
		)

	ymax = d3.max triangles, (d)->
		d.y
	xmax = d3.max triangles, (d)->
		d.x

	xScale = d3.scale.linear()
		.domain([0, xmax])
		.range([0, 250])
		.nice()
	yScale = d3.scale.linear()
		.domain([ymax, 0])
		.range([0, 250])
		.nice()

	h2 = 300
	w2 = 350

	fig2 = d3.select('figure#fig2')
		.append('svg')
			.attr({
				'width': 350
				'height': 300
				'class': 'chart'
				})

	padding = 30

	chart = fig2.append('g')
		.attr({
			transform: "translate(#{padding}, #{padding})"
			})

	# axesGroup = chart.append('g')
	# 	.attr('class', 'axes')

	yAxis = d3.svg.axis()
		.scale(yScale)
		.orient('left')
		.ticks(10)

	xAxis = d3.svg.axis()
		.scale(xScale)
		.orient('bottom')
		.ticks(10)


	gxAxis = chart.append('g')
		.attr('class', 'axis')
		.attr({
			transform: "translate(0, #{yScale(0)})"
		}).call xAxis

	gyAxis = chart.append('g')
		.attr('class', 'axis')
		.attr({
			# transform: "translate(0, #{yScale 0})"
		}).call yAxis

	joins = chart.append('g')
		.attr({
				class: 'joins'
			})

	circles = chart.selectAll('circle')
			.data(triangles)
			.enter()
				.append('circle')
				.attr({
					'cx': (d)->
						xScale d.x
					'cy': (d)->
						yScale d.y
					'r': 5
					'class': 'point'
				})


	line = d3.svg.line()
		.x((d)->
			xScale d.x
			)
		.y((d)->
			yScale d.y
		)
		.interpolate "linear-closed"


	pathData = triangles

	path = joins.append('g')
		.data([pathData])
	.append('svg:path')
			.attr({
				d: (d)->
					line(d)
			})
	
	updateCircles = (data)=>
		ymax = d3.max data, (d)->
			d.y
		xmax = d3.max data, (d)->
			d.x

		xScale.domain([0, xmax])
			# .range([0, 250])
		yScale.domain([ymax, 0])
			# .range([0, 250])
		xAxis.scale xScale
		yAxis.scale yScale
		gxAxis.transition()
			.duration(500)
			.ease('elastic')
			.call xAxis
		gyAxis.transition()
			.duration(500)
			.ease('elastic').call yAxis
		console.log "updating"	
		circles.data(data)
			.enter().append('circle')

		circles.transition()
		.duration(500)
		.ease('elastic')
		.attr {
			cx: (d)->
				xScale d.x
			cy: (d)->
				yScale d.y
		}
		path.data [data]
		# pathData = data
		path.transition()
			.duration(500)
			.ease('elastic')
			.attr({
				d: (d)->
					line(d)
				})


	$('.tri1').click (e) ->
		updateCircles triangles	
		e.stopPropagation()

	$('.tri2').click (e) ->
		updateCircles triangles2
		e.stopPropagation()
		
	# chart.selectAll('text')
	# 	.data(triangles)
	# 	.enter()
	# 		.append('g')
	# 			.attr({
	# 				transform: "translate(10, 15)"
	# 				})
	# 		.append('text')
	# 		.text( (d)->
	# 			console.log "(%d, %d) -> (#{xScale d.x}, #{yScale d.y})", d.x, d.y
	# 			"(#{d.x}, #{d.y})"
	# 		)
	# 		.attr({
	# 			x: (d)->
	# 				xScale d.x
	# 			y: (d)->
	# 				yScale d.y
	# 			class: 'label'
	# 			})

	# # lines



	# axes.call yAxis
