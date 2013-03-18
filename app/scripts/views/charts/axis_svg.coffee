define [
	'backbone'
	'underscore'
	'd3'
	'./svg_canvas'
], (Backbone, _, D3, SVGCanvasView)->

	class AxisSVGView extends SVGCanvasView
		tagName: 'g'

		defaults: 
			scale: null
			orient: 'bottom'
			ticks: null


		initialize: ->
			@options = _.extend @defaults, @options

			@axisGroup = D3.select(@el).append('g')
				.attr({
					class: 'axis'
				})

			@axisObject = D3.svg.axis()
				.scale(@options.scale)
				.orient(@options.orient)

			@axisObject.ticks(@ticks) if @options.ticks

		render:->
			@axisGroup.call @axisObject
			return this

	AxisSVGView