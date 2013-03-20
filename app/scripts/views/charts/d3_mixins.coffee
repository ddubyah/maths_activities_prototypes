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
			[paddedWidth, paddedHeight] = @_getPaddedDimensions()


			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'

			xMin = @getMinModelProperty 'x', 0
			yMin = @getMinModelProperty 'y', 0

			# make minimums at least 0
			xMin = D3.min [xMin, 0]
			yMin = D3.min [yMin, 0]
			 	
			@_ensureScale @xScale, [xMin, xMax], [0, paddedWidth]
			@_ensureScale @yScale, [yMax, yMin], [0, paddedWidth]
			
			@trigger 'rescale', @xScale(), @yScale() 

		ensureBoundsToWidth: ->
			[paddedWidth, paddedHeight] = @_getPaddedDimensions()

			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'

			xMin = @getMinModelProperty 'x', 0
			yMin = @getMinModelProperty 'y', 0

			# make minimums at least 0
			xMin = D3.min [xMin, 0]
			yMin = D3.min [yMin, 0]

			@calculateScales()




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
			console.log "Setting x scale"
			@_xScale = aScale		

		yScale: (aScale)->
			return @_yScale unless arguments.length 
			console.log "Setting y scale "+ aScale
			@_yScale = aScale

		_getPaddedDimensions: ->
			paddedWidth = @$el.width() - (@options.padding * 2)
			paddedHeight = @$el.height() - (@options.padding * 2)
			[paddedWidth, paddedHeight]

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
				.rangeRound(range)
				.nice()

		_updateScale: (scale, domain, range)->
			console.log "Updating scale for %s -> %s", domain.toString(), range.toString()
			scale.domain domain
			scale.rangeRound range

		_ensureScale: (scaleGetter, domain, range)->
			console.log "Checking scale for "+ scaleGetter
			if scaleGetter()
				console.log "Updating scale to ensure"
				@_updateScale scaleGetter(), domain, range
			else
				console.log "Creating scale to ensure"
				scaleGetter.call this, @_makeScale(domain, range)

	}

	return D3ViewMixins
