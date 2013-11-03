angular.module("pdifferenceApp").directive "viewport", ($injector) ->
	$window = $injector.get "$window"
	scope: true
	restrict: "A"
	controller: ($scope) ->
		$scope.viewport =
			left: 0
			top: 0
			width: 0
			height: 0
	link: (scope, element, attrs) ->

		scope.adjustViewPort = ->
			shots = scope.activeGroup.shots.concat scope.activeGroup.differences
			maxHeight = if shots.length is 0 then 0 else _(shots).pluck("height").max().value()
			maxWidth = if shots.length is 0 then 0 else _(shots).pluck("width").max().value()
			scope.viewport.left = maxWidth / 2
			scope.viewport.top = maxHeight / 2
			scope.viewport.height = maxHeight * scope.zoom.level + (scope.viewport.top * 2)
			scope.viewport.width = maxWidth * scope.zoom.level + (scope.viewport.left * 2)
			element.css
					height: "#{scope.viewport.height}px"
					width: "#{scope.viewport.width}px"


		scope.$watch "zoom.level", scope.adjustViewPort
