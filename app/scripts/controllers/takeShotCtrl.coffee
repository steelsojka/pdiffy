angular.module("pdifferenceApp").controller "takeShotCtrl", ($scope, $window) ->
  $scope.userAgents =
    "Safari - 6.0": "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25"
    "Internet Explorer 10": "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)"
    "Internet Explorer 9": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
    "Internet Explorer 8": "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)"
    "Internet Explorer 7": "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
    "Firefox 7 - Windows": "Mozilla/5.0 (Windows NT 6.1; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"
    "Firefox 7 - Mac": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"
    "Firefox 4 - Windows": "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1"
    "Firefox 4 - Mac": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1"
    "Firefox 14 - Android Mobile": "Mozilla/5.0 (Android; Mobile; rv:14.0) Gecko/14.0 Firefox/14.0"
    "Firefox 14 - Android Tablet": "Mozilla/5.0 (Android; Tablet; rv:14.0) Gecko/14.0 Firefox/14.0"
    "Chrome - Android Mobile": "Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Mobile Safari/535.19"
    "Chrome - Android Tablet": "Mozilla/5.0 (Linux; Android 4.1.2; Nexus 7 Build/JZ054K) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Safari/535.19"
    "Chrome 32": "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"
    "iPhone - iOS 7": "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_2 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A4449d Safari/9537.53"
    "iPhone - iOS 6": "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
    "iPad - iOS 7": "Mozilla/5.0 (iPad; CPU OS 7_0_2 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A501 Safari/9537.53A"
    "iPad - iOS 6": "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
    "Android 2.3 - Nexus S": "Mozilla/5.0 (Linux; U; Android 2.3.6; en-us; Nexus S Build/GRK39F) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    "Android 4.0.2 - Galaxy Nexus": "Mozilla/5.0 (Linux; U; Android 4.0.2; en-us; Galaxy Nexus Build/ICL53F) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
    "Blackberry - Playbook 2.1": "Mozilla/5.0 (PlayBook; U; RIM Tablet OS 2.1.0; en-US) AppleWebKit/536.2+ (KHTML, like Gecko) Version/7.2.1.0 Safari/536.2+"
    "Blackberry - 9900": "Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en-US) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0.187 Mobile Safari/534.11+"
    "Blackberry - BB10": "Mozilla/5.0 (BB10; Touch) AppleWebKit/537.1+ (KHTML, like Gecko) Version/10.0.0.1337 Mobile Safari/537.1+"
    "MeeGo - Nokia N9": "Mozilla/5.0 (MeeGo; NokiaN9) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13"

  $scope.viewports =
    "Desktop":
      width: 1024
      height: 768
      density: 1
    "Nexus 4":
      width: 768
      height: 1280
      density: 2
    "Nexus 7":
      width: 1280
      height: 800
      density: 1.325
    "iPhone 4":
      width: 640
      height: 960
      density: 2
    "iPhone 5":
      width: 640
      height: 1136
      density: 2
    "Galaxy Nexus 10":
      width: 2560
      height: 1600
      density: 2
    "Apple iPad 3 / 4":
      width: 2084
      height: 1536
      density: 2
    "Apple iPad 1 / 2 / Mini":
      width: 1024
      height: 768
      density: 1
    "Samsung Galaxy Note 3":
      width: 1080
      height: 1920
      density: 2

  $scope.viewport = $scope.viewports["Desktop"]

  $scope.urls = []
  $scope.useDensity = true
  $scope.shot =
    url: ""
    options:
      screenSize:
        width: 1024
        height: 768
      shotSize:
        width: "all"
        height: "all"
      userAgent: $scope.userAgents["Chrome 32"]

  applyDimension = ->
    density = if $scope.useDensity then $scope.viewport.density else 1
    $scope.shot.options.screenSize.width = Math.round $scope.viewport.width / density
    $scope.shot.options.screenSize.height = Math.round $scope.viewport.height / density
    $scope.shot.options.shotSize.width = Math.round $scope.viewport.width / density
    $scope.shot.options.shotSize.height = Math.round $scope.viewport.height / density

  $scope.$watch "viewport", applyDimension
  $scope.$watch "useDensity", applyDimension

  $scope.swapDimensions = ->
    tempW = $scope.shot.options.screenSize.width
    tempH = $scope.shot.options.screenSize.height
    $scope.shot.options.screenSize.width = tempH
    $scope.shot.options.screenSize.height = tempW
    tempW = $scope.shot.options.shotSize.width
    tempH = $scope.shot.options.shotSize.height
    $scope.shot.options.shotSize.width = tempH
    $scope.shot.options.shotSize.height = tempW

  $scope.takeShot = ->
    $scope.screenShotModal.hide()
    alertId = $scope.addAlert
      msg: "Taking screenshot..."
      loading: true

    $scope.activeSession.socket.captureScreen $scope.shot, ->
      $scope.removeAlert alertId
      $scope.$apply()

    $scope.shot.url = ""
