{WorkspaceView} = require 'atom'
TurbulenzUtilityA = require '../lib/turbulenz-utility-a'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TurbulenzUtilityA", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('turbulenz-utility-a')

  describe "when the turbulenz-utility-a:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.turbulenz-utility-a')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch atom.workspaceView.element, 'turbulenz-utility-a:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.turbulenz-utility-a')).toExist()
        atom.commands.dispatch atom.workspaceView.element, 'turbulenz-utility-a:toggle'
        expect(atom.workspaceView.find('.turbulenz-utility-a')).not.toExist()
