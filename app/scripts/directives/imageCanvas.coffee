angular.module("pdifferenceApp").directive "imageCanvas", ($parse) ->
	(scope, element, attrs) ->
		loadImage = (src) ->
			img = new Image()
			
			img.onload = ->
				element.attr "width", img.width
				element.attr "height", img.height
				ctx = element[0].getContext "2d"
				ctx.drawImage img, 0, 0, img.width, img.height
				scope.shot.canvasContext = ctx
				scope.removeAlert alertId
				scope.$apply()

			alertId = scope.addAlert
				msg: "Loading image..."
				loading: true

			img.src - src

		scope.$watch attrs.src, (newVal) -> loadImage newVal
