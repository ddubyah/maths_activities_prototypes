define [
	"jquery"
	"backbone"
	"app"
	"../views/experiments/d3"
	], ($, Backbone, AppView, d3View)->

	class AppRouter extends Backbone.Router
		@initialize: ->
			app = new AppRouter()
			app.start()

		routes: {
			"": "index"
			"experiments/d3": "d3"


			"*path": "index"

		}

		index: ->
			appView = new AppView({ el: $('#app') })
			appView.render()

		start: ->
			Backbone.history.start({ pushState: false })

		d3: ->
			d3 = new d3View { el: $('#app') }
			d3.render()

	return AppRouter