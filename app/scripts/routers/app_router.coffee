define [
	"jquery"
	"backbone"
	"app"
	], ($, Backbone, AppView)->

	class AppRouter extends Backbone.Router
		@initialize: ->
			app = new AppRouter()
			app.start()

		routes: {
			"": "index"
			"*path": "index"
		}

		index: ->
			appView = new AppView({ el: $('#app') })
			appView.render()

		start: ->
			Backbone.history.start({ pushState: false })

	return AppRouter