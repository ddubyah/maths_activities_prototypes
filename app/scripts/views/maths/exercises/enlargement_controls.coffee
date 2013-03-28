define [
	'backbone'
	'underscore'
	'views/charts/index'
	'templates/maths/exercises/enlargement_form'
], (Backbone, _, ChartViews, EnlargementFormTemplate)->

	class EnlargementFormView extends Backbone.View
		template: EnlargementFormTemplate

		events:
			'submit': 'save'

		defaults: 
			scalor: 3

		initialize: (options)->
			@options = _.defaults options, @defaults
			@_listenToOriginChanges() if @options.origin?

		render: ->
			@$el.html @template shape: @model.attributes, origin: @options.origin.get('geometry').first().attributes, scalor: @options.scalor
			this

		save: (e)->
			e.preventDefault()
			# errors = @model.save 
			# 	dx: Number @$el.find('input[name=dxInput]').val()
			# 	dy: Number @$el.find('input[name=dyInput]').val()
			@options.scalor = @$el.find('input[name=scaleInput]').val()
			@trigger "update", 
				scale: @options.scalor
				origin:
					x: @$el.find('input[name=originXInput]').val()
					y: @$el.find('input[name=originYInput]').val()
			
		_listenToOriginChanges: ->
			console.log "Listening for changes to the origin"
			@listenTo @options.origin.get('geometry'), 'change', (e)=>
				@render()