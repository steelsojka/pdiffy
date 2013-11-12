isServer = if exports then true else false

compare = (pixels) ->
	pix = []
	for x in [0...pixels.length]
		for y in [0...pixels.length]
			pix.push Math.abs(pixels[x] - pixels[y])
	Math.max.apply Math, pix

getPixel = (arr, i) ->
	output = []
	output.unshift pix.data.data[i] for pix in arr by -1
	return output

checkDifference = (r, g, b) -> r > 0 or g > 0 or b > 0

checkThreshold = (r, g, b, threshold) -> r <= threshold and g <= threshold and b <= threshold

difference = (e) ->
	data = e.data.imageData
	outputData =
		numberOfSamePixels: 0
		numberOfDifferentPixels: 0
		totalPixels: 0
	context = e.data.contextData
	contextData = context.data
	maxLength = Math.max.apply(Math, data.map (a) -> a.data.data.length)
	mode = e.data.mode
	threshold = e.data.threshold or 0

	for i in [0...maxLength] by 4
		r = compare getPixel(data, i)
		g = compare getPixel(data, i + 1)
		b = compare getPixel(data, i + 2)

		isDifferent = checkDifference r, g, b
		isUnderThreshold = checkThreshold r, g, b, threshold

		if isUnderThreshold
			r = g = b = 0
			outputData.numberOfSamePixels++
		else
			outputData.numberOfDifferentPixels++

			if mode is "heatmap" and isDifferent
				maxValue = Math.max r, g, b
				r = g = maxValue
				b = 0
			else if mode is "block" and isDifferent
				r = g = 255
				b = 0
		
		contextData[i] = r
		contextData[i + 1] = g
		contextData[i + 2] = b
		contextData[i + 3] = 255

		outputData.totalPixels++

  imageData =
		event: "done"
		id: e.data.id
		data: context
		y: e.data.startY
		block: e.data.block
		stats: outputData
  
  if isServer
    return imageData
  else
    self.postMessage imageData
    self.close()

if isServer
  exports.difference = difference
else
  self.addEventListener "message", difference
