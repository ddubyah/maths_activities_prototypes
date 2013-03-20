define [
	'backbone'
	'models/charts/point'
	'templates/charts/point_edit_form'
], (Backbone, Point, PointEditTemplate)->

	class PointEditView extends Backbone.View
		events:
			submit: 'save'

		template: PointEditTemplate

		initialize: ->
			@listenTo @model, 'change', @render
			

		render: ->
			@$el.empty()
			@$el.append @template @model.attributes
			return this

		save: (e)->
			e.preventDefault()
			newX = @$('input[name=x]').val() || @model.get 'x'
			newY = @$('input[name=y]').val() || @model.get 'y'

			@model.set 'x', newX, validate: true #if @_validateDigits newX
			@model.set 'y', newY, validate: true #if @_validateDigits newY
			@trigger 'update', this

		_validateDigits: (input)->
			r = /^-?\d+$/
			r.test input

	PointEditView
	
