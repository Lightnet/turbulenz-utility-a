TurbulenzUtilityAView = require './turbulenz-utility-a-view'

module.exports =
  turbulenzUtilityAView: null

  activate: (state) ->
    @turbulenzUtilityAView = new TurbulenzUtilityAView(state.turbulenzUtilityAViewState)

  deactivate: ->
    @turbulenzUtilityAView.destroy()

  serialize: ->
    turbulenzUtilityAViewState: @turbulenzUtilityAView.serialize()
