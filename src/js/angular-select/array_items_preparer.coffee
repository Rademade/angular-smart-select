angular.module('ngSmartSelect').factory 'ArrayItemsPreparer', [ 'ItemsPreparer', (ItemsPreparer)->

  class ArrayItemsPreparer extends ItemsPreparer

    prepare : () ->
      return unless @values
      @updateItems()
      for value, index in @values
        if @isMatch(value, @match)
          @properItems.push @createItem(value, index)

  ArrayItemsPreparer
]
