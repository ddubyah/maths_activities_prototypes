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
			[paddedWidth, paddedHeight] = @getPaddedDimensions()


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

		clampBoundsToWidth: (el)->
			[paddedWidth, paddedHeight] = @getPaddedDimensions(el)

			xMax = @getMaxModelProperty 'x'
			yMax = @getMaxModelProperty 'y'

			xMin = @getMinModelProperty 'x'
			yMin = @getMinModelProperty 'y'

			extent = D3.extent [xMax, yMax, xMin, yMin]
			console.log "Full extent = "+ extent
			window.extent = extent
			@_ensureScale @xScale, extent, [0, paddedWidth]
			@_ensureScale @yScale, extent.reverse(), [0, paddedWidth]

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
			return @options.padding || 30 unless arguments.length
			@options.padding = dx

		xScale: (aScale)->
			return @_xScale unless arguments.length 
			console.log "Setting x scale"
			@_xScale = aScale		

		yScale: (aScale)->
			return @_yScale unless arguments.length 
			console.log "Setting y scale "+ aScale
			@_yScale = aScale

		getPaddedDimensions: ->
			paddedWidth = @$el.width() - (@padding() * 2)
			paddedHeight = @$el.height() - (@padding() * 2)
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

		_findLargestDomain: (domain1, domain2)->
			dx1 = domain1[1] - domain2[0]

		_ensureScale: (scaleGetter, domain, range)->
			if scaleGetter()
				console.log "Updating scale to ensure"
				@_updateScale scaleGetter(), domain, range
			else
				console.log "Creating scale to ensure"
				scaleGetter.call this, @_makeScale(domain, range)

	}

	return D3ViewMixins
