define [
	'backbone'
	'templates/maths/ra_triangles/ra_triangles_edit_form'
], (Backbone, RaEditTemplate)->

	class RaTriangleEditView extends Backbone.View

		events:
			'submit': 'save'

		render: ->
			@$el.html RaEditTemplate(@model.attributes)
			this

		save: (e)->
			e.preventDefault()
			errors = @model.save 
				dx: @$el.find('input[name=dxInput]').val()
				dy: @$el.find('input[name=dyInput]').val()
			@trigger "update"
			