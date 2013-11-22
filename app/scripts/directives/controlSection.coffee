angular.module('pdifferenceApp').directive "controlSection", ->
  restrict: 'EA'
  link: (scope, element, attrs) ->
    label = element.find "label"

    label.on 'click', ->
      if element[0].hasAttribute 'hide'
        element.removeAttr 'hide'
      else
        element.attr 'hide', ''


