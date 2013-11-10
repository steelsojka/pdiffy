angular.module("pdifferenceApp").factory "Socket", ->

  bind = angular.bind

  class Socket
    constructor: (@session) ->
      @connected = false
      @io = io.connect "http://localhost"

      @io.on "send:onConnect", bind(this, @onConnect)

    onConnect: (event) ->
      @connected = true
      console.log event.message
      
      






