###

  Project Name: turbulenz-utility-a package
  Date:2014.11.17
  Created by: Lightnet
  Link: https://github.com/Lightnet/turbulenz-utility-a
  license: MIT

  Check for more information on readme.txt file.

###

#AnsiFilter = require 'ansi-to-html'
#_ = require 'underscore'
{View,BufferedProcess} = require 'atom'

module.exports =
class TurbulenzUtilityAToolBarView extends View
  @bufferedProcess: null

  @content: ->
    @div class: 'panel-heading padded heading header-view', => #header
      @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'toggleconsole'
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'
      @span

      @span class: 'heading-status icon-file-binary', outlet: 'icon_playbackplay', click: ''
      @label 'Assets:'

      @label '| Scripts:'

      @span class: 'heading-status icon-gear', outlet: '', click: ''
      @label 'Build'
      @span class: 'heading-status icon-code', outlet: '', click: ''
      @label ' File'
      @span class: 'heading-status icon-file-code', outlet: '', click: ''
      @label ' Compile'
      @span
      @label '| Server'
      @span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: ''
      @label 'Run:'
      @span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: ''
      @label 'Stop:'
      @span class: 'heading-status icon-sync', outlet: 'icon_restart', click: ''
      @label 'Reload:'
      @span class: 'heading-status icon-browser', outlet: 'icon_restart', click: ''
      @label 'Browser:'
      @span class: "heading-close icon-remove-close pull-right", click: 'close'
      @span class: "heading-close icon-jump-up pull-right", outlet: 'icon_togglemenu', click: 'togglemainmenu'

  initialize: (@runOptions) ->
    #console.log "init toolbar"
    #@ansiFilter = new AnsiFilter
    @title.text  'Turbulenz ToolBar'
    #@setStatus 'stop'
    # Bind commands
    atom.workspaceView.command 'turbulenz-utility-a:toggletoolbar', => @ToggleView()
    atom.workspaceView.command 'turbulenz-utility-a:hidetoolbar', => @ToggleView 'hide'
    atom.workspaceView.command 'turbulenz-utility-a:showtoolbar', => @ToggleView 'show'
    #@ToggleView 'hide'
  #check if main menu toolbar is displayable.
  togglemainmenu:->
    check = atom.config.get "core.autoHideMenuBar"
    #console.log check
    @icon_togglemenu.removeClass 'icon-jump-up icon-jump-down'

    switch check
      when false then @icon_togglemenu.addClass 'icon-jump-down'
      when true then @icon_togglemenu.addClass 'icon-jump-up'

    switch check
      when false then atom.config.set("core.autoHideMenuBar", true)
      when true then atom.config.set("core.autoHideMenuBar", false)
      else atom.config.set("core.autoHideMenuBar", true)

  toggleconsole:->
    atom.workspaceView.trigger 'turbulenz-utility-a:toggle-console'
  #toggleview
  ToggleView: (command) ->
    console.log 'show?' + command
    switch command
      when 'show' then this.show()
      when 'hide' then this.hide()
      else this.toggle()
  #hide view
  close: ->
    this.hide()
  #display status icon
  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'
