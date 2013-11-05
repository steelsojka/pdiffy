angular.module("pdifferenceApp").factory "Toolbelt", ->

	class Toolbelt
		constructor: (@session) ->
			@active = "move"

	return Toolbelt
			
