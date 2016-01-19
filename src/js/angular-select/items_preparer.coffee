angular.module('ngSmartSelect').factory 'ItemsPreparer', ['highlighter',(highlighter)->

  class ItemsPreparer

    values : []
    items : []
    properItems : []
    match : ''
    matchClass : ''
    matchedField : 'name'

    constructor : (values, matchClass, properItems) ->
      @values = values
      @matchClass = matchClass
      @properItems  = properItems

    setMatch : (match)->
      @match = match
      @prepare()

    createItem : (value, index)->
      item = {}
      item.index = index
      item[@matchedField] = highlighter.get(value, @match, @matchClass)
      item

    addValue : (value)-> @values.push value

    resetValues : (values) -> @values = values

    prepare : () -> throw new OverrideException('prepare', 'ItemsPreparer')

    updateItems : () ->
      while @properItems.length > 0
        @properItems.pop()

    getProperItems : () -> @properItems

    checkItemExists : (itemValue)->
      for item, index in @items
        return true if item[@matchedField] == itemValue
      return false

    isMatch : (value, match) ->
      "#{value}".toLowerCase().indexOf("#{match}".toLowerCase()) > -1

  ItemsPreparer
]
