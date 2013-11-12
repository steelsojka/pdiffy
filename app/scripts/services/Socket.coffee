angular.module("pdifferenceApp").factory "Socket", ->

  bind = angular.bind

  class Socket
    constructor: (@session) ->
      @connected = false
      @io = io.connect "http://localhost"

      @io.on "send:onConnect", bind(this, @onConnect)
      @io.on "data:chunk", bind(this, @onChunk)

    onConnect: (event) ->
      @connected = true
      console.log event.message

    emit: (event, data) -> @io.emit event, data
     
    onChunk: (data) -> console.log data.data
      






