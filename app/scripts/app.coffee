'use strict'

angular.module('pdifference', [
	'ngResource',
	'ui.bootstrap'
]).config ($routeProvider) ->
	$routeProvider
		.when('/', {
			templateUrl: 'views/main.html'
			controller: "MainCtrl"
		})
		.otherwise({
			redirectTo: '/'
		})

