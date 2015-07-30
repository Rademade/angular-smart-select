angular.module('ngSmartSelect').service 'Highlighter', [ ->

  get : (text, match, matchClass) -> "#{text}".replaceAll("#{match}", "#{matchClass}")

]


