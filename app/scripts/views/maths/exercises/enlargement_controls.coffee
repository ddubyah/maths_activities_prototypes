define [
	'backbone'
	'templates/maths/exercises/enlargement_form'
], (Backbone, EnlargementFormTemplate)->

	class EnlargementFormView extends Backbone.View
		template: EnlargementFormTemplate

		events:
			'submit': 'save'

		render: ->
			@$el.html @template(@model.attributes)
			this

		save: (e)->
			e.preventDefault()
			# errors = @model.save 
			# 	dx: Number @$el.find('input[name=dxInput]').val()
			# 	dy: Number @$el.find('input[name=dyInput]').val()
			@trigger "update", @$el.find('input[name=scaleInput]').val()
			