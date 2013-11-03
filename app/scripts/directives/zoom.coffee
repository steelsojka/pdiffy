angular.module("pdifferenceApp").directive "zoom", ->
	restrict: "A"
	link: (scope, element, attrs) ->
		scope.applyZoom = (value=scope.zoom.level)->
			element.css
				"-webkit-transform": "scale(#{value})"
				"-webkit-transform-origin": "0 0"

		scope.$watch attrs.zoom, scope.applyZoom
		return
