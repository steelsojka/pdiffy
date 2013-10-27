'use strict'

angular.module('pdifferenceApp').controller 'MainCtrl', ($scope, $injector) ->

	$timeout = $injector.get "$timeout"
	$window = $injector.get "$window"
	$document = $injector.get "$document"
	$rootScope = $injector.get "$rootScope"

	$scope.dock = 
		position: "left"
		pinned: true
		hidden: false

	$scope.alerts = []

	$scope.getAlertById = (id) ->
		_.find $scope.alerts, (alert) ->
			alert._id is id

	$scope.removeAlert = (id) ->
		_.pull $scope.alerts, $scope.getAlertById(id)

	$scope.updateAlertProgress = (id, val) ->
		alert = $scope.getAlertById id
		alert.progressPercent = val if alert

	$scope.addAlert = (alert) ->
		alert._id = _.uniqueId()
		$scope.alerts.push alert
		return alert._id

	$scope.broadcast = (event) ->
		$rootScope.$broadcast.apply this, arguments

	$scope.onPageChange = (e) ->
		$scope.activeGroup = @group
		$scope.activeGroup.currentTab = $scope.activeGroup.shots[0]
		$scope.$broadcast "centerElements"

	$scope.onScrollTop = -> $window.scrollTo 0,0

	$scope.onScrollBottom = -> 
		$window.scrollTo 0, $document.body.scrollHeight
	
	$scope.$on "groupTabChange", (e, shotURL) -> $scope.tabURL = shotURL

	$scope.files = []
	$scope.activeGroup = null

	return
