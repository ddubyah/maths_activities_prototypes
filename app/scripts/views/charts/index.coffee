define [
	'./geometry'
	'./geometry_svg'
	'./svg_canvas'
	'./axis_svg'
	'./point_labels_svg'
	'./point_view'
	'./point_edit'
],(Geometry, GeometrySVGView, SVGCanvasView, AxisSVG, PointLabelsSVG, Point, PointEdit)->
	{
		Geometry: Geometry
		SVGCanvas: SVGCanvasView
		GeometrySVG: GeometrySVGView
		AxisSVG: AxisSVG
		PointLabelsSVG: PointLabelsSVG
		Point: Point
		PointEdit: PointEdit
	}