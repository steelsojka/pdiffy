angular.module("pdifferenceApp").controller "uploaderCtrl", ($scope, Shot) ->

  $scope.uploadedFiles = []
  $scope.imageUrls = []

  $scope.onFileSelect = (files) ->
    $scope.uploadedFiles.push file for file in files
  
  uploadImage = (file) ->
    reader = new FileReader()
    alertId = $scope.addAlert
      loading: true
      msg: "Loading image #{file.name}"

    reader.onload = (e) ->
      $scope.removeAlert alertId
      addScreenShot e.target.result, file, 'upload'
      $scope.$apply()

    reader.readAsDataURL file

  uploadUrl = (url) -> addScreenShot url, {name: url}, 'link'

  addScreenShot = (data, file, type) ->
    shot = new Shot {type: type}
    shot.displayURL = file.name
    shot.screen.path =  data

    $scope.activeSession.shots.push shot
    $scope.activeSession.setCurrentShot shot
    $scope.uploader.hide()

  $scope.addUrl = ->
    if $scope.imageUrl.length > 0
      $scope.imageUrls.push $scope.imageUrl
      $scope.imageUrl = ''
  
  $scope.upload = ->
    uploadImage image for image in $scope.uploadedFiles
    uploadUrl url for url in $scope.imageUrls
    return

  $scope.$watch "uploader.open", (value) ->
    if value is true
      $scope.uploadedFiles = []
      $scope.imageUrls = []

  return

