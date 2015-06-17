angular.module('ngSmartSelect').factory 'ItemsPreparer', ['Highlighter',(Highlighter)->

  class ItemsPreparer

    values : []
    items : []
    properItems : []
    match : ''
    matchClass : ''
    matchedField : 'name'

    constructor : (values, matchClass, properItems)->
      @values = values
      @matchClass = matchClass
      @properItems  = properItems

    setMatch : (match)->
      @match = match
      @prepare()

    createItem : (value, index)->
      item = {}
      item.index = index
      item[@matchedField] = Highlighter.get(value, @match, @matchClass )
      item

    addValue : (value)-> @values.push value

    prepare : -> throw new OverrideException('prepare', 'ItemsPreparer')

    updateItems : ->
      while @properItems.length > 0
        @properItems.pop()

    getProperItems : -> @properItems

    checkItemExists : (itemValue)->
      for item, index in @items
        return true if item[@matchedField] == itemValue
      return false



  ItemsPreparer
]
