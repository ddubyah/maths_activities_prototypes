define [
	'backbone'
	'underscore'
	'models/maths/ra_triangle'
	'views/charts/d3_mixins'
	'views/charts/index'
	'./enlargement_controls'
	'templates/maths/exercises/enlargement'

], (Backbone, _, RaTriangle, D3Mixins, ChartViews, EnlargementControlsView, EnlargementTemplate)->

	class EnlargementView extends Backbone.View

		template: EnlargementTemplate

		_scalor: 1

		initialize: ->
			@_applyMixins D3Mixins

			@$el.html @template { title: 'Enlargement' }
			@model = @_getSourceModel()

			@_diagram = @_makeDiagram @model.get 'geometry'
			@$el.find('figure').first().append @_diagram.el

			@_controlsView = @_makeControls()
			@_controlsView.render()

			@_enlargement = @_makeEnlargement @model.get 'geometry'
			@_diagram.$el.append @_enlargement.el

			window.enlargementView = @_enlargement

			@_establishScales @_diagram, @_diagram.collection
			@_linkScales this, @_diagram, @_enlargement

			# @_diagram.render()
			@_drawAxis @_diagram

		_applyMixins: (mixins...)->
			_.extend this, mixin for mixin in arguments

		render: ->
			@_updateEnlargement()
			@_establishScales @_diagram, @_diagram.collection, @_enlargement.collection
			@_linkScales this, @_diagram, @_enlargement

			@_diagram.render()
			@_enlargement.render()
			@_refreshAxis this

		_updateEnlargement: ->
			enlargedTriangle = @_enlargeTriangle @model, @_scalor
			enlargedGeometry = enlargedTriangle.get 'geometry'
			@_enlargement.collection = enlargedGeometry

		_getSourceModel: ->
			if @options.shape_id?
				raTri = new RaTriangle id: @options.shape_id
				raTri.fetch()
			else
				raTri = new RaTriangle()

			raTri

		_makeControls: ->
			controlsView = new EnlargementControlsView el: @$el.find('#controls'), model: @model
			@listenTo controlsView, 'update', (scalor)=>
				unless isNaN(scalor)
					@_scalor = scalor
					@render()
			controlsView

		_makeDiagram: (geometry)->
			geometryView = new ChartViews.GeometrySVG 
				collection: geometry
				className: 'chart'
				padding: 50

			geometryView

		_makeEnlargement: (geometry)->
			enlargementView = new ChartViews.GeometrySVG
				tagName: 'g'
				collection: geometry
				className: 'enlargement'
				transitionDuration: 2000
				padding: 50
			enlargementView

		_drawAxis: (diagram)->
			console.log "Creating axis"
			@xAxis = @_makeAxis {
				scale: diagram.xScale()
				padding: diagram.padding()
				orient: 'bottom'
			}

			@yAxis = @_makeAxis {
				scale: diagram.yScale()
				padding: diagram.padding()
				orient: 'left'
			}
			diagram.$el.append @xAxis.el
			diagram.$el.append @yAxis.el


		_makeAxis: (options)->
			console.log "New axis with "+ options
			myAxis = new ChartViews.AxisSVG options
			myAxis.render()
			myAxis

		_refreshAxis: (parentView)->
			@xAxis.translate( 0, parentView.yScale()(0))
			@yAxis.translate( parentView.xScale()(0), 0 )
			@xAxis.render(parentView.xScale())
			@yAxis.render(parentView.yScale())

		_establishScales: (mainDiagram, geometries...)->
			[paddedWidth, paddedHeight] = mainDiagram.getPaddedDimensions()
			allValues = []

			for geo in geometries
				console.log "Plucking"
				console.log geo
				xs = geo.pluck 'x'
				ys = geo.pluck 'y'
				allValues = allValues.concat(xs).concat(ys)

			range = [0, paddedWidth]
			domain = d3.extent allValues

			@_ensureScale @xScale, domain, range
			@_ensureScale @yScale, domain.reverse(), range

		_linkScales: (parent, diagrams...)->
			for diagram in diagrams
				diagram.xScale parent.xScale()
				diagram.yScale parent.yScale()

		_enlargeTriangle: (triangle, scale)->
			console.log "Scaling triangle"

			newTri = new RaTriangle
				dx: triangle.attributes.dx * scale
				dy: triangle.attributes.dy * scale
			newTri

		_enlargeGeometry: (geometry, scale)->
			sourceGeo = geometry.toJSON()
			console.log "Source geometry: "
			console.log sourceGeo
			newGeometry = []
			for geo in sourceGeo
				newGeometry = newGeometry.concat {
					label: geo.label
					x: geo.x * scale
					y: geo.y * scale
				}
			console.log "Enlarged geometry: "
			console.log newGeometry

