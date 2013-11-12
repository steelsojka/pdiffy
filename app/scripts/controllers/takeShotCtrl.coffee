angular.module("pdifferenceApp").controller "takeShotCtrl", ($scope) ->
  $scope.urls = []

  $scope.takeShot = ->
    $scope.activeSession.socket.emit "send:takeShot", $scope.url
