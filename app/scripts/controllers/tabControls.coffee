angular.module("pdifferenceApp").controller "tabControlsCtrl", ($scope, $injector) ->
	
	$rootScope = $injector.get "$rootScope"

	$scope.onOpacityChange = (id, val) -> $scope.activeGroup.currentShot.screenOpacity = val

	$scope.resetPosition = (obj) -> 
		obj.x = 0
		obj.y = 0

	$scope.onScreenChange = (id, val) ->
		$rootScope.$broadcast "toggleScreenShot", id, val
		$rootScope.$broadcast "centerElements"
