'use strict'

angular.module('pdifferenceApp').controller 'MainCtrl', ($scope, $injector) ->

	$timeout = $injector.get "$timeout"
	$window = $injector.get "$window"
	$document = $injector.get "$document"
	$rootScope = $injector.get "$rootScope"
	Session = $injector.get "Session"
	Modal = $injector.get "Modal"

	$scope.dock =
		position: "left"
		pinned: true
		hidden: false

	$scope.uploader = new Modal()
	$scope.diffModal = new Modal()
	$scope.groupModal = new Modal()

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
		$scope.activeSession = @group
		$scope.activeSession.currentTab = $scope.activeSession.shots[0]
		$scope.$broadcast "centerElements"

	$scope.onScrollTop = -> $window.scrollTo 0,0

	$scope.onScrollBottom = -> $window.scrollTo 0, $document[0].body.scrollHeight

	$scope.sessions = [new Session()]
	$scope.activeSession = $scope.sessions[0]

	# Heres where we set all our global keyboard shortcuts
	keyBindings =
		"ctrl+=": -> $scope.activeSession.viewport.zoom.increase()
		"ctrl+-": -> $scope.activeSession.viewport.zoom.decrease()
		"ctrl+alt+=": -> $scope.activeSession.viewport.zoom.increase(0.02)
		"ctrl+alt+-": -> $scope.activeSession.viewport.zoom.decrease(0.02)
		"ctrl+shift+d": -> $scope.dock.hidden = not $scope.dock.hidden
		"ctrl+h": -> $scope.activeSession.currentShot.show = not $scope.activeSession.currentShot.show
		"ctrl+backspace": -> $scope.activeSession.removeShot $scope.activeSession.currentShot
		"ctrl+u": -> $scope.uploader.show()
		"ctrl+d": -> $scope.diffModal.show()
		"ctrl+f": -> $scope.activeSession.viewport.center()
		"ctrl+shift+p": -> $scope.dock.pinned = not $scope.dock.pinned

	for own key, fn of keyBindings
		keyBindings[key] = _.wrap fn, (func, e) ->
			e.preventDefault()
			$scope.$apply _.partial(func, e)

	Mousetrap.bind ["ctrl+up", "ctrl+k"], (e) ->
		e.preventDefault()
		$scope.$apply ->
			$scope.activeSession.moveToShot $scope.activeSession.getActiveSetIndex() - 1
		return
	Mousetrap.bind ["ctrl+down", "ctrl+j"], (e) -> 
		e.preventDefault()
		$scope.$apply ->
			$scope.activeSession.moveToShot $scope.activeSession.getActiveSetIndex() + 1
	Mousetrap.bind keyBindings

	return
