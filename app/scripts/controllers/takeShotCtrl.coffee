angular.module("pdifferenceApp").controller "takeShotCtrl", ($scope) ->
  $scope.urls = []
  $scope.shot =
    url: ""
    width: 1024
    height: 768

  $scope.takeShot = ->
    $scope.activeSession.socket.captureScreen $scope.shot, -> $scope.$apply()
