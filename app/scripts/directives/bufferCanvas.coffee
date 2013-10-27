angular.module("pdifferenceApp").directive "bufferCanvas", ($parse) ->
	(scope, element, attrs) ->
		buffers = $parse(attrs.buffers)(scope)

		element[0].width = $parse(attrs.pixelWidth)(scope)
		element[0].height = $parse(attrs.pixelHeight)(scope)

		ctx = element[0].getContext "2d"

		ctx.putImageData buffer.data, 0, buffer.y for buffer in buffers

