angular.module("pdifferenceApp").directive "center", ($injector) ->

	$window = $injector.get "$window"
	$timeout = $injector.get "$timeout"

	(scope, element, attrs) ->
		adjust = ->
			element.css
				left: "#{scope.viewport.left}px"
				top: "#{scope.viewport.top + 41}px" # account for the navbar

		scope.centerElement = -> $timeout adjust, 0

		scope.$on "centerElements", scope.centerElement

		angular.element($window).bind "resize", _.throttle(adjust, 50)

		scope.$watch "zoom.level", adjust
		scope.$watch "activeGroup.shots.length", adjust
		scope.$watch "activeGroup.differences.length", adjust

		return
