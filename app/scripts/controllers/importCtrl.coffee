angular.module('pdifferenceApp').controller 'importCtrl', ($scope, $injector) ->

  Session = $injector.get "Session"
  Shot = $injector.get "Shot"

  $scope.import = (files) ->
    $scope.importer.hide()
    file = files[0]
    reader = new FileReader()
    alertId = $scope.addAlert
      loading: true
      msg: "Importing session #{file.name}"

    reader.onload = (e) ->
      $scope.removeAlert alertId
      parseSession e.target.result

    reader.readAsText file

  parseSession = (session) ->
    session = JSON.parse session
    session.shots = _.map session.shots, (shot) -> 
      shot.id = _.uniqueId() 
      new Shot shot
    $scope.sessions.push new Session(session)
    $scope.setActiveSession $scope.sessions[$scope.sessions.length - 1]
    $scope.$apply()

  return


