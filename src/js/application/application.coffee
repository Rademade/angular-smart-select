app = angular.module('app', ['ngSmartSelect'])
app.controller 'mainCtrl', ['$scope', ($scope) ->

  $scope.objectItems = [
    {name : '2001'},
    {name : '2000'},
    {name : '1999'},
    {name : '1998'},
    {name : '1997'},
    {name : '1996'},
    {name : '1995'},
    {name : '1994'},
    {name : '1993'},
    {name : '1992'},
    {name : '1991'},
    {name : '1990'}
  ]
  $scope.arrayItems = [
    '2001',
    '2000',
    '1999',
    '1998',
    '1997',
    '1996',
    '1995',
    '1994',
    '1993',
    '1992',
    '1991',
    '1990'
  ]

  $scope.selectorSettings =
    minString : 2

  $scope.arraySelectedItem = undefined
  $scope.objectSelectedItem = $scope.objectItems[0]

  $scope.modelChanged = (item) ->
    console.log item

  $scope.$watch 'selectedItem', ->
    console.log $scope.selectedItem

  $scope.addNewItem = -> $scope.isNewItem = true
  $scope.newItem = (name)-> { name : name }

]