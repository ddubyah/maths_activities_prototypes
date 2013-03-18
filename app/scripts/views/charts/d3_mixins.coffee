define [
	'backbone'
	'underscore'
	'd3'
], (Backbone, _, D3)->

	D3ViewMixins = {
		makePaddedGroup: (className)->
			group = d3.select(@el)
				.append('g')

			group.attr({
						class: className
						transform: "translate(#{@options.padding}, #{@options.padding})"
					})
			group

		calculateScales: ->
			paddedWidth = @$el.width() - (@options.padding * 2)
			paddedHeight = @$el.height() - (@options.padding * 2)

			# paddedHeight = paddedWidth if paddedHeight > paddedWidth

			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'

			xMin = @getMinModelProperty 'x', 0
			yMin = @getMinModelProperty 'y', 0

			# make minimums at least 0
			xMin = D3.min [xMin, 0]
			yMin = D3.min [yMin, 0]
			
			@xScale @_makeScale [xMin, xMax], [0, paddedWidth]
			@yScale @_makeScale [yMax, yMin], [0, paddedWidth]
			@trigger 'rescale', @xScale(), @yScale() 

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
			return @options.padding unless arguments.length
			@options.padding = dx

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

			scale = @_makeScale [yMin, yMax], [0, availableWidth]
			dy = scale(yMax)
			@$el.height dy

		_makeScale: (domain, range)->
			console.log "Making scale for %s -> %s", domain.toString(), range.toString()
			D3.scale.linear()
				.domain(domain)
				.range(range)
				.nice()
	}

	return D3ViewMixins
