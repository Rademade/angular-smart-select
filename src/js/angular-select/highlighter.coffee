angular.module('ngSmartSelect').service 'highlighter', [ ->

  get : (text, match, matchClass) -> "#{text}".replaceAll("#{match}", "#{matchClass}")

]


