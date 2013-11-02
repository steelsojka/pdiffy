angular.module("pdifferenceApp").directive "zoom", ->
	restrict: "A"
	link: (scope, element, attrs) ->
		scope.applyZoom = (value=scope.zoom.level)->
			element.css
				"-webkit-transform": "scale(#{value})"

		scope.$watch attrs.zoom, scope.applyZoom
		return
