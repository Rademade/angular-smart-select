angular.module('ngSmartSelect',['ngSanitize']).directive 'selector',[ 'ObjectItemsPreparer', 'ArrayItemsPreparer', (ObjectItemsPreparer, ArrayItemsPreparer)->
  require: '?ngModel'
  restrict : 'E'
  templateUrl : 'selector.html'
  scope :
    values : '='
    modelValue : '@'
    maxItems : '@'
    matchClass : '@'
    adding : '@'
    placeholder : '@'


  link: (scope, element, attr, ngModelController) ->
    document.getElementsByTagName('body')[0].addEventListener 'click', ->
      scope.focus = false
      cleanInput()

    ngModelController.$render = ->
      scope.model = ngModelController.$modelValue

    ####
    # scope methods  <<<<
    ####

    scope.addNewItem = ->
      return if scope.ItemsPreparer.checkItemExists(scope.selectedItem)
      newItem = {}
      if scope.modelValue
        newItem[scope.modelValue] = scope.selectedItem
      else
        newItem = scope.selectedItem
      scope.model = newItem
      ngModelController.$setViewValue(scope.model)
      scope.values.push newItem

    scope.$watch 'selectedItem', ->
      scope.ItemsPreparer.setMatch(scope.selectedItem) if scope.ItemsPreparer

    # Bind на фокус можно сделать прямо в директиве
    scope.onFocus = ->
      element[0].click()
      scope.focus = true
      scope.ItemsPreparer.setMatch(scope.selectedItem) if scope.ItemsPreparer
      scope.selectedItem = ''


    scope.setItem = (item) ->
      if scope.modelValue
        scope.selectedItem = scope.values[item.index][scope.modelValue]
      else
        scope.selectedItem = scope.values[item.index]

      scope.model = scope.values[item.index]
      ngModelController.$setViewValue(scope.model)
      scope.ItemsPreparer.setMatch(scope.selectedItem)
      scope.focus = false

    ####
    # scope methods  >>>>
    ####
    initItemsPreparer = ->
      scope.properItems = []
      if scope.modelValue
        scope.selectedItem = scope.model[scope.modelValue] if scope.model
        scope.ItemsPreparer = new ObjectItemsPreparer(scope.values, scope.matchClass, scope.properItems, scope.modelValue)
      else
        scope.selectedItem = scope.model if scope.model
        scope.ItemsPreparer = new ArrayItemsPreparer(scope.values, scope.matchClass, scope.properItems)

      scope.ItemsPreparer.setMatch(scope.selectedItem)

    scope.$watch 'values', ->
      if scope.values
        initItemsPreparer()

    cleanInput = ->
      if scope.modelValue and scope.model
        scope.selectedItem = scope.model[scope.modelValue]
      else
        scope.selectedItem = scope.model
]
