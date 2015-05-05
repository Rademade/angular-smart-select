angular.module('ngSuperSelect',['ngSanitize']).directive 'selector',[ ->
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
      newItem[scope.modelValue] = scope.selectedItem
      scope.model = newItem
      scope.values.push newItem

    scope.$watch 'selectedItem', ->
      scope.properItems = []
      if scope.itemSelected
        scope.itemSelected = false
        return
      setProperItems(scope.values, scope.properItems, scope.modelValue, scope.selectedItem, false, scope.matchClass)

    scope.onFocus = ->
      scope.focus = true
      scope.properItems = []
      setProperItems(scope.values, scope.properItems, scope.modelValue, scope.selectedItem, false, scope.matchClass)

    scope.setItem = (item)->
      scope.isNew = false
      scope.itemSelected = true
      scope.selectedItem = scope.values[item.index][scope.modelValue]
      scope.model = scope.values[item.index]
      scope.properItems = []
      scope.focus = false

####
# scope methods  >>>>
####

    setModelValueFromOutside = ->
      scope.selectedItem = scope.model[scope.modelValue]
      scope.itemSelected = true

    setModelValueFromOutside()

    setProperItems = (from, to, matchedValue,  match, count, matchClass)->
      unless checkEmptyValue(from, to, match, count)
        createItems(from, to, matchedValue,  match, count, matchClass)

    createItems = (from, to, matchedValue,  match, count, matchClass)->
      for itemOriginal, index in from
        if itemOriginal[matchedValue].indexOf(match) > -1
          item  = createItem(itemOriginal, matchedValue, index)
          return if to.length == count
          highLightMatches(item, matchedValue, match, matchClass)
          to.push item

    createItem = (itemOriginal, matchedValue, index)->
      item  = {}
      item[matchedValue] = itemOriginal[matchedValue]
      item.index = index
      item

    checkItemExists = (itemValue, items, matchValue)->
      for item, index in items
        return true if item[matchValue] == itemValue
      return false

    cleanInput = ->
      scope.properItems = []
      scope.selectedItem = scope.model[scope.modelValue]

    highLightMatches = (item, matchedValue, match, matchClass)->
      item[matchedValue] = item[matchedValue].replaceAll(match, "<span class='#{matchClass}'>#{match}</span>")


    checkEmptyValue = (from, to, match, count)->
      if match == ''
        for item, index in from
          return if to.length == count
          item.index = index
          to.push item
        return true
]


