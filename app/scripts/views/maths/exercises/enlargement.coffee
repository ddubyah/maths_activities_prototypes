define [
	'backbone'
	'underscore'
	'models/maths/ra_triangle'
	'models/charts/index'
	'views/charts/d3_mixins'
	'views/charts/index'
	'./enlargement_controls'
	'templates/maths/exercises/enlargement'

], (Backbone, _, RaTriangle, ChartModels, D3Mixins, ChartViews, EnlargementControlsView, EnlargementTemplate)->

	class EnlargementView extends Backbone.View

		template: EnlargementTemplate

		defaults: 
			scalor: 1
			transitionDuration: 500

		initialize: (options)->
			@options = _.defaults options, @defaults
			@_applyMixins D3Mixins

			@$el.html @template { title: 'Enlargement' }
			@shapeModel = @_getSourceModel()
			@enlargeShapeModel = new ChartModels.Shape geometry: @shapeModel.get('geometry').toJSON()

			@_originModel = new ChartModels.Shape 
				geometry: [
					{x: 0, y: 0, label: 'origin'}
				]

			@listenTo @_originModel.get('geometry'), 'change', @_onOriginChange

			@_shapeView = @_makeShapeView @shapeModel.get 'geometry'
			@$el.find('figure').first().append @_shapeView.el

			@_controlsView = @_makeControlsView()
			@_controlsView.render()

			@_enlargeShapeView = @_makeEnlargementView @enlargeShapeModel.get('geometry')
			@_shapeView.$el.append @_enlargeShapeView.el

			@_originView = @_makeOriginView @_originModel
			@_connectionsView = @_makeConnectorsView @_makeConnectorsGeometry()
			@_shapeView.$el.append @_connectionsView.el
			@_shapeView.$el.append @_originView.el


			window.shapeView = @_shapeView
			window.enlargehapeView = @_enlargeShapeView
			window.originView = @_originView
			window.connectionsView = @_connectionsView

			@_establishScales @_shapeView, @_shapeView.collection, @_originView.collection
			@_linkScales this, @_shapeView, @_enlargeShapeView, @_originView, @_connectionsView

			@_drawAxis @_shapeView

		_applyMixins: (mixins...)->
			_.extend this, mixin for mixin in arguments

		render: ->
			@_updateEnlargement()
			@_establishScales @_shapeView, @_shapeView.collection, @_enlargeShapeView.collection, @_originView.collection
			@_linkScales this, @_shapeView, @_enlargeShapeView, @_originView, @_connectionsView
			@_connectionsView.options.collections = @_makeConnectorsGeometry()

			@_shapeView.render()
			@_enlargeShapeView.render()
			@_originView.render()
			@_connectionsView.render()
			@_refreshAxis this

		_updateEnlargement: ->
			@enlargeShapeModel.get('geometry').reset(@shapeModel.get('geometry').toJSON())
			@enlargeShapeModel.scale @options.scalor, @_originModel.get('geometry').first().attributes

		_getSourceModel: ->
			if @options.shape_id?
				raTri = new RaTriangle id: @options.shape_id
				raTri.fetch()
			else
				raTri = new RaTriangle()
			raTri

		_makeControlsView: ->
			controlsView = new EnlargementControlsView el: @$el.find('#controls'), model: @shapeModel, origin: @_originModel, scalor: @options.scalor
			@listenTo controlsView, 'update', (event)=>
				@_originModel.get('geometry').first().set x: Number(event.origin.x), y: Number(event.origin.y)
				unless isNaN(event.scale)
					@options.scalor = event.scale
					@render()
			controlsView

		_makeShapeView: (geometry)->
			geometryView = new ChartViews.GeometrySVG 
				collection: geometry
				className: 'chart'
				transitionDuration: @options.transitionDuration
				padding: 50
				pointStyle: 'circle'
			geometryView

		_makeEnlargementView: (geometry)->
			enlargementView = new ChartViews.GeometrySVG
			# enlargementView = new ChartViews.PathsSVG
				tagName: 'g'
				collection: geometry
				className: 'enlargement'
				transitionDuration: @options.transitionDuration
				pointStyle: 'square'
				padding: 50
				interpolation: 'linear-closed'
			enlargementView

		_makeOriginView: (shape)->
			shapeView = new ChartViews.GeometrySVG
				tagName: 'g'
				collection: shape.get('geometry')
				className: 'origin'
				pointStyle: 'cross'
				dragPoints: true
				padding: 50
				symbolSize: ->
					150

			@listenTo shapeView, "dragend", (d, i)=>
				@render()
			shapeView

		_makeConnectorsView: (geometries)->
			joinsView = new ChartViews.PathsSVG
				className: 'pointConnectors'
				transitionDuration: @options.transitionDuration
				interpolation: 'cardinal'
				collections: geometries
			joinsView

		_makeConnectorsGeometry: ()->
			# connect from origin through the shape and enlargement points
			connections = for point, index in @shapeModel.get('geometry').models
				originPoint = @_originModel.get('geometry').at 0
				shapePoint = point
				enlargementPoint = @enlargeShapeModel.get('geometry').at index
				connection = new ChartModels.Geometry [originPoint, shapePoint, enlargementPoint]
			connections


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

		_onOriginChange: ()->
			# console.log "Whoop! %s", @_originModel.attributes
			@_connectionsView.render(0)



