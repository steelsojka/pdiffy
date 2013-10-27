angular.module("pdifferenceApp").directive "fileUpload", ($parse) ->
	(scope, element, attrs) ->
		fn = $parse attrs.fileUpload
		element.bind "change", (e) ->
			scope.$apply ->
				fn scope, {$event: e, $files: element[0].files}
