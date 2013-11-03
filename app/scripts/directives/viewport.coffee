angular.module("pdifferenceApp").directive "viewport", ($injector) ->
	$window = $injector.get "$window"
	restrict: "A"
	link: (scope, element, attrs) ->

		scope.adjustViewPort = ->
			shots = scope.activeGroup.shots.concat scope.activeGroup.differences
			maxHeight = if shots.length is 0 then 0 else _(shots).pluck("height").max().value()
			maxWidth = if shots.length is 0 then 0 else _(shots).pluck("width").max().value()
			left = maxWidth * scope.zoom.level / 2
			top = maxHeight * scope.zoom.level / 2
			element.css
				height: "#{maxHeight + (top * 2)}px"
				width: "#{maxWidth + (left * 2)}px"


		scope.$watch "zoom.level", scope.adjustViewPort
