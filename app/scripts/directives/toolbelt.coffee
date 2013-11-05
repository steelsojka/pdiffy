angular.module("pdifferenceApp").directive "toolbelt", ($window) ->
	restrict: "A"
	link: (scope, element, attrs) ->
		mousedown = false
		startX = 0
		startY = 0
		windowX = 0
		windowY = 0
		
		scope.$watch "activeSession.toolbelt.active", (value) -> element.attr "tool", value

		element.on "mousedown", (e) ->
			mousedown = true
			startX = e.clientX
			startY = e.clientY
			windowX = $window.pageXOffset
			windowY = $window.pageYOffset

		element.on "mouseup", -> mousedown = false

		element.on "mousemove", (e) ->
			return if not mousedown
			movedX = startX - e.clientX
			movedY = startY - e.clientY

			switch scope.activeSession.toolbelt.active
				when 'move'
					scope.activeSession.viewport.setPosition windowX + movedX, windowY + movedY
			return
