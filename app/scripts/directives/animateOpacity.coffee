angular.module("pdifferenceApp").directive "animateOpacity", ($parse) ->
	(scope, element, attrs) ->
		scope.$watch attrs.animateOpacity, (newVal) ->
			if newVal
				time = $parse(attrs.animateTime)(scope)
				element.css "-webkit-animation", "opacityAnim #{time}s infinite"
			else
				element.css "-webkit-animation", "none"

