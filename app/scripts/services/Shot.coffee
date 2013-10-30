angular.module('pdifferenceApp').factory 'Shot', ->
	class Shot
		constructor: (options) ->
			@id = _.uniqueId()
			@show = true
			@data = {}
			@type = "upload"
			@displayURL = ""
			@height = 0
			@width = 0
			@buffers = []
			@screen =
				path: ""
			@screenAnimateTime = 1
			@differenceAnimateTime = 1
			@screenAnimate = false
			@differenceAnimate = false
			@screenPosition = {x: 0, y: 0 }
			@differencePosition = {x: 0, y: 0 }
			@screenOpacity = 1
			@differenceOpacity = 1
			@selectedForDifference = false
			@canvasContext = null

			angular.extend this, options
	return Shot
