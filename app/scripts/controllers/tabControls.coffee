angular.module("pdifferenceApp").controller "tabControlsCtrl", ($scope, $injector) ->
	
	$rootScope = $injector.get "$rootScope"

	$scope.onOpacityChange = (id, val) -> $scope.shot.screenOpacity = val
	$scope.onDiffOpacityChange = (id, val) -> $scope.shot.differenceOpacity = val

	$scope.resetPosition = (obj) -> 
		obj.x = 0
		obj.y = 0

	$scope.onScreenChange = (id, val) ->
		$rootScope.$broadcast "toggleScreenShot", id, val
		$rootScope.$broadcast "centerElements"
