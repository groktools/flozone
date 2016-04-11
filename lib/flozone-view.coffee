module.exports =
class FlozoneView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('flozone')
    @addSpan 'FloZone'
    @addSpan 'I am...'
    @taskname = @addTextBox 'building awesomeness!'
    @startResumeButton = @addButton 'Start', @handleStartResume, false
    @rewindButton = @addButton 'WWID?' , @handleRewind, false
    @stopButton = @addButton 'Stop' , @handleStop, false
    @state = 'not-started'
    console.log "initial state: #{@state}"

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  addSpan: (txt)->
    span = document.createElement('span')
    # span.classList.add('flozone-span')
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
    button = document.createElement('input')
    button.type = 'button'
    button.value = cmd
    button.disabled = !enabled
    # thanks to http://stackoverflow.com/a/33702174
    button.onclick = handler.bind(@)
    button.classList.add('btn')
    button.classList.add('btn-default')
    button.classList.add('tool-bar-btn')
    button.classList.add('fa-'+cmd)
    @element.appendChild(button)
    button

  # start --> pause --> resume --> stop
  handleStartResume: ->
    # console.log "start/resume called at state: #{@state}"
    switch @state
      when 'not-started'
        @state = 'started'
        @startResumeButton.value = "Pause"
        @stopButton.disabled = false
        # console.log @startResumeButton
      when 'started'
        @state = 'paused'
        @startResumeButton.value = "Resume"
      when 'paused'
        @state = 'resumed'
        @startResumeButton.value = "Pause"
        @rewindButton.disabled = false

  handleRewind: ->
    console.log(@)
    @rewindButton.value = "Undoing..."
    @undoCnt = 0
    #syntax here comes from: http://stackoverflow.com/a/23870034
    @undoFn = setInterval(@doUndo.bind(@), 1000)
    # Todo: this still doesnt work. Editor does not get focus back.
    # editor.focus()

  handleStop: ->
    switch @state
      when 'not-started'
        @stopButton.disabled = false
      when 'started', 'paused','resumed'
        @stopButton.disabled = true

  handleTaskNameChange: ->
    if @taskname.getModel().getText() !=''
      @startResumeButton.disabled = false

  doUndo: ->
    # very useful for debugging 'this'
    # console.log @
    editor = atom.workspace.getActiveTextEditor()
    if @undoCnt < 15
      editor.undo()
      # console.log "u: #{@undoCnt}"
      @undoCnt++
    else
      # console.log "clearing undofn #{@undofn}"
      clearInterval @undoFn
      @undoCnt = 0
      @redoCnt = 0
      # console.log "setting up redofn: #{@undoCnt}, #{@redoCnt}"
      @redoFn = setInterval(@doRedo.bind(@), 1000)

  doRedo: ->
    @rewindButton.value = "Redoing..."
    editor = atom.workspace.getActiveTextEditor()
    if @redoCnt < 15
      editor.redo()
      # console.log "r: #{@redoCnt}"
      @redoCnt++
    else
      # console.log "clearing redofn"
      clearInterval @redoFn
      @redoCnt = 0
      @rewindButton.value = "Rewind"
      setInterval.bind(window)
