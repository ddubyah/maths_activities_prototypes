'use strict'

jQuery =>
	fig1 = $('figure#fig1')[0]

	paper = new Raphael fig1, 500, 500

	# Draw a circle?
	circle = paper.circle 100, 100, 80
	$(circle.node).attr 'class', 'chart'
