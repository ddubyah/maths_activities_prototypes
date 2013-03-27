define [
	'backbone'
	'views/charts/index'
	'templates/maths/exercises/enlargement_form'
], (Backbone, ChartViews, EnlargementFormTemplate)->

	class EnlargementFormView extends Backbone.View
		template: EnlargementFormTemplate

		events:
			'submit': 'save'

		render: ->
			@$el.html @template shape: @model.attributes, origin: @options.origin.get('geometry').first().attributes
			this

		save: (e)->
			e.preventDefault()
			# errors = @model.save 
			# 	dx: Number @$el.find('input[name=dxInput]').val()
			# 	dy: Number @$el.find('input[name=dyInput]').val()
			@trigger "update", 
				scale: @$el.find('input[name=scaleInput]').val()
				origin:
					x: @$el.find('input[name=originXInput]').val()
					y: @$el.find('input[name=originYInput]').val()
			