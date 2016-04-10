module.exports =
class FlozoneView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('flozone')
    @addSpan 'FloZone'
    @addSpan 'I am...'
    @addTextBox 'building awesomeness!'
    @startResumeButton = @addButton 'start', @handleStartResume
    @rewindButton = @addButton 'undo' , @handleRewind
    @stopButton = @addButton 'stop' , @handleStop
    @started = false

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
    @element.appendChild(tb)

  addButton: (cmd, handler) ->
    button = document.createElement('input')
    button.type = 'button'
    button.value = cmd
    button.onclick = handler
    button.classList.add('btn')
    button.classList.add('btn-default')
    button.classList.add('tool-bar-btn')
    button.classList.add('fa-'+cmd)
    @element.appendChild(button)
    button

  handleStartResume: ->
    console.log "start/resume called"
    # if !@started
    #   @started = true
    #
    # else
  handleRewind: ->
    console.log "rewind called"
  handleStop: ->
    console.log "stop"
