require.config
	paths:
		jquery: "../components/jquery/jquery"
		handlebars: "../components/handlebars/handlebars"
		bootstrap: "vendor/bootstrap"
		underscore: "../components/underscore/underscore-min"
		backbone: "../components/backbone/backbone"

	shim:
		bootstrap:
			deps: ["jquery"]
			exports: "jquery"

		handlebars:
			exports: "Handlebars"

		backbone:
			deps: ["underscore"]
			exports: "Backbone"

require ["jquery", "routers/app_router"], ($, AppRouter) ->
	"use strict"
	# console.log "Running jQuery %s", $().jquery
	$ ->
		AppRouter.initialize()