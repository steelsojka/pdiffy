angular.module("pdifferenceApp").factory "Modal", ->
	class Modal
		constructor: (options={}) ->
			@open = false
			@options =
				backdropFade: true
				dialogFade: true
				keyboard: true
			@showError = false
			@error = ""

			angular.extend @options, options
		show: -> @open = true
		hide: -> @open = false
		throwError: (msg="") ->
			@error = msg
			@showError = true
		catchError: ->
			@error = ""
			@showError = false

	return Modal

