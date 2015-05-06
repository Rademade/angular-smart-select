angular.module('ngSmartSelect').factory 'ArrayItemsPreparer', [ 'ItemsPreparer', (ItemsPreparer)->

  class ArrayItemsPreparer extends ItemsPreparer

    prepare : ->
      @updateItems()
      for value, index in @values
        if value.indexOf(@match) > -1
          @properItems.push @createItem(value, index)

  ArrayItemsPreparer
]