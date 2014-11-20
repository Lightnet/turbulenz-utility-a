###

  Project Name: turbulenz-utility-a package
  Date:2014.11.17
  Created by: Lightnet
  Link: https://github.com/Lightnet/turbulenz-utility-a
  license: MIT

  Check for more information on readme.txt file.

###

AnsiFilter = require 'ansi-to-html'
_ = require 'underscore'
{View,BufferedProcess} = require 'atom'
{$} = require 'space-pen'


module.exports =
class TurbulenzUtilityAConsoleView extends View
  @bufferedProcess: null
  filecompilemode:''
  bhideConsoleLog: false

  @content: ->
    @div =>
      #@div class: 'overlay from-top panel', outlet: 'scriptOptionsView', => #non header
      @div class: 'panel-heading padded heading header-view', => #header
        @span class: 'heading-title', outlet: 'title'
        @span class: 'heading-status', outlet: 'status'
        @span
          class: 'heading-close icon-remove-close pull-right'
          outlet: 'closeButton'
          click: 'close'
        @span
          class: "heading-close icon-jump-down pull-right"
          outlet: 'icon_toggleconsole'
          click: 'toggleoutput'
        # Display layout and outlets
      @div class: 'block', =>
        css = 'tool-panel panel panel-bottom padding script-view
          native-key-bindings'
        @div class: css, outlet: 'script', tabindex: -1, =>
          @div class: 'panel-body padded output', outlet: 'output'

  initialize: (@runOptions) ->
    @ansiFilter = new AnsiFilter
    @title.text  'Turbulenz Console'
    @setStatus 'stop'
    @output.empty()
      # Bind commands
    atom.workspaceView.command 'turbulenz-utility-a:run', => @run()
    #atom.workspaceView.command 'turbulenz-utility-a:run-by-line-number', => @lineRun()
    atom.workspaceView.command 'turbulenz-utility-a:kill-process', => @stop()
    atom.workspaceView.command 'turbulenz-utility-a:msg-console', => @msgconsole()
    atom.workspaceView.command 'turbulenz-utility-a:toggle-console', => @toggleViewOptions()
    atom.workspaceView.command 'turbulenz-utility-a:open-console', => @toggleViewOptions()
    atom.workspaceView.command 'turbulenz-utility-a:close-console', => @toggleViewOptions 'hide'
    atom.workspaceView.command 'turbulenz-utility-a:runserver', => @runServer()
    atom.workspaceView.command 'turbulenz-utility-a:stopserver', => @stopServer()
    atom.workspaceView.command 'turbulenz-utility-a:restartserver', => @restartServer()

    #atom.workspaceView.prependToTop this
    @toggleViewOptions 'hide'

    #console.log $
  toggleoutput: ->
    @icon_toggleconsole.removeClass 'icon-jump-up icon-jump-down'
    console.log "toggle output"
    if @script.isVisible() == true
      @icon_toggleconsole.addClass 'icon-jump-up'
      @script.hide()
    else
      @icon_toggleconsole.addClass 'icon-jump-down'
      @script.show()


  runServer: ->
    console.log "runserver"
    #editor = atom.workspace.getActiveTextEditor()
    #console.log editor.getUri()
    #console.log editor.getTitle()
    console.log @run('tsc','','')
  stopServer: ->
    console.log "stopServer"
  restartServer: ->
    console.log "restartServer"
  msgconsole:->
    console.log "test"
    @output.append "test"
  toggleViewOptions: (command) ->
    #console.log command
    #@CustomScriptBuildsConfigView.hide()
    #console.log command
    if command == 'show'
      @.show()
    else if command == 'hide'
      @.hide()
    else
      #@.toggle()
      if @.isVisible() == true
        @.hide()
      else
        @.show()
    #console.log "toggle console"
    #console.log @.isVisible()
    #console.log @

  close: ->
    atom.workspaceView.trigger 'turbulenz-utility-a:close-console'

  setStatus: (status) ->
    @status.removeClass 'icon-alert icon-check icon-hourglass icon-stop'
    switch status
      when 'start' then @status.addClass 'icon-hourglass'
      when 'stop' then @status.addClass 'icon-check'
      when 'kill' then @status.addClass 'icon-stop'
      when 'err' then @status.addClass 'icon-alert'

  handleError: (err) ->
    # Display error and kill process
    @title.text 'Error'
    @setStatus 'err'
    @output.append err
    #@stop()

  run: (command, extraArgs, codeContext) ->
    atom.emit 'achievement:unlock', msg: 'Homestar Runner'

    stdout = (output) => @display 'stdout', output
    stderr = (output) => @display 'stderr', output

    options =
      cwd: @getCwd()
    #args = ['help']
    #args = ['cd']
    #check scirpt package for atom.
    #args = codeContext.shebangCommandArgs().concat args
    args = ''

    editor = atom.workspace.getActiveTextEditor()
    console.log editor.getUri()
    console.log editor.getTitle()
    args = [editor.getTitle()]

    exit = (returnCode) =>
      if returnCode is 0
        @setStatus 'stop'
        console.log 'stop'
      else
        @setStatus 'err'
      console.log "Exited with #{returnCode}"

    # Run process
    @bufferedProcess = new BufferedProcess({
      command, args, options, stdout, stderr, exit
    })

    @toggleViewOptions 'show'
    console.log @bufferedProcess

    @bufferedProcess.process.on 'error', (nodeError) =>
      @output.append $ ->
        @h1 'Unable to run'
        @pre _.escape command
        @h2 'Is it on your path?'
        @pre "PATH: #{_.escape process.env.PATH}"

  getCwd: ->
    #if not @runOptions.workingDirectory? or @runOptions.workingDirectory is ''
      #atom.project.getPath()
    #else
      #@runOptions.workingDirectory
    atom.project.getPath()

  stop: ->
    # Kill existing process if available
    if @bufferedProcess? and @bufferedProcess.process?
      @display 'stdout', '^C'
      @headerView.setStatus 'kill'
      @bufferedProcess.kill()

  display: (css, line) ->
    console.log line
    line = _.escape(line)
    line = @ansiFilter.toHtml(line)

    @output.append $ ->
      @pre class: "line #{css}", =>
        @raw line

  defaultRun: ->
    #@resetView()
    #codeContext = @buildCodeContext() # Until proven otherwise
    #@start(codeContext) unless not codeContext?

  resetView: (title = 'Loading...') ->
    # Display window and load message
    # First run, create view
    atom.workspaceView.prependToBottom this unless @hasParent()
    # Close any existing process and start a new one
    @stop()
    @title.text title
    @setStatus 'start'
    # Get script view ready
    @output.empty()

  close: ->
    # Stop any running process and dismiss window
    @stop()
    @detach() if @hasParent()
