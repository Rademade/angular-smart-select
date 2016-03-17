angular.module('ngSmartSelect', ['ngSanitize']).directive 'selector',
  ['ObjectItemsPreparer', 'ArrayItemsPreparer',
    (ObjectItemsPreparer, ArrayItemsPreparer) ->
      ENTER_KEY  = 13

      require: '?ngModel'
      restrict: 'E'
      templateUrl: 'selector.html'
      scope:
        values: '=?'
        modelValue: '@'
        maxItems: '@'
        matchClass: '@'
        adding: '@'
        placeholder: '@'
        label: '@'
        emptyResultMessage: '@'
        ngDisabled: '=?'
        settings: '=?'
        form: '=?'
        autoLoader: '=?'

      link: (scope, element, attr, ngModelController) ->
        _onClickCallback =  () ->
          scope.focus = false
          cleanInput()

        _loadWithAutoLoader = (selectedItem) ->
          return unless scope.autoLoader
          scope.autoLoader(selectedItem).then (values) -> scope.values = values

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
          scope.selectedItem = ''
          initItemsPreparer()

        scope.keyPressed = (event) ->
          return false if event.keyCode != ENTER_KEY
          cleanInput()

        scope.handleArrowClick = (event) ->
          return if scope.focus
          scope.handleClick(event)

        scope.handleClick = (event, focus) ->
          scope.selectedItem = ''
          element.find('input')[0].focus()
          event.stopPropagation()
          event.preventDefault()

        scope.addNewItem = ->
          return if scope.settings and scope.selectedItem.length < scope.settings.minStringLength
          return if scope.itemsPreparer.checkItemExists(scope.selectedItem)
          newItem = {}
          if scope.modelValue
            newItem[scope.modelValue] = scope.selectedItem
          else
            newItem = scope.selectedItem
          scope.model = newItem
          ngModelController.$setViewValue(scope.model)
          scope.values.push newItem

        scope.$watch 'selectedItem', () ->
#          reset values on change input field
          _loadWithAutoLoader(scope.selectedItem)
          scope.itemsPreparer.setMatch(scope.selectedItem) if scope.itemsPreparer

        # Bind на фокус можно сделать прямо в директиве
        scope.onFocus = ->
          element[0].click()
          scope.focus = true
          scope.itemsPreparer.setMatch(scope.selectedItem) if scope.itemsPreparer
          scope.selectedItem = ''


        scope.setItem = (item) ->
          itemNotChanged = true
          if scope.modelValue
            itemNotChanged = scope.selectedItem == scope.values[item.index][scope.modelValue]
            scope.selectedItem = scope.values[item.index][scope.modelValue]
          else
            itemNotChanged = scope.selectedItem == scope.values[item.index]
            scope.selectedItem = scope.values[item.index]

          scope.model = scope.values[item.index]
          ngModelController.$setViewValue(scope.model) unless itemNotChanged
          scope.itemsPreparer.setMatch(scope.selectedItem)
          scope.focus = false

        ####
        # scope methods  >>>>
        ####
        initItemsPreparer = () ->
          scope.properItems = []
          if scope.modelValue
            scope.selectedItem = scope.model[scope.modelValue] if scope.model
            scope.itemsPreparer = new ObjectItemsPreparer(scope.values, scope.matchClass, scope.properItems, scope.modelValue)
          else
            scope.selectedItem = scope.model if scope.model
            scope.itemsPreparer = new ArrayItemsPreparer(scope.values, scope.matchClass, scope.properItems)

          scope.itemsPreparer.setMatch(scope.selectedItem)

        scope.$watch 'values', () ->
          return unless scope.values
          if scope.itemsPreparer
            scope.itemsPreparer.resetValues(scope.values)
            scope.itemsPreparer.setMatch(scope.selectedItem)
          else
            initItemsPreparer()

        cleanInput = () ->
          if scope.modelValue and scope.model
            scope.selectedItem = scope.model[scope.modelValue]
          else
            scope.selectedItem = scope.model

          if scope.properItems and scope.properItems[0] and scope.properItems.length == 1
            scope.setItem(scope.properItems[0])

]
