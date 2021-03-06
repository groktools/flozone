{CompositeDisposable} = require 'atom'

module.exports =
class FlozoneView
  maxReplay:null
  subscriptions: null
  cmdMap: null

  constructor: (serializedState) ->
    @cmdMap =
      'Start': 'play'
      'Pause':'pause'
      'Resume': 'play'
      'Replay': 'undo'
      'Stop': 'stop'
    @icon = 'space-shuttle'

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('flozone')
    @addLogo()
    @addSpan 'I am...'
    @taskname = @addTextBox 'building awesomeness!'
    @startResumeButton = @addButton 'Start', @handleStartResume, false
    @stopButton = @addButton 'Stop' , @handleStop, false
    @replayButton = @addButton 'Replay' , @handleReplay, false
    @state = 'not-started'
    # console.log "initial state: #{@state}"

    @maxReplay = atom.config.get 'flozone.maxReplay'
    @speed = atom.config.get 'flozone.speed'

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.config.observe 'flozone.maxReplay', (newValue) =>
      @maxReplay = newValue
    # console.log "rw:#{maxReplay}, spd: #{@speed}"
    @subscriptions.add atom.config.observe 'flozone.speed', (newValue)=>
      @speed = newValue

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @subscriptions.dispose()
    @element.remove()

  getElement: ->
    @element

  addLogo: ->
    logo = document.createElement('i')
    logo.classList.add('logo')
    logo.classList.add('fa')
    logo.classList.add('fa-' + @icon)
    @element.appendChild(logo)

  addSpan: (txt,icon)->
    span = document.createElement('span')
    span.classList.add('label')
    span.textContent = txt
    @element.appendChild span

  addTextBox: (defmsg) ->
    tb = document.createElement('atom-text-editor')
    tb.setAttribute 'mini', true
    tb.className = 'editor taskname'
    tb.getModel().placeholderText = defmsg
    tb.getModel().onDidStopChanging (@handleTaskNameChange.bind(@))
    @element.appendChild(tb)
    tb

  addButton: (cmd, handler, enabled) ->
    button = document.createElement('span')
    # button.type = 'button'
    button.textContent = cmd
    button.disabled = !enabled
    # thanks to http://stackoverflow.com/a/33702174
    button.onclick = handler.bind(@)
    button.classList.add('btn')
    button.classList.add('btn-default')
    button.classList.add('tool-bar-btn')
    button.classList.add('fa')
    button.classList.add('fa-'+@cmdMap[cmd])
    button.dataset.currentIcon = 'fa-'+@cmdMap[cmd]
    @disableButton button
    @element.appendChild(button)
    button
  #                             /-------------_\
  #                            V               |
  # not started -> start --> pause --> resume -|--> stop
  #                 \----------|--------------------/
  handleStartResume: ->
    # console.log "start/resume called at state: #{@state}"
    switch @state
      when 'not-started'
        @state = 'started'
        @startResumeButton.textContent = "Pause"
        @switchIcons @startResumeButton, 'Pause'
        @enableButton @stopButton
        # console.log @startResumeButton
      when 'started','resumed'
        @state = 'paused'
        @startResumeButton.textContent = "Resume"
        @switchIcons @startResumeButton,'Resume'
      when 'paused'
        @state = 'resumed'
        @startResumeButton.textContent = "Pause"
        @switchIcons @startResumeButton,'Pause'
        @enableButton @replayButton
    # console.log "start/resume called at state: #{@state}"

  handleReplay: ->
    # console.log(@)
    @replayButton.textContent = "Undoing..."

    @undoCnt = 0
    #syntax here comes from: http://stackoverflow.com/a/23870034
    @undoFn = setInterval(@doUndo.bind(@), @speed)
    # Todo: this still doesnt work. Editor does not get focus back.
    editor.focus()

  handleStop: ->
    # console.log "stop called at state: #{@state}"
    switch @state
      when 'not-started'
        @enableButton @stopButton
      when 'started','resumed','paused'
        @state = 'not-started'
        @disableButton @stopButton
        @switchIcons @startResumeButton, 'Start'
        @startResumeButton.textContent = 'Start'
        @taskname.getModel().setText('')

  handleTaskNameChange: ->
    # console.log 'handleTaskNameChange called'
    if @taskname.getModel().getText() !=''
      # @startResumeButton.disabled = false
      @enableButton @startResumeButton
      # @startResumeButton.focus()
    else
      @disableButton @startResumeButton

  doUndo: ->
    # very useful for debugging 'this'
    # console.log @maxReplay
    editor = atom.workspace.getActiveTextEditor()
    if @undoCnt < @maxReplay
      editor.undo()
      console.log "u: #{@undoCnt}"
      @undoCnt++
    else
      # console.log "clearing undofn #{@undofn}"
      clearInterval @undoFn
      @undoCnt = 0
      @redoCnt = 0
      # console.log "setting up redofn: #{@undoCnt}, #{@redoCnt}"
      @redoFn = setInterval(@doRedo.bind(@), @speed)

  doRedo: ->
    @replayButton.textContent = "Redoing..."
    editor = atom.workspace.getActiveTextEditor()
    if @redoCnt < @maxReplay
      editor.redo()
      # console.log "r: #{@redoCnt}"
      @redoCnt++
    else
      # console.log "clearing redofn"
      clearInterval @redoFn
      @redoCnt = 0
      @replayButton.textContent = "Replay"
      setInterval.bind(window)

  enableButton: (button)->
    button.classList.remove 'disabled'
    button.classList.add 'enabled'

  disableButton: (button)->
    button.classList.remove 'enabled'
    button.classList.add 'disabled'

  switchIcons: (button,to)->
    # console.log "current icon: #{button.dataset.currentIcon}, #{to}"
    button.classList.remove(button.dataset.currentIcon)
    newIcon = 'fa-'+@cmdMap[to]
    button.classList.add(newIcon)
    button.dataset.currentIcon = newIcon
