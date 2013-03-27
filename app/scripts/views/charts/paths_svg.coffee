define [
	'backbone'
	'underscore'
	'd3'
	'./svg_canvas'
	'./d3_mixins'
], (Backbone, _, d3, SVGCanvasView, D3Mixins)->

	class PathsSVGView extends SVGCanvasView

		tagName: 'g'

		defaults: 
			transitionDuration: 500
			transitionEase: 'elastic'
			interpolation: 'linear-closed'
			collections: []

		initialize: (options)->
			@options = _.defaults options, @defaults
			@options.collections = @options.collections.concat @collection
			_.extend this, D3Mixins
			@_lineBuilder = @_makeLinebuilder()
			@parentGroup = @makePaddedGroup 'pathsSvgView'

		render: ->
			geometryGroups = @parentGroup.selectAll("g").data(@options.collections)
				
			newGeometryGroups = geometryGroups.enter()
			oldGeometryGroups = geometryGroups.exit()

			@_addNewGeometry newGeometryGroups
			@_removeOldGeometry oldGeometryGroups

			@_drawPaths geometryGroups



		_addNewGeometry: (newGroups)->
			console.log "Adding groups"
			newGroups.append("svg:g")
				.attr class: 'pathGeometry'

		_removeOldGeometry: (oldGroups)->
			oldGroups.transition()
				.duration(@options.transitionDuration)
				.attr({
					opacity: 0
				}).remove()

		_drawPaths: (geometryGroups)->
			lineBuilder = @_lineBuilder
			duration = @options.transitionDuration
			ease = @options.transitionEase

			geometryGroups.each (d,i)->
				path = d3.select(this)
					.selectAll('path').data([d.models])

				path.enter()
					.append('svg:path')
					.attr({
						class: "geometryPath_#{i}"
						})

				path.transition()
					.duration(duration)
					.ease(ease)
					.attr {
						d: (d)->
							lineBuilder(d)
					}

		_makeLinebuilder: ->
			parentGeometry = this

			lineBuilder = d3.svg.line()
			lineBuilder.x (d)->
				parentGeometry.xScale() d.get('x')

			lineBuilder.y (d)->
				parentGeometry.yScale() d.get('y')

			lineBuilder.interpolate @options.interpolation

			lineBuilder












