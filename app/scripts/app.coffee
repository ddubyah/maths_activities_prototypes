
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
    			Backbone.history.navigate e.target.pathname, trigger: true
    	}
    	render: ->
    		console?.log "Rendering the app"
    		@$el.html indextemplate {
    			links: [
    				{ name: "Experiments in d3", link: "experiments/d3", local: true	}
    			]
    		}



    PrototypeMathsApp