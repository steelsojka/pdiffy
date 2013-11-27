angular.module("pdifferenceApp").factory "Socket", (Shot, $document) ->

  bind = angular.bind

  class Socket
    constructor: (@session) ->
      @connected = false
      @io = io.connect "http://localhost"

      @io.on "send:onConnect", bind(this, @onConnect)
      # @io.on "data:chunk", bind(this, @onDataChunk)
      # @io.on "data:end", bind(this, @onDataEnd)

    onConnect: (event) ->
      @connected = true
      console.log event.message

    emit: (event, data) -> @io.emit event, data

    captureScreen: (shotData, callback) ->
      buffers = ""
      url = shotData.url
      @takingShot = true
      
      onEnd = (data) =>
        @io.removeListener 'data:end', onEnd
        @session.addShot new Shot
          displayURL: url
          path: data.data
          width: shotData.shotWidth
          height: shotData.shotHeight
        callback()
       
      @io.emit "send:takeShot", shotData
      @io.on "data:end", onEnd

    getConfig: (callback) ->
      onConfigRecieve = (config) =>
        callback config
        @io.removeListener "data:config"

      @io.on "data:config", onConfigRecieve
      @io.emit "send:getConfig"

    saveConfig: (config) -> @io.emit "send:saveConfig", config
