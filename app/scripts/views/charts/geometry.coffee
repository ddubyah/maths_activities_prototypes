define [
	'backbone'
	'views/charts/point_view'
	'views/charts/point_edit'

], (Backbone, PointView, PointEditView)->



	class GeometryView extends Backbone.View
		tagName: 'ul'
		className: 'pointList'

		initialize: ->
		_activeViews: []

		render: ->
			@_clearViews()
			for point in @collection.models
				pointView = new PointView model: point, className: 'pointView', tagName: 'li'
				@_activeViews.push pointView
				@listenTo pointView, 'selected', @_editPoint
				@$el.append pointView.render().$el
			return this

		_editPoint: (pointView)->
			@_resetViews()
			
			@_selectedView = pointView
			@stopListening pointView, 'selected'
				
			@_editView = new PointEditView {
				model: pointView.model
				el: pointView.el
				tagName: 'li'
			}
			@listenTo @_editView, 'update', @_resetViews
			@_editView.render()

		_clearViews: ->
			while oldView = @_activeViews.pop()
				 # console.log "Removing view "+ oldView
				@stopListening oldView
				oldView.remove()

		_resetViews: ()->
			 # console.log "Reseting views after updpate"
			if @_editView
				@stopListening @_editView 
				delete @_editView
			if @_selectedView?
				@_selectedView.render()
				@listenTo @_selectedView, 'selected', @_editPoint
				delete @_selectedView


	return GeometryView