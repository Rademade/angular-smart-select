(function() {
  angular.module('ngSmartSelect', ['ngSanitize']).directive('selector', [
    'ObjectItemsPreparer', 'ArrayItemsPreparer', function(ObjectItemsPreparer, ArrayItemsPreparer) {
      return {
        restrict: 'E',
        templateUrl: 'selector.html',
        scope: {
          values: '=',
          model: '=',
          modelValue: '@',
          maxItems: '@',
          matchClass: '@',
          adding: '@',
          modelChanged: '='
        },
        link: function(scope) {
          var checkItemExists, cleanInput, setModelValueFromOutside;
          document.getElementsByTagName('body')[0].addEventListener('click', function() {
            scope.focus = false;
            cleanInput();
            return scope.$apply();
          });
          scope.addNewItem = function() {
            var newItem;
            if (checkItemExists(scope.selectedItem, scope.values, scope.modelValue)) {
              return;
            }
            newItem = {};
            if (scope.modelValue) {
              newItem[scope.modelValue] = scope.selectedItem;
            } else {
              newItem = scope.selectedItem;
            }
            scope.model = newItem;
            scope.$apply();
            if (scope.modelChanged) {
              scope.modelChanged();
            }
            return scope.values.push(newItem);
          };
          scope.$watch('selectedItem', function() {
            if (scope.ItemsPreparer) {
              return scope.ItemsPreparer.setMatch(scope.selectedItem);
            }
          });
          scope.onFocus = function() {
            scope.focus = true;
            scope.ItemsPreparer.setMatch(scope.selectedItem);
            return scope.selectedItem = '';
          };
          scope.setItem = function(item) {
            if (scope.modelValue) {
              scope.selectedItem = scope.values[item.index][scope.modelValue];
            } else {
              scope.selectedItem = scope.values[item.index];
            }
            scope.model = scope.values[item.index];
              scope.$apply();

              if (scope.modelChanged) {
              scope.modelChanged();
            }
            scope.ItemsPreparer.setMatch(scope.selectedItem);
            return scope.focus = false;
          };
          setModelValueFromOutside = function() {
            if (scope.modelValue) {
              scope.selectedItem = scope.model[scope.modelValue];
              scope.ItemsPreparer = new ObjectItemsPreparer(scope.values, scope.matchClass, scope.modelValue);
            } else {
              scope.selectedItem = scope.model;
              scope.ItemsPreparer = new ArrayItemsPreparer(scope.values, scope.matchClass);
            }
            scope.properItems = scope.ItemsPreparer.getProperItems();
            return scope.ItemsPreparer.setMatch(scope.selectedItem);
          };
          scope.$watch('values', function() {
            if (scope.values) {
              if (!scope.model) {
                scope.model = scope.values[0];
              }
              return setModelValueFromOutside();
            }
          });
          checkItemExists = function(itemValue, items, matchValue) {
            var i, index, item, len;
            for (index = i = 0, len = items.length; i < len; index = ++i) {
              item = items[index];
              if (item[matchValue] === itemValue) {
                return true;
              }
            }
            return false;
          };
          return cleanInput = function() {
            if (scope.modelValue) {
              return scope.selectedItem = scope.model[scope.modelValue];
            } else {
              return scope.selectedItem = scope.model;
            }
          };
        }
      };
    }
  ]);

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  angular.module('ngSmartSelect').factory('ArrayItemsPreparer', [
    'ItemsPreparer', function(ItemsPreparer) {
      var ArrayItemsPreparer;
      ArrayItemsPreparer = (function(superClass) {
        extend(ArrayItemsPreparer, superClass);

        function ArrayItemsPreparer() {
          return ArrayItemsPreparer.__super__.constructor.apply(this, arguments);
        }

        ArrayItemsPreparer.prototype.prepare = function() {
          var i, index, len, ref, results, value;
          this.updateItems();
          ref = this.values;
          results = [];
          for (index = i = 0, len = ref.length; i < len; index = ++i) {
            value = ref[index];
            if (("" + value).indexOf(this.match) > -1) {
              results.push(this.properItems.push(this.createItem(value, index)));
            } else {
              results.push(void 0);
            }
          }
          return results;
        };

        return ArrayItemsPreparer;

      })(ItemsPreparer);
      return ArrayItemsPreparer;
    }
  ]);

}).call(this);

(function() {
  angular.module('ngSmartSelect').service('Highlighter', function() {
    return {
      get: function(text, match, matchClass) {
        return ("" + text).replaceAll("" + match, "<span class='" + matchClass + "'>" + match + "</span>");
      }
    };
  });

}).call(this);

(function() {
  angular.module('ngSmartSelect').factory('ItemsPreparer', [
    'Highlighter', function(Highlighter) {
      var ItemsPreparer;
      ItemsPreparer = (function() {
        ItemsPreparer.prototype.values = [];

        ItemsPreparer.prototype.items = [];

        ItemsPreparer.prototype.properItems = [];

        ItemsPreparer.prototype.match = '';

        ItemsPreparer.prototype.matchClass = '';

        ItemsPreparer.prototype.matchedField = 'name';

        function ItemsPreparer(values, matchClass) {
          this.values = values;
          this.matchClass = matchClass;
        }

        ItemsPreparer.prototype.setMatch = function(match) {
          this.match = match;
          return this.prepare();
        };

        ItemsPreparer.prototype.createItem = function(value, index) {
          var item;
          item = {};
          item.index = index;
          item[this.matchedField] = Highlighter.get(value, this.match, this.matchClass);
          return item;
        };

        ItemsPreparer.prototype.addValue = function(value) {
          return this.values.push(value);
        };

        ItemsPreparer.prototype.prepare = function() {
          throw new OverrideException('prepare', 'ItemsPreparer');
        };

        ItemsPreparer.prototype.updateItems = function() {
          var results;
          results = [];
          while (this.properItems.length > 0) {
            results.push(this.properItems.pop());
          }
          return results;
        };

        ItemsPreparer.prototype.getProperItems = function() {
          return this.properItems;
        };

        return ItemsPreparer;

      })();
      return ItemsPreparer;
    }
  ]);

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  angular.module('ngSmartSelect').factory('ObjectItemsPreparer', [
    'ItemsPreparer', function(ItemsPreparer) {
      var ObjectItemsPreparer;
      ObjectItemsPreparer = (function(superClass) {
        extend(ObjectItemsPreparer, superClass);

        function ObjectItemsPreparer(values, matchClass, matchFiled) {
          ObjectItemsPreparer.__super__.constructor.call(this, values, matchClass);
          this.matchedField = matchFiled;
        }

        ObjectItemsPreparer.prototype.prepare = function() {
          var i, index, len, ref, results, value;
          this.updateItems();
          ref = this.values;
          results = [];
          for (index = i = 0, len = ref.length; i < len; index = ++i) {
            value = ref[index];
            if (("" + value[this.matchedField]).indexOf(this.match) > -1 || this.matchedField === '') {
              results.push(this.properItems.push(this.createItem(value[this.matchedField], index)));
            } else {
              results.push(void 0);
            }
          }
          return results;
        };

        return ObjectItemsPreparer;

      })(ItemsPreparer);
      return ObjectItemsPreparer;
    }
  ]);

}).call(this);

(function() {
  String.prototype.replaceAll = function(str1, str2, ignore) {
    return this.replace(new RegExp(("" + str1).replace(/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g, "\\$&"), (ignore ? "gi" : "g")), (typeof ("" + str2) === "string" ? ("" + str2).replace(/\$/g, "$$$$") : "" + str2));
  };

}).call(this);

(function() {
  this.OverrideException = (function() {
    OverrideException.prototype.name = 'overrideException';

    OverrideException.prototype.messages = '';

    function OverrideException(method, className) {
      this.message = "abstract method " + method + " on " + className + " not overridden";
    }

    return OverrideException;

  })();

}).call(this);

angular.module("ngSmartSelect").run(["$templateCache", function($templateCache) {$templateCache.put("selector.html","<div ng-init=\"focus=false\" class=\"selector-wrapper\"><input ng-click=\"$event.stopPropagation();$event.preventDefault();\" ng-model=\"selectedItem\" type=\"text\" ng-focus=\"onFocus()\" class=\"input-selector\"/><div ng-class=\"{\'empty\': !focus}\" class=\"select-list\"><div class=\"select-list-box\"><div ng-show=\"properItems &amp;&amp; focus \" ng-repeat=\"properItem in properItems\" ng-click=\"setItem(properItem);$event.stopImmediatePropagation();$event.preventDefault();\" class=\"select-item\"><span ng-bind-html=\"properItem[modelValue] || properItem[\'name\']\" class=\"select-item-text\"></span></div></div><div ng-show=\"focus &amp;&amp; adding\" class=\"select-btn-box\"><button ng-click=\"addNewItem()\">Add</button></div></div></div>");}]);