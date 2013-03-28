require.config {
	paths: {
		jquery: '/components/jquery/jquery'
		d3: '/components/d3/d3'
		bootstrap: '../vendor/bootstrap'
	}
	shim: {
		bootstrap: {
			deps: ['jquery']
			exports: 'jquery'
		}
		d3: {
			deps: []
			exports: 'd3'
		}
	}
}

require ['ra_triangle', 'd3', 'jquery', 'bootstrap'], (RATriangle, d3, $)->
	'use strict';
	# // use app here
	#  # console.log(app);
	 # console.log('Running jQuery %s', $().jquery);
	 # console.log "Running d3, %s", d3
	chart = d3.select('#fig1').append('svg')
		.attr {
			width: 640
			height: 480
		}
	myT = new RATriangle(chart)
	myT.xScale 'duff'
	 # console.log myT.xScale()
	myT.draw()