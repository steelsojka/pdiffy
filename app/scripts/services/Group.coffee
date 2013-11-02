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
		addShot: (shot) -> 
			@shots.push shot
			@sortShots()
		setName: (name) -> @name = name
		removeShot: (shot) ->
			_.pull @shots, shot
			@sortShots()
		addDifference: (diff) -> @differences.push diff
		removeDifference: (shot) -> _.pull @differences, shot
		findSource: ->
			@source = _.find group.shots, (shot) ->
				shot.type is "source"
		sortShots: ->
			@shots.sort (a, b) ->
				if a.type is "source"
					return -1
				else
					return 1
		getShotById: (id) -> _.find @shots, (shot) -> shot.id is id
		getDifferenceById: (id) -> _.find @differences, (shot) -> shot.id is id
		setCurrentShot: (id) ->
			@currentTab = id
			@currentShot = @getShotById(id) or @getDifferenceById(id) or null


	return Group
