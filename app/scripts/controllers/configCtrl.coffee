angular.module("pdifferenceApp").controller "configCtrl", ($scope) ->
  $scope.config = {}
  $scope.activeSession.socket.getConfig (config) ->
    $scope.config = JSON.parse config
    $scope.$apply()

  $scope.saveConfig = ->
    $scope.activeSession.socket.saveConfig $scope.config
