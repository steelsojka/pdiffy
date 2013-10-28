angular.module("pdifferenceApp").controller "groupCtrl", ($scope) ->

# 	$scope.activeGroup.currentTab = $scope.activeGroup.shots[0].id;

	$scope.setCurrentTab = (shot) ->
		$scope.activeGroup.setCurrentShot shot.id
		$scope.$broadcast "centerElements"
		$scope.$emit "groupTabChange", shot.displayURL
	
	$scope.removeShot = (shot) -> $scope.activeGroup.removeShot shot 

	$scope.removeGeneratedDifference = -> 
		$scope.activeGroup.removeDifference @shot

		if $scope.activeGroup.generatedDifferences.length < 1
			$scope.setCurrentTab $scope.activeGroup.shots[0]

	return
