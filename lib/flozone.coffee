FlozoneView = require './flozone-view'
{CompositeDisposable} = require 'atom'

module.exports = Flozone =
  flozoneView: null
  toolbar: null
  subscriptions: null

  config:
    maxRewind:
      type:'integer'
      default:15
      description: "Maximum actions to rewind/replay"
    speed:
      type:'integer'
      default: 1000
      minimum:100
      maximum:1000
      description: "Speed of rewind/replay in milliseconds. Fast=100, Slow=1000. These are also the limits"

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
