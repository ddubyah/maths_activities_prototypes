define [
	'backbone'
	'underscore'
], (Backbone, _)->
	# Create a properly namespaced svg view by overriding Backbone's
	# _ensureElement method
	class SVGCanvasView extends Backbone.View
		
		tagName: 'svg'
		
		nameSpace: "http://www.w3.org/2000/svg"

		defaults: {
			padding: 0
		}

		initialize: ->
			@options = _.extend @defaults, @options
		
		_ensureElement: ->
      unless @el
        attrs = _.extend({}, _.result(this, "attributes"))
        attrs.id = _.result(this, "id")  if @id
        attrs["class"] = _.result(this, "className")  if @className
        $el = $(window.document.createElementNS(_.result(this, "nameSpace"), _.result(this, "tagName"))).attr(attrs)
        @setElement $el, false
      else
        @setElement _.result(this, "el"), false
			
