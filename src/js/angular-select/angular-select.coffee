angular.module('ngSmartSelect',['ngSanitize']).directive 'selector',[ 'ObjectItemsPreparer', (ObjectItemsPreparer)->
  restrict : 'E'
  templateUrl : 'selector.html'
  scope :
    values : '='
    model : '='
    modelValue : '@'
    maxItems : '@'
    matchClass : '@'
    adding : '@'
  link: (scope) ->
    console.log 'directive'
    document.getElementsByTagName('body')[0].addEventListener 'click', ->
        scope.focus = false
        cleanInput()
        scope.ItemsPreparer.updateItems()
        scope.$apply()

####
# scope methods  <<<<
####

    scope.addNewItem = ->
      return if checkItemExists(scope.selectedItem, scope.values, scope.modelValue)
      newItem = {}
      newItem[scope.modelValue] = scope.selectedItem
      scope.model = newItem
      scope.values.push newItem

    scope.$watch 'selectedItem', ->
#      scope.properItems = []
      if scope.itemSelected
        scope.itemSelected = false
        return
      scope.ItemsPreparer.setMatch(scope.selectedItem)
      scope.ItemsPreparer.prepare()
      scope.properItems = scope.ItemsPreparer.getProperItems()

    scope.onFocus = ->
      scope.focus = true
      scope.ItemsPreparer.prepare()

    scope.setItem = (item)->
      scope.isNew = false
      scope.itemSelected = true
      scope.selectedItem = scope.values[item.index][scope.modelValue]
      scope.model = scope.values[item.index]
      scope.ItemsPreparer.prepare()
      scope.ItemsPreparer.updateItems()
      scope.properItems = scope.ItemsPreparer.getProperItems()
      scope.focus = false

####
# scope methods  >>>>
####
    setModelValueFromOutside = ->
      scope.selectedItem = scope.model[scope.modelValue]
      scope.ItemsPreparer = new ObjectItemsPreparer(scope.values, scope.modelValue, scope.matchClass)
      scope.ItemsPreparer.initialize(scope.values, scope.matchClass, scope.modelValue)
      scope.itemSelected = true

    setModelValueFromOutside()

    checkItemExists = (itemValue, items, matchValue)->
      for item, index in items
        return true if item[matchValue] == itemValue
      return false

    cleanInput = ->
      scope.ItemsPreparer.updateItems()
      scope.selectedItem = scope.model[scope.modelValue]
]


