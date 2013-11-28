angular.module("pdifferenceApp").factory "Session", ($injector) ->

  Viewport = $injector.get "Viewport"
  Toolbelt = $injector.get "Toolbelt"
  Socket = $injector.get "Socket"
  $document = $injector.get "$document"

  exportProps = ['id', 'name']

  # Session is a global class
  class AppSession extends Session
    constructor: (options) ->
      Session.call this, options
      @viewport = new Viewport this
      @toolbelt = new Toolbelt this
      @socket = new Socket this

    export: ->
      file = super
      url = "data:application/json;charset=utf8,#{file}"
      link = $document[0].createElement 'a'
      link.href = url
      link.download = "#{@name}.pdiffy"
      click = $document[0].createEvent "Event"
      click.initEvent "click", true, true
      link.dispatchEvent click

    removeShot: (shot) ->
      super shot
      @viewport.adjust()


  return AppSession
