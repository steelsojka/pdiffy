'use strict'

angular.module('pdifferenceApp').controller 'MainCtrl', ($scope, $injector) ->

	$timeout = $injector.get "$timeout"
	$window = $injector.get "$window"
	$document = $injector.get "$document"
	$rootScope = $injector.get "$rootScope"
	Group = $injector.get "Group"

	$scope.dock =
		position: "left"
		pinned: true
		hidden: false

	$scope.uploader =
		open: false
		options:
			backdropFade: true
			dialogFade: true
			keyboard: true
		showError: false
		error: ""

	$scope.diffModal =
		open: false
		options:
			backdropFade: true
			dialogFade: true
			keyboard: true
		showError: false
		error: ""

	$scope.zoom =
		level: 1
		increase: (amount=0.1) -> @level += amount
		decrease: (amount=0.1) -> @level -= amount
		reset: -> @level = 1

	$scope.alerts = []

	$scope.getAlertById = (id) ->
		_.find $scope.alerts, (alert) -> alert._id is id

	$scope.removeAlert = (id) -> _.pull $scope.alerts, $scope.getAlertById(id)

	$scope.updateAlertProgress = (id, val) ->
		alert = $scope.getAlertById id
		alert.progressPercent = val if alert

	$scope.addAlert = (alert) ->
		alert._id = _.uniqueId()
		$scope.alerts.push alert
		return alert._id

	$scope.broadcast = (event) -> $rootScope.$broadcast.apply this, arguments

	$scope.onPageChange = (e) ->
		$scope.activeGroup = @group
		$scope.activeGroup.currentTab = $scope.activeGroup.shots[0]
		$scope.$broadcast "centerElements"

	$scope.onScrollTop = -> $window.scrollTo 0,0

	$scope.onScrollBottom = -> $window.scrollTo 0, $document[0].body.scrollHeight
	
	$scope.$on "groupTabChange", (e, shotURL) -> $scope.tabURL = shotURL

	$scope.groups = [new Group()]
	$scope.activeGroup = $scope.groups[0]

	# Heres where we set all our global keyboard shortcuts
	keyBindings =
		"ctrl+=": -> $scope.zoom.increase()
		"ctrl+-": -> $scope.zoom.decrease()
		"ctrl+alt+=": -> $scope.zoom.increase(0.02)
		"ctrl+alt+-": -> $scope.zoom.decrease(0.02)
		"ctrl+shift+d": -> $scope.dock.hidden = not $scope.dock.hidden
		"ctrl+h": -> $scope.activeGroup.currentShot.show = not $scope.activeGroup.currentShot.show
		"ctrl+backspace": -> $scope.activeGroup.removeShot $scope.activeGroup.currentShot
		"ctrl+u": -> $scope.uploader.open = true
		"ctrl+d": -> $scope.diffModal.open = true
		"ctrl+shift+p": -> $scope.dock.pinned = not $scope.dock.pinned

	for own key, fn of keyBindings
		keyBindings[key] = _.wrap fn, (func, e) ->
			e.preventDefault()
			$scope.$apply _.partial(func, e)

	Mousetrap.bind ["ctrl+up", "ctrl+k"], (e) ->
		e.preventDefault()
		$scope.$apply ->
			$scope.activeGroup.moveToShot $scope.activeGroup.getActiveSetIndex() - 1
		return
	Mousetrap.bind ["ctrl+down", "ctrl+j"], (e) -> 
		e.preventDefault()
		$scope.$apply ->
			$scope.activeGroup.moveToShot $scope.activeGroup.getActiveSetIndex() + 1
	Mousetrap.bind keyBindings

	return
