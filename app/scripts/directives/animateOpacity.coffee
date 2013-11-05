angular.module("pdifferenceApp").directive "animateOpacity", ($parse) ->
	(scope, element, attrs) ->
		fn = $parse(attrs.animateTime)
		scope.$watch attrs.animateOpacity, (newVal) ->
			if newVal
				time = fn scope
				element.css "-webkit-animation", "opacityAnim #{time}s linear infinite"
			else
				element.css "-webkit-animation", "none"

