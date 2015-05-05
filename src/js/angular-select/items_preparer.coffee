angular.module('ngSmartSelect').factory 'ItemsPreparer', ->

  class ItemsPreparer

    values : []
    items : []
    properItems : []
    match : ''
    matchClass : ''

    initialize : (values, matchClass)->
      console.log 'initialize'
      @values = values
      @matchClass = matchClass

    setMatch : (match)->
      @match = match

    addValue : (value)-> @values.push value

    prepare : -> # for override

    updateItems : ->  @properItems = []

    getProperItems : -> @properItems

  return ItemsPreparer
