angular.module('ngSmartSelect').directive 'smartSelectonBodyClick', ['$document', '$timeout', ($document, $timeout) ->
  scope :
    smartSelectonBodyClick : '&'
    isActive : '=?'

  link : ($scope, $el, attrs) ->

    callback = (e) ->
      return unless $scope.isActive
      unless $el[0].contains(e.target)
        $timeout(
          () -> $scope.smartSelectonBodyClick(),
        0)

    $document.bind 'click', callback

    $scope.$on '$destroy', ->
      $document.unbind 'click', callback
]
