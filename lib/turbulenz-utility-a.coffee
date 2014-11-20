###

  Project Name: turbulenz-utility-a package
  Date:2014.11.17
  Created by: Lightnet
  Link: https://github.com/Lightnet/turbulenz-utility-a
  license: MIT

  Check for more information on readme.txt file.

###

TurbulenzUtilityAView = require './turbulenz-utility-a-view'

module.exports =
  #configDefaults:
  config:
    showtoolbar: false
    showconsole: false
    bMainFile:false

  turbulenzUtilityAView: null

  activate: (state) ->
    @turbulenzUtilityAView = new TurbulenzUtilityAView(state.turbulenzUtilityAViewState)

  deactivate: ->
    @turbulenzUtilityAView.destroy()

  serialize: ->
    turbulenzUtilityAViewState: @turbulenzUtilityAView.serialize()
