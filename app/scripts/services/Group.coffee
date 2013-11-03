angular.module("pdifferenceApp").factory "Group", ->
	class Group
		constructor: ->
			@shots = []
			@source = null
			@differences = []
			@id = _.uniqueId()
			@currentTab = null
			@currentShot = null
			@name = "Group #{@id}"
		addShot: (shot) -> @shots.push shot
		setName: (name) -> @name = name
		removeShot: (shot) ->
			array = null
			if _.contains @shots, shot
				array = @shots
			else if _.contains @differences, shot
				array = @differences

			return if array is null

			index = array.indexOf shot
			isLast = index is array.length - 1

			_.pull array, shot

			if array.length > 0
				nextShot = if isLast then array[index - 1] else array[index]
				@setCurrentShot nextShot.id
			else
				otherArray = if array is @shots then @differences else @shots
				if otherArray.length > 0
					@setCurrentShot otherArray[otherArray.length - 1].id
		addDifference: (diff) -> @differences.push diff
		removeDifference: (shot) -> _.pull @differences, shot
		findSource: ->
			@source = _.find group.shots, (shot) ->
				shot.type is "source"
		getShotById: (id) -> _.find @shots, (shot) -> shot.id is id
		getDifferenceById: (id) -> _.find @differences, (shot) -> shot.id is id
		setCurrentShot: (id) ->
			@currentTab = id
			@currentShot = @getShotById(id) or @getDifferenceById(id) or null
		moveToShot: (index) ->
			return if @currentShot is null
			shotArray = @getActiveSet()
			@setCurrentShot shotArray[index].id if shotArray.length > index >= 0
		getActiveSet: ->
			return if @currentShot is null
			if @currentShot.type is "difference" then @differences else @shots
		getActiveSetIndex: ->
			set = @getActiveSet()
			return if not angular.isArray set
			set.indexOf @currentShot


	return Group
