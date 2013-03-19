define [
	'backbone'
	'templates/maths/ra_triangles/ra_triangles_edit_form'
], (Backbone, RaEditTemplate)->

	class RaTriangleEditView extends Backbone.View

		render: ->
			console.log "Rendering triangle forms"
			@$el.html RaEditTemplate(@model.attributes)
			this