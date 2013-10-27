compare = (pixels) ->
	pix = []
	for x in [0...pixels.length]
		for y in [0...pixels.length]
			pix.push Math.abs(pixels[x] - pixels[y])
	Math.max.apply Math, pix

getPixel = (arr, i) ->
	output = []
	output.unshift pix.data.data[i] for pix in arr
	return output

