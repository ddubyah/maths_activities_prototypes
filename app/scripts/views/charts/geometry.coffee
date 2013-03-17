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
			if @_selectedView?
				@_selectedView.render()
				@listenTo @_selectedView, 'selected', @_editPoint
				delete @_selectedView
			
			@_selectedView = pointView
			@stopListening pointView, 'selected'
			@_toggleEditView pointView.model, pointView.el
				

		_toggleEditView: (point, target)->
			@_editView = new PointEditView model: point, el: target, tagName: 'li'
			@_editView.render()

	return GeometryView