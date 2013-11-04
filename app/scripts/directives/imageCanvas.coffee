angular.module("pdifferenceApp").directive "imageCanvas", ($parse) ->
	(scope, element, attrs) ->
		loadImage = (src) ->
			img = new Image()
			
			img.onload = ->
				scope.$apply ->
					element.attr "width", img.width
					element.attr "height", img.height
					ctx = element[0].getContext "2d"
					ctx.drawImage img, 0, 0, img.width, img.height
					scope.shot.canvasContext = ctx
					scope.shot.width = img.width
					scope.shot.height = img.height
					scope.removeAlert alertId
					(scope.applyZoom or angular.noop)()
					scope.activeSession.viewport.adjust()

			alertId = scope.addAlert
				msg: "Loading image..."
				loading: true

			img.src = src

		scope.$watch attrs.src, (newVal) -> loadImage newVal
