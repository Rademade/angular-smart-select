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
    modelChanged: '='

  link: (scope, element) ->
    document.getElementsByTagName('body')[0].addEventListener 'click', ->
        scope.focus = false
        cleanInput()

####
# scope methods  <<<<
####

    scope.$watch 'model', ->
       scope.modelChanged()  if scope.modelChanged

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
      scope.ItemsPreparer.setMatch(scope.selectedItem) if scope.ItemsPreparer

    scope.onFocus = ->
      element[0].click()
      scope.focus = true
      scope.ItemsPreparer.setMatch(scope.selectedItem) if scope.ItemsPreparer
      scope.selectedItem = ''


    scope.setItem = (item)->
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
      scope.properItems = []
      if scope.modelValue
        scope.selectedItem = scope.model[scope.modelValue]
        scope.ItemsPreparer = new ObjectItemsPreparer(scope.values, scope.matchClass, scope.properItems, scope.modelValue)
      else
        scope.selectedItem = scope.model
        scope.ItemsPreparer = new ArrayItemsPreparer(scope.values, scope.matchClass, scope.properItems)

      scope.ItemsPreparer.setMatch(scope.selectedItem)

    scope.$watch 'values', ->
      if scope.values
        scope.model = scope.values[0] unless scope.model
        setModelValueFromOutside()

    checkItemExists = (itemValue, items, matchValue)->
      for item, index in items
        return true if item[matchValue] == itemValue
      return false

    cleanInput = ->
      if scope.modelValue and scope.model
         scope.selectedItem = scope.model[scope.modelValue]
      else
         scope.selectedItem = scope.model
]