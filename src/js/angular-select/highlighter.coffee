angular.module('ngSmartSelect').service 'Highlighter', ->

  get : (text, match, matchClass)-> text.replaceAll(match, "<span class='#{matchClass}'>#{match}</span>")


