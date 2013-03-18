define [
	'./geometry'
	'./geometry_svg'
	'./svg_canvas'
	'./axis_svg'
	'./point_labels_svg'
],(Geometry, GeometrySVGView, SVGCanvasView, AxisSVG, PointLabelsSVG)->
	{
		Geometry: Geometry
		SVGCanvas: SVGCanvasView
		GeometrySVG: GeometrySVGView
		AxisSVG: AxisSVG
		PointLabelsSVG: PointLabelsSVG
	}