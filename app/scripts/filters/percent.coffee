angular.module("pdifferenceApp").filter "percent", ->
	(input) ->
		(Math.round(parseFloat(input, 10) * 10000) / 100) + "%"
