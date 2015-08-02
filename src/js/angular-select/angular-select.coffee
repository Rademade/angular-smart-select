angular.module('ngSmartSelect', ['ngSanitize']).directive 'selector',
  ['ObjectItemsPreparer', 'ArrayItemsPreparer',
    (ObjectItemsPreparer, ArrayItemsPreparer) ->
      ENTER_KEY  = 13

      require: '?ngModel'
      restrict: 'E'
      templateUrl: 'selector.html'
      scope:
        values: '='
        modelValue: '@'
        maxItems: '@'
        matchClass: '@'
        adding: '@'
        placeholder: '@'
        label: '@'
        emptyResultMessage: '@'
        ngDisabled: '=?'

      link: (scope, element, attr, ngModelController) ->
        _onClickCallback =  ->
          scope.focus = false
          cleanInput()

        body = angular.element(document.getElementsByTagName('body')[0])
        body.bind 'click', _onClickCallback

        ngModelController.$render = ->
          scope.model = ngModelController.$modelValue

        ####
        # scope methods  <<<<
        ####
        scope.$on '$destroy', -> body.unbind 'click', _onClickCallback

        scope.$watch 'model', ->
          return unless scope.values
          initItemsPreparer()

        scope.keyPressed = (event) ->
          return false if event.keyCode != ENTER_KEY
          cleanInput()


        scope.handleClick = (event) ->
          element.find('input')[0].focus()
          event.stopPropagation()
          event.preventDefault()

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

          scope.setItem(scope.properItems[0]) if scope.properItems[0] and scope.properItems.length == 1

]
