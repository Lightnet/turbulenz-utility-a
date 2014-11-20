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
  #@bufferedProcess: null

  @content: ->
    #css = 'btn inline-block-tight'
    css = 'btn inline-block-tight'
    @div class: 'panel-heading padded heading header-view', => #header
      @span class: 'heading-status icon-terminal', outlet: 'icon_terimal', click: 'toggleconsole'
      @span class: 'heading-title', outlet: 'title'
      @span class: 'heading-status', outlet: 'status'
      @span

      @span class: 'heading-status icon-file-binary', outlet: 'icon_playbackplay', click: ''
      @label 'Assets:'

      @label '| Scripts:'

      @span class: 'heading-status icon-gear', outlet: '', click: ''
      @button class: "btn #{css}", click: 'trigger_maincompile', 'Main'
      @label 'Build'
      @span class: 'heading-status icon-code', outlet: '', click: ''
      @button class: "btn #{css}", click: 'trigger_filecompile', 'File'
      @label ' File'
      @span class: 'heading-status icon-file-code', outlet: '', click: ''
      @label ' Compile'

      @span
      @label '| Server'
      @span class: 'heading-status icon-playback-play', outlet: 'icon_playbackplay', click: 'trigger_runserver'
      @label 'Run'
      @span class: 'heading-status icon-primitive-square', outlet: 'icon_stop', click: 'trigger_stopserver'
      @label 'Stop'
      @span class: 'heading-status icon-sync', outlet: 'icon_restart', click: 'trigger_restartserver'
      @label 'Reload'
      @span class: 'heading-status icon-browser', outlet: 'icon_restart', click: 'trigger_browserserver'
      @label 'Browser'
      @span class: "heading-close icon-remove-close pull-right", click: 'close'
      #Atom menu toolbar
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

  trigger_maincompile:->
    atom.workspaceView.trigger 'turbulenz-utility-a:main_compile'

  trigger_filecompile:->
    atom.workspaceView.trigger 'turbulenz-utility-a:file_compile'

  trigger_runserver:->
    atom.workspaceView.trigger 'turbulenz-utility-a:runserver'

  trigger_stopserver:->
    atom.workspaceView.trigger 'turbulenz-utility-a:stopserver'

  trigger_restartserver:->
    atom.workspaceView.trigger 'turbulenz-utility-a:restartserver'

  trigger_browserserver:->
    #atom.workspaceView.trigger 'turbulenz-utility-a:browserserver'
    BrowserWindow = require('remote').require 'browser-window'
    mainWindow = new BrowserWindow({width: 800, height: 600, frame: true });
    mainWindow.loadUrl('https://github.com/Lightnet/turbulenz-utility-a')
    mainWindow.show()


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
