define [
	"jquery"
	"backbone"
	"app"
	"views/experiments/d3_playground"
	"views/experiments/d3"
	], ($, Backbone, AppView, d3View, d3TestView)->

	class AppRouter extends Backbone.Router
		@initialize: ->
			app = new AppRouter()
			app.start()

		routes: {
			"": "index"
			"experiments/d3playground": "d3Playground"
			"experiments/d3tester": "d3tester"

			"*path": "index"

		}

		index: ->
			appView = new AppView({ el: $('#app') })
			appView.render()

		start: ->
			Backbone.history.start({ pushState: false })

		d3Playground: ->
			d3 = new d3View { el: $('#app') }
			d3.render()

		d3tester: ->
			d3 = new d3TestView el: $('#app')
			d3.render()
	return AppRouter