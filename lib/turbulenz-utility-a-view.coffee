###

  Project Name: turbulenz-utility-a package
  Date:2014.11.17
  Created by: Lightnet
  Link: https://github.com/Lightnet/turbulenz-utility-a
  license: MIT

  Check for more information on readme.txt file.

###

TurbulenzUtilityAToolBarView = require './turbulenz-utility-a-toolbar-view'
TurbulenzUtilityAConsoleView = require './turbulenz-utility-a-console-view'

module.exports =
class TurbulenzUtilityAView
  turbulenzutilityaToolBarView: null

  constructor: (serializeState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('turbulenz-utility-a',  'overlay', 'from-top')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The TurbulenzUtilityA package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

    #init view
    #Toolbar
    @turbulenzutilityaToolBarView = new TurbulenzUtilityAToolBarView()
    #atom.workspaceView.append(@turbulenzutilityaToolBarView)
    #atom.workspaceView.appendToTop(@turbulenzutilityaToolBarView)
    atom.workspace.addTopPanel({item:@turbulenzutilityaToolBarView})

    #Console
    @turbulenzutilityaConsoleView = new TurbulenzUtilityAConsoleView()
    atom.workspace.addBottomPanel({item:@turbulenzutilityaConsoleView})

    #atom.workspaceView.appendToBottom(@turbulenzutilityaConsoleView)
    #atom.workspace.addBottomPanel(@turbulenzutilityaConsoleView)

    #console.log

    # Register command that toggles this view
    atom.commands.add 'atom-workspace', 'turbulenz-utility-a:toggle': => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  # Toggle the visibility of this view
  toggle: ->
    console.log 'TurbulenzUtilityAView was toggled!'

    if @element.parentElement?
      @element.remove()
    else
      atom.workspaceView.append(@element)
