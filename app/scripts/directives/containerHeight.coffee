angular.module("pdifferenceApp").directive "containerHeight", ->
	(scope, element, attrs) ->

		calculate = (value) ->
			heights = _.map element.find(attrs.containerHeight), (el) -> angular.element(el).height()
			maxHeight = Math.max.apply Math, heights
			element.height(maxHeight * value * 2)

		scope.$watch("zoom.level", calculate, true)
