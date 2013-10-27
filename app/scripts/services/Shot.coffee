angular.module('pdifferenceApp').factory 'Shot', ->
	class Shot
		constructor: ->
			@id = _.uniqueId()
			@show = true
			@data = {}
			@type = "upload"
			@displayURL = ""
			@screen =
				path: ""
			@screenAnimateTime = 1
			@differenceAnimateTime = 1
			@screenAnimate = false
			@differenceAnimate = false
			@screenPosition = {x: 0, y: 0 }
			@differencePosition = {x: 0, y: 0 }

	return Shot

