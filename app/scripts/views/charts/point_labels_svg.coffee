define [
	'backbone'
	'underscore'
	'd3'
	'./svg_canvas'
	'./d3_mixins'
], (Backbone, _, D3, SVGCanvasView, D3Mixins)->

	class PointLabelsSVG extends SVGCanvasView
		tagName: 'g'
		className: 'pointLabels'

		defaults: 
			padding: 0
			offset: [-30, -20]
			transitionDuration: 500
			transitionEase: 'elastic'

		initialize: ->
			super()
			_.extend this, D3Mixins
			@textGroup = @makePaddedGroup 'text'
			@xScale @options.xScale
			@yScale @options.yScale

		render: ->
			throw new Error('Missing xScale') unless @xScale()
			throw new Error('Missing yScale') unless @yScale()
			labels = @textGroup.selectAll('text')
				.data(@collection.models)

			newLabels = labels.enter()
				.append('text')
				.attr {
					class: 'label'
					transform: "translate(50, 50)"
				}

			labels.exit().transition()
				.duration(@options.transitionDuration)
				.attr({
					opacity: 0
				}).remove()

			labels.text (d, i)->
				"#{d.get('label')}(#{d.get('x')},#{d.get('y')})"

			labels.transition()
				.duration(@options.transitionDuration)
				.ease(@options.transitionEase)
				.attr {
					x: (d)=>
						(@xScale()(d.get 'x')) + @options.offset[0]
					y: (d)=>
						(@yScale()(d.get 'y')) + @options.offset[1]
				}
			this

	return PointLabelsSVG
