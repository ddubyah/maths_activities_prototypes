class RATriangle

  @createByRatios: (baseLength, heightRatio)->

  _xScale: null 
  _yScale: null

  constructor: (@stage) ->
     # console.log "New triangle required!!! %s", d3

  xScale: (d3Scale)->
    return @_xScale if !arguments.length
    @_xScale = d3Scale

  yScale: (d3Scale)->
    return @_yScale if !arguments.length
    @_yScale = d3Scale

  draw: (data)->
     # console.log "Drawing"
    @data = data
    @stage.append('rect')
      .attr {
        width: 200
        height: 200
        class: 'testrect'
      }

define ['d3'], (d3)->
  RATriangle