FlozoneView = require './flozone-view'
{CompositeDisposable} = require 'atom'

module.exports = Flozone =
  flozoneView: null
  toolbar: null
  subscriptions: null

  activate: (state) ->
    @flozoneView = new FlozoneView(state.flozoneViewState)
    @toolbar = atom.workspace.addTopPanel(item: @flozoneView.getElement(), visible: true)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'flozone:toggle': => @toggle()

  deactivate: ->
    @toolbar.destroy()
    @subscriptions.dispose()
    @flozoneView.destroy()

  serialize: ->
    flozoneViewState: @flozoneView.serialize()

  toggle: ->
    console.log 'Flozone was toggled!'

    if @toolbar.isVisible()
      @toolbar.hide()
    else
      @toolbar.show()
