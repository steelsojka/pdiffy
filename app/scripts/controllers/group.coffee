angular.module("pdifferenceApp").controller "groupCtrl", ($scope) ->

	$scope.activeGroup.currentTab = $scope.activeGroup.shots[0].id;

	$scope.setCurrentTab = (shot) ->
		$scope.activeGroup.currentTab = shot.id
		$scope.$broadcast "centerElements"
		$scope.$emit "groupTabChange", shot.displayURL
	
	$scope.removeShot = (shot) -> _.pull $scope.activeGroup.shots, shot 

	$scope.removeGeneratedDifference = ->
		_.pull $scope.activeGroup.generatedDifferences, @shot

		if $scope.activeGroup.generatedDifferences.length < 1
			$scope.setCurrentTab $scope.activeGroup.shots[0]

	return
