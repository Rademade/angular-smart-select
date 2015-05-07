angular.module('ngSmartSelect').factory 'ObjectItemsPreparer', [ 'ItemsPreparer', (ItemsPreparer)->

  class ObjectItemsPreparer extends ItemsPreparer

    constructor : (values, matchClass, matchFiled)->
      super(values, matchClass)
      @matchedField = matchFiled

    prepare : ()->
      @updateItems()
      for value, index in @values
        if "#{value[@matchedField]}".indexOf(@match) > -1 or @matchedField == ''
          @properItems.push @createItem(value[@matchedField], index)

  ObjectItemsPreparer

]