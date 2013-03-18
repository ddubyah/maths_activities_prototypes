define [
	'backbone'
	'views/charts/point_view'
	'views/charts/point_edit'

], (Backbone, PointView, PointEditView)->



	class GeometryView extends Backbone.View
		tagName: 'ul'

		initialize: ->

		render: ->
			for point in @collection.models
				pointView = new PointView model: point, className: 'pointView', tagName: 'li'
				@listenTo pointView, 'selected', @_editPoint
				@$el.append pointView.render().$el
			return this

		_editPoint: (pointView)->
			console.log "Editing "+ pointView.model.get 'label'
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

		_resetViews: ()->
			if @_editView
				@stopListening @_editView 
				delete @_editView
			if @_selectedView?
				@_selectedView.render()
				@listenTo @_selectedView, 'selected', @_editPoint
				delete @_selectedView


	return GeometryView