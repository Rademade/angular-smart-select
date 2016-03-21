angular.module('ngSmartSelect').directive 'smartSelectorBodyClick', ['$document', '$timeout', ($document, $timeout) ->
  scope :
    smartSelectorBodyClick : '&'
    isActive : '=?'

  link : ($scope, $el, attrs) ->

    callback = (e) ->
      return unless $scope.isActive
      unless $el[0].contains(e.currentTarget.activeElement)
        $timeout(
          () -> $scope.smartSelectorBodyClick(),
        0)

    $document.bind 'click', callback

    $scope.$on '$destroy', ->
      $document.unbind 'click', callback
]
