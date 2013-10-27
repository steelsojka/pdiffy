angular.module("pdifferenceApp").directive "slider", ($parse) ->
	(scope, element, attrs) ->
		fn = $parse attrs.slider
		element.bind "change", (e) ->
			scope.$apply ->
				fn scope, {$event: e, $value: parseFloat(e.target.value, 10)}
