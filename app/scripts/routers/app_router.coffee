define [
	"jquery"
	"backbone"
	"../app_menu"
	"views/experiments/d3_playground"
	"views/experiments/d3"
	"views/maths/index"
	], ($, Backbone, AppView, d3View, d3TestView, MathViews)->

	class AppRouter extends Backbone.Router
		@initialize: ->
			app = new AppRouter()
			app.start()

		routes: {
			"": "index"
			"experiments/d3playground": "d3Playground"
			"experiments/d3tester": "d3tester"
			"maths/ra_triangles(/:id)(/)": "raTriangle"
			"maths/exercises/enlargement(/:shape_id)(/)": "mathsEnlargements"

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

		raTriangle: (id)->
			raTriangleBuilder = new MathViews.RaTriangleBuilder el: $('#app'), shape_id: id
			raTriangleBuilder.render()

		mathsEnlargements: (shape_id)->
			 # console.log "Enlargements!"
			enlargementView = new MathViews.Exercises.Enlargement el: $('#app'), shape_id: shape_id, scalor: 2, transitionDuration: 1500
			enlargementView.render()

		d3tester: ->
			d3 = new d3TestView el: $('#app')
			d3.render()

	return AppRouter