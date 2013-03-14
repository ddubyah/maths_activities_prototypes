
define [
	'backbone'
	'views/templates/index'
	], (Backbone, indextemplate)->
    'use strict'

    class PrototypeMathsApp extends Backbone.View
    	events: {
    		'click a[data-local=true]': (e)->
    			e.preventDefault()
    			console?.log "Navigating to %s", e.target.pathname
    			Backbone.history.navigate e.target.pathname
    	}
    	render: ->
    		console?.log "Rendering the app"
    		@$el.html indextemplate {
    			links: [
    				{ name: "Experiments", link: "/experiments", local: true	}
    			]
    		}



    PrototypeMathsApp