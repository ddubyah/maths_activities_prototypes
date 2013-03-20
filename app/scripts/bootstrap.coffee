require.config
	paths:
		jquery: "../components/jquery/jquery"
		handlebars: "../components/handlebars/handlebars"
		bootstrap: "vendor/bootstrap"
		underscore: "../components/underscore/underscore-min"
		backbone: "../components/backbone/backbone-min"
		localStorage: "../components/backbone.localStorage/backbone.localStorage-min"
		d3: "../components/d3/d3.min"

	shim:
		bootstrap:
			deps: ["jquery"]
			exports: "jquery"

		handlebars:
			exports: "Handlebars"

		underscore:
			exports: "_"

		backbone:
			deps: ["underscore"]
			exports: "Backbone"

		d3:
			exports: "d3"

require ["jquery", "routers/app_router"], ($, AppRouter, _) ->
	"use strict"
	# console.log "Running jQuery %s", $().jquery
	$ ->
		AppRouter.initialize()