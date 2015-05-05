angular.module('ngSmartSelect').factory 'ObjectItemsPreparer', [ 'ItemsPreparer', 'Highlighter', (ItemsPreparer, Highlighter)->

  class ObjectItemsPreparer extends ItemsPreparer

    matchedField : null

    initialize : (values, matchClass, matchFiled)->
      super(values, matchClass)
      @matchedField = matchFiled

    createItem : (value, index)->
      item = {}
      item.index = index
      item[@matchedField] = Highlighter.get(value, @match, @matchClass )
      item

    prepare : ()->
      console.log 'prepare', @values, @match
      @updateItems()
      for value, index in @values
        console.log @match, value[@matchedField].indexOf(@match)
        if value[@matchedField].indexOf(@match) > -1 or @matchedField == ''
          console.log '1'
          @properItems.push @createItem(value[@matchedField], index)
      console.log @properItems

  ObjectItemsPreparer

]