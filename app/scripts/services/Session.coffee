angular.module("pdifferenceApp").factory "Session", ($injector) ->

  Viewport = $injector.get "Viewport"
  Toolbelt = $injector.get "Toolbelt"
  Socket = $injector.get "Socket"
  $document = $injector.get "$document"

  exportProps = ['id', 'name']

  class Session
    constructor: (options) ->
      @shots = []
      @source = null
      @id = _.uniqueId()
      @currentTab = null
      @currentShot = null
      @name = "Session #{@id}"
      @viewport = new Viewport this
      @toolbelt = new Toolbelt this
      @socket = new Socket this

      angular.extend this, options

    export: ->
      file = _.pick this, exportProps
      file.shots = []
      file.shots.push shot.export() for shot in @shots
      url = "data:application/json;charset=utf8,#{JSON.stringify file}"
      link = $document[0].createElement 'a'
      link.href = url
      link.download = "#{@name}.pdiffy"
      click = $document[0].createEvent "Event"
      click.initEvent "click", true, true
      link.dispatchEvent click

    addShot: (shot) -> @shots.push shot
    setName: (name) -> @name = name
    removeShot: (shot) ->
      array = null
      if _.contains @shots, shot
        array = @shots
      else if _.contains @differences, shot
        array = @differences

      return if array is null

      index = array.indexOf shot
      isLast = index is array.length - 1
      otherArray = if array is @shots then @differences else @shots

      _.pull array, shot

      if array.length > 0
        nextShot = if isLast then array[index - 1] else array[index]
        @setCurrentShot nextShot
      else if otherArray > 0
        @setCurrentShot otherArray[otherArray.length - 1]
      else
        @currentShot = null

      @viewport.adjust()
    addDifference: (diff) -> @differences.push diff
    getShotById: (id) -> _.find @shots, (shot) -> shot.id is id
    getDifferenceById: (id) -> _.find @differences, (shot) -> shot.id is id
    getMaxHeight: -> if @shots.length is 0 then 0 else _(@shots).pluck("height").max().value()
    getMaxWidth: -> if @shots.length is 0 then 0 else _(@shots).pluck("width").max().value()
    setCurrentShot: (shot) ->
      @currentTab = shot.id
      @currentShot = shot
    moveToShot: (index) ->
      return if @currentShot is null
      shotArray = @getActiveSet()
      @setCurrentShot shotArray[index] if shotArray.length > index >= 0
    getActiveSet: ->
      return if @currentShot is null
      if _.contains @differences, @currentShot then @differences else @shots
    getActiveSetIndex: ->
      set = @getActiveSet()
      return if not angular.isArray set
      set.indexOf @currentShot


  return Session
