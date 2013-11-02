angular.module("pdifferenceApp").controller "uploaderCtrl", ($scope, Shot) ->

	forEach = angular.forEach

	$scope.uploadedFiles = []
	$scope.open = false
	$scope.options =
		backdropFade: true
		dialogFade: true
		keyboard: true

	$scope.showError = false
	$scope.error = ""

	$scope.onFileSelect = (files) ->
		$scope.uploadedFiles.push file for file in files
	
	uploadImage = (file) ->
		reader = new FileReader()
		alertId = $scope.addAlert
			loading: true
			msg: "Loading image #{file.name}"

		reader.onload = (e) ->
			$scope.removeAlert alertId
			addScreenShot e.target.result, file
			$scope.$apply()

		$scope.open = false
		reader.readAsDataURL file

	addScreenShot = (data, file) ->
		shot = new Shot()
		shot.displayURL = file.name
		shot.screen.path =  data

		$scope.activeGroup.shots.push shot
		$scope.activeGroup.setCurrentShot shot.id
	
	$scope.upload = -> forEach $scope.uploadedFiles, uploadImage

	$scope.$on "openUploadModal", ->
		$scope.open = true
		$scope.uploadedFiles = []

	return

