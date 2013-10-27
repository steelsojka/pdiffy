angular.module("pdifferenceApp").filter "percent", ->
	(input) ->
		(Math.round(parseFLoat(input, 10) * 10000) / 100) + "%"
