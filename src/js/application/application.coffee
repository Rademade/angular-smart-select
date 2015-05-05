app = angular.module('app', ['ngSmartSelect'])
app.controller 'mainCtrl', ['$scope', ($scope)->

  $scope.items = [
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

  $scope.selectedItem = $scope.items[1]
  $scope.$watch 'selectedItem', ->
    console.log $scope.selectedItem

  $scope.addNewItem = -> $scope.isNewItem = true
  $scope.newItem = (name)-> { name : name }

]