angular.module("pdifferenceApp").controller "sessionCtrl", ($scope) ->

# 	$scope.activeSession.currentTab = $scope.activeSession.shots[0].id;

	$scope.setCurrentTab = (shot) ->
		$scope.activeSession.setCurrentShot shot.id
		$scope.$broadcast "centerElements"
		$scope.$emit "sessionChange", shot.displayURL
	
	$scope.removeShot = (shot) -> $scope.activeSession.removeShot shot

	$scope.removeGeneratedDifference = ->
		$scope.activeSession.removeDifference @shot

		if $scope.activeSession.differences.length < 1
			$scope.setCurrentTab $scope.activeSession.shots[0]

	return
