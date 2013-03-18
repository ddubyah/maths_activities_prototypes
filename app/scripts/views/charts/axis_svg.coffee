define [
	'backbone'
	'underscore'
	'd3'
	'./svg_canvas'
	'./d3_mixins'
], (Backbone, _, D3, SVGCanvasView, D3Mixins)->

	class AxisSVGView extends SVGCanvasView
		tagName: 'g'
		className: 'axis'

		defaults: 
			scale: null
			orient: 'bottom'
			ticks: null
			transitionDuration: 500
			transitionEase: 'cubic-in-out'


		initialize: ->
			super()
			_.extend this, D3Mixins

			@options = _.extend @defaults, @options
			@axisGroup = @makePaddedGroup 'axis'

			@axisObject = D3.svg.axis()
				.scale(@options.scale)
				.orient(@options.orient)

			@axisObject.ticks(@ticks) if @options.ticks

		render: (aScale)->
			if aScale?
				@axisObject.scale aScale
			@axisGroup.transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.call @axisObject
			return this

		translate: (x=0, y=0)->
			console.log "Translating %d, %d", x, y
			console.log @options.transitionDuration
			D3.select(@el).transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.attr {
					transform: "translate(#{x}, #{y})"
				}

	AxisSVGView