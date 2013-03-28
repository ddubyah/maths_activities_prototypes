define [
	'./geometry'
	'./geometry_svg'
	'./paths_svg'
	'./svg_canvas'
	'./axis_svg'
	'./point_labels_svg'
	'./point_view'
	'./point_edit'
],(Geometry, GeometrySVGView, PathsSVGView, SVGCanvasView, AxisSVG, PointLabelsSVG, Point, PointEdit)->
	{
		Geometry: Geometry
		SVGCanvas: SVGCanvasView
		GeometrySVG: GeometrySVGView
		PathsSVG: PathsSVGView
		AxisSVG: AxisSVG
		PointLabelsSVG: PointLabelsSVG
		Point: Point
		PointEdit: PointEdit
	}