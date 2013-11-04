angular.module("pdifferenceApp").controller "tabControlsCtrl", ($scope, $injector) ->
	
	$rootScope = $injector.get "$rootScope"

	# Move these functions to the shot class
	$scope.onOpacityChange = (id, val) -> $scope.activeSession.currentShot.screenOpacity = val

	$scope.resetPosition = (obj) ->
		obj.x = 0
		obj.y = 0

	$scope.onScreenChange = (id, val) ->
		$rootScope.$broadcast "toggleScreenShot", id, val
		$rootScope.$broadcast "centerElements"
