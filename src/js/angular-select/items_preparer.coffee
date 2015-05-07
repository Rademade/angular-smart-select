angular.module('ngSmartSelect').factory 'ItemsPreparer', ['Highlighter',(Highlighter)->

  class ItemsPreparer

    values : []
    items : []
    properItems : []
    match : ''
    matchClass : ''
    matchedField : 'name'

    constructor : (values, matchClass)->
      @values = values
      @matchClass = matchClass

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

  ItemsPreparer
]
