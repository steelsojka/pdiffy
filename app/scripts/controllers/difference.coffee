angular.module('pdifferenceApp').controller "differenceCtrl", ($scope, $injector) ->

	$document = $injector.get "$document"
	Shot = $injector.get "Shot"

	$scope.selectedShots = []
	$scope.diffMode = "subtraction"
	$scope.diffThreshold = 0

	setCurrentShots = ->
		$scope.activeGroup.shots.forEach (shot) ->	shot.selectedForDifference = false

	$scope.performDiff = ->
		$scope.selectedShots = _.filter $scope.activeGroup.shots, (shot) ->
			return shot.selectedForDifference

		if $scope.selectedShots.length < 2
			$scope.diffModal.error = "Please select 2 or more images."
			$scope.diffModal.showError = true
			return

		$scope.diffModal.open = false

		loadingAlertId = $scope.addAlert
			msg: "Performing difference..."
			loading: true
			progress: true

		tempCanvas = $document[0].createElement 'canvas'

		workerCount = 4
		workersFinished = 0
		progress = 0
		imageData = []

		maxLength = Math.max.apply(Math, _.map $scope.selectedShots, (shot) ->
			return shot.canvasContext.canvas.width * shot.canvasContext.canvas.height * 4
		)

		segmentLength = maxLength / workerCount

		maxHeight = Math.max.apply(Math, _.map $scope.selectedShots, (shot) ->
			return shot.canvasContext.canvas.height
		)

		maxWidth = Math.max.apply(Math, _.map $scope.selectedShots, (shot) ->
			return shot.canvasContext.canvas.width
		)

		blockSize = maxHeight / workerCount

		tempCanvas.height = maxHeight
		tempCanvas.width = maxWidth

		tempContext = tempCanvas.getContext '2d'
	
		for i in [0...workerCount]
			worker = new Worker "scripts/worker.js"

			images = _.map $scope.selectedShots, (shot) ->
				width = shot.canvasContext.canvas.width
				height = shot.canvasContext.canvas.height
				startY = blockSize * i
				startX = Math.round (width - maxWidth) / 2
				captureStartX = startX - shot.screenPosition.x
				captureStartY = startY - shot.screenPosition.y
				captureWidth = Math.round width - (width - maxWidth)
				captureHeight = blockSize

				return {
					offset: shot.screenPosition
					data: shot.canvasContext.getImageData captureStartX, captureStartY, captureWidth, captureHeight
					height: height
					width: width
					startX: startX
					startY: startY
					block: blockSize
				}

			block = Math.max.apply(Math, _.pluck images, "block")
			startY = Math.max.apply(Math, _.pluck images, "startY")

			exportObj =
				contextData: tempContext.getImageData 0, images[0].startY, tempCanvas.width, block
				imageData: images
				startY: startY
				block: block
				id: i
				mode: $scope.diffMode
				threshold: $scope.diffThreshold

			worker.addEventListener "message", (e) ->
				if e.data.event is "progress"
					progress = e.data.progress
				else if e.data.event is "done"
					workersFinished++
					$scope.updateAlertProgress loadingAlertId, (workersFinished / workerCount) * 100
					imageData.push e.data

					if workersFinished is workerCount
						onJobEnd imageData, maxHeight, maxWidth
						$scope.removeAlert loadingAlertId

				$scope.$apply()

			worker.postMessage exportObj
		
		onJobEnd = (data, height, width) ->
			data = data.sort (a, b) ->
				if a.id > b.id
					return 1
				else if a.id < b.id
					return -1
				else
					return 0

			outputData =
				numberOfSamePixels: 0
				numberOfDifferentPixels: 0
				totalPixels: 0

			angular.forEach data, (a) ->
				outputData.numberOfSamePixels += a.stats.numberOfSamePixels
				outputData.numberOfDifferentPixels += a.stats.numberOfDifferentPixels
				outputData.totalPixels += a.stats.totalPixels

			outputData.differenceRatio = outputData.numberOfDifferentPixels / outputData.totalPixels

			shot = new Shot
				buffers: data
				width: width
				height: height
				showDifference: true
				type: "genDiff"
				data: outputData

			$scope.activeGroup.generatedDifferences.push shot

	$scope.$watch "diffModal.open", (val) ->
		if not val
			$scope.diffModal.showError = false
			$scope.selectedShots = []
		else
			setCurrentShots()
			$scope.diffModal.open = false if $scope.activeGroup.shots.length < 2

	$scope.$on "openDiffModal", -> $scope.diffModal.open = true
	$scope.$on "closeDiffModal", -> $scope.diffModal.open = false


