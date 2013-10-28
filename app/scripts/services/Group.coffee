angular.module("pdifferenceApp").factory "Group", ->
	class Group
		constructor: ->
			@shots = []
			@source = null
			@generatedDifferences = []
			@id = _.uniqueId()
			@currentTab = null
			@name = "Group #{@id}"
		addShot: (shot) -> 
			@shots.push shot
			@sortShots()
		setName: (name) -> @name = name
		removeShot: (shot) ->
			_.pull @shots, shot
			@sortShots()
		addDifference: (diff) -> @generatedDifferences.push diff
		removeDifference: (shot) -> _.pull @generatedDifferences, shot
		findSource: ->
			@source = _.find group.shots, (shot) ->
				shot.type is "source"
		sortShots: ->
			@shots.sort (a, b) -> 
				if a.type is "source" 
					return -1
				else
					return 1
		setCurrentShot: (id) -> @currentTab = id


	return Group
