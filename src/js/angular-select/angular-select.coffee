angular.module('ngSmartSelect',['ngSanitize']).directive 'selector',[ 'ObjectItemsPreparer', 'ArrayItemsPreparer', (ObjectItemsPreparer, ArrayItemsPreparer)->
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
    document.getElementsByTagName('body')[0].addEventListener 'click', ->
        scope.focus = false
        cleanInput()
        scope.$apply()

####
# scope methods  <<<<
####

    scope.addNewItem = ->
      return if checkItemExists(scope.selectedItem, scope.values, scope.modelValue)
      newItem = {}
      if scope.modelValue
        newItem[scope.modelValue] = scope.selectedItem
      else
        newItem = scope.selectedItem
      scope.model = newItem
      scope.values.push newItem

    scope.$watch 'selectedItem', ->
#      if scope.itemSelected
#        scope.itemSelected = false
#        return
      scope.ItemsPreparer.setMatch(scope.selectedItem)

    scope.onFocus = ->
      scope.focus = true
      scope.ItemsPreparer.setMatch(scope.selectedItem)


    scope.setItem = (item)->
#      scope.itemSelected = true
      if scope.modelValue
        scope.selectedItem = scope.values[item.index][scope.modelValue]
      else
        scope.selectedItem = scope.values[item.index]

      scope.model = scope.values[item.index]
      scope.ItemsPreparer.setMatch(scope.selectedItem)
      scope.focus = false

####
# scope methods  >>>>
####
    setModelValueFromOutside = ->

      if scope.modelValue
        scope.selectedItem = scope.model[scope.modelValue]
        scope.ItemsPreparer = new ObjectItemsPreparer(scope.values, scope.matchClass, scope.modelValue)
      else
        scope.selectedItem = scope.model
        scope.ItemsPreparer = new ArrayItemsPreparer(scope.values, scope.matchClass)

      scope.properItems = scope.ItemsPreparer.getProperItems()
      scope.ItemsPreparer.setMatch(scope.selectedItem)
#      scope.itemSelected = true

    setModelValueFromOutside()

    checkItemExists = (itemValue, items, matchValue)->
      for item, index in items
        return true if item[matchValue] == itemValue
      return false

    cleanInput = ->
      if scope.modelValue
         scope.selectedItem = scope.model[scope.modelValue]
      else
         scope.selectedItem = scope.model
]