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
			@screenAnimate = false
			@screenPosition = {x: 0, y: 0 }
			@screenOpacity = 1
			@selectedForDifference = false
			@canvasContext = null

			angular.extend this, options
	return Shot
