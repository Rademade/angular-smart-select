(function() {
  angular.module('ngSmartSelect', ['ngSanitize']).directive('selector', [
    'ObjectItemsPreparer', 'ArrayItemsPreparer', '$document', function(ObjectItemsPreparer, ArrayItemsPreparer, $document) {
      var ENTER_KEY;
      ENTER_KEY = 13;
      return {
        require: '?ngModel',
        restrict: 'E',
        templateUrl: 'selector.html',
        scope: {
          values: '=?',
          modelValue: '@',
          maxItems: '@',
          matchClass: '@',
          adding: '@',
          placeholder: '@',
          label: '@',
          emptyResultMessage: '@',
          ngDisabled: '=?',
          settings: '=?',
          form: '=?',
          autoLoader: '=?'
        },
        link: function(scope, element, attr, ngModelController) {
          var _inputElement, _loadWithAutoLoader, cleanInput, initItemsPreparer;
          _inputElement = element.find('input')[0];
          scope.clearSelector = function(event) {
            scope.focus = false;
            return cleanInput();
          };
          _loadWithAutoLoader = function(selectedItem) {
            if (!scope.autoLoader) {
              return;
            }
            return scope.autoLoader(selectedItem).then(function(values) {
              return scope.values = values;
            });
          };
          ngModelController.$render = function() {
            return scope.model = ngModelController.$modelValue;
          };
          scope.$watch('model', function() {
            if (!scope.values) {
              return;
            }
            scope.selectedItem = '';
            return initItemsPreparer();
          });
          scope.keyPressed = function(event) {
            if (event.keyCode !== ENTER_KEY) {
              return false;
            }
            return cleanInput();
          };
          scope.handleArrowClick = function(event) {
            return scope.handleClick(event);
          };
          scope.handleClick = function(event, focus) {
            scope.selectedItem = '';
            return _inputElement.focus();
          };
          scope.addNewItem = function() {
            var newItem;
            if (scope.settings && scope.selectedItem.length < scope.settings.minStringLength) {
              return;
            }
            if (scope.itemsPreparer.checkItemExists(scope.selectedItem)) {
              return;
            }
            newItem = {};
            if (scope.modelValue) {
              newItem[scope.modelValue] = scope.selectedItem;
            } else {
              newItem = scope.selectedItem;
            }
            scope.model = newItem;
            ngModelController.$setViewValue(scope.model);
            return scope.values.push(newItem);
          };
          scope.$watch('selectedItem', function() {
            _loadWithAutoLoader(scope.selectedItem);
            if (scope.itemsPreparer) {
              return scope.itemsPreparer.setMatch(scope.selectedItem);
            }
          });
          scope.onFocus = function() {
            scope.focus = true;
            if (scope.itemsPreparer) {
              scope.itemsPreparer.setMatch(scope.selectedItem);
            }
            return scope.selectedItem = '';
          };
          scope.setItem = function(item) {
            var itemNotChanged;
            itemNotChanged = true;
            if (scope.modelValue) {
              itemNotChanged = scope.selectedItem === scope.values[item.index][scope.modelValue];
              scope.selectedItem = scope.values[item.index][scope.modelValue];
            } else {
              itemNotChanged = scope.selectedItem === scope.values[item.index];
              scope.selectedItem = scope.values[item.index];
            }
            scope.model = scope.values[item.index];
            if (!itemNotChanged) {
              ngModelController.$setViewValue(scope.model);
            }
            scope.itemsPreparer.setMatch(scope.selectedItem);
            return scope.focus = false;
          };
          initItemsPreparer = function() {
            scope.properItems = [];
            if (scope.modelValue) {
              if (scope.model) {
                scope.selectedItem = scope.model[scope.modelValue];
              }
              scope.itemsPreparer = new ObjectItemsPreparer(scope.values, scope.matchClass, scope.properItems, scope.modelValue);
            } else {
              if (scope.model) {
                scope.selectedItem = scope.model;
              }
              scope.itemsPreparer = new ArrayItemsPreparer(scope.values, scope.matchClass, scope.properItems);
            }
            return scope.itemsPreparer.setMatch(scope.selectedItem);
          };
          scope.$watch('values', function() {
            if (!scope.values) {
              return;
            }
            if (scope.itemsPreparer) {
              scope.itemsPreparer.resetValues(scope.values);
              return scope.itemsPreparer.setMatch(scope.selectedItem);
            } else {
              return initItemsPreparer();
            }
          });
          return cleanInput = function() {
            if (scope.modelValue && scope.model) {
              scope.selectedItem = scope.model[scope.modelValue];
            } else {
              scope.selectedItem = scope.model;
            }
            if (scope.properItems && scope.properItems[0] && scope.properItems.length === 1) {
              return scope.setItem(scope.properItems[0]);
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
          if (!this.values) {
            return;
          }
          this.updateItems();
          ref = this.values;
          results = [];
          for (index = i = 0, len = ref.length; i < len; index = ++i) {
            value = ref[index];
            if (this.isMatch(value, this.match)) {
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
  angular.module('ngSmartSelect').service('highlighter', [
    function() {
      return {
        get: function(text, match, matchClass) {
          return ("" + text).replaceAll("" + match, "" + matchClass);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('ngSmartSelect').factory('ItemsPreparer', [
    'highlighter', function(highlighter) {
      var ItemsPreparer;
      ItemsPreparer = (function() {
        ItemsPreparer.prototype.values = [];

        ItemsPreparer.prototype.items = [];

        ItemsPreparer.prototype.properItems = [];

        ItemsPreparer.prototype.match = '';

        ItemsPreparer.prototype.matchClass = '';

        ItemsPreparer.prototype.matchedField = 'name';

        function ItemsPreparer(values, matchClass, properItems) {
          this.values = values;
          this.matchClass = matchClass;
          this.properItems = properItems;
        }

        ItemsPreparer.prototype.setMatch = function(match) {
          this.match = match;
          return this.prepare();
        };

        ItemsPreparer.prototype.createItem = function(value, index) {
          var item;
          item = {};
          item.index = index;
          item[this.matchedField] = highlighter.get(value, this.match, this.matchClass);
          return item;
        };

        ItemsPreparer.prototype.addValue = function(value) {
          return this.values.push(value);
        };

        ItemsPreparer.prototype.resetValues = function(values) {
          return this.values = values;
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

        ItemsPreparer.prototype.checkItemExists = function(itemValue) {
          var i, index, item, len, ref;
          ref = this.items;
          for (index = i = 0, len = ref.length; i < len; index = ++i) {
            item = ref[index];
            if (item[this.matchedField] === itemValue) {
              return true;
            }
          }
          return false;
        };

        ItemsPreparer.prototype.isMatch = function(value, match) {
          return ("" + value).toLowerCase().indexOf(("" + match).toLowerCase()) > -1;
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

        function ObjectItemsPreparer(values, matchClass, properItems, matchFiled) {
          ObjectItemsPreparer.__super__.constructor.call(this, values, matchClass, properItems);
          this.matchedField = matchFiled;
        }

        ObjectItemsPreparer.prototype.prepare = function() {
          var i, index, len, ref, results, value;
          if (!this.values) {
            return;
          }
          this.updateItems();
          ref = this.values;
          results = [];
          for (index = i = 0, len = ref.length; i < len; index = ++i) {
            value = ref[index];
            if (this.isMatch(value[this.matchedField], this.match) || this.matchedField === '') {
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
  angular.module('ngSmartSelect').directive('smartSelectorBodyClick', [
    '$document', '$timeout', function($document, $timeout) {
      return {
        scope: {
          smartSelectorBodyClick: '&',
          isActive: '=?'
        },
        link: function($scope, $el, attrs) {
          var callback;
          callback = function(e) {
            if (!$scope.isActive) {
              return;
            }
            if (!$el[0].contains(e.currentTarget.activeElement)) {
              return $timeout(function() {
                return $scope.smartSelectorBodyClick();
              }, 0);
            }
          };
          $document.bind('click', callback);
          return $scope.$on('$destroy', function() {
            return $document.unbind('click', callback);
          });
        }
      };
    }
  ]);

}).call(this);

(function() {
  String.prototype.replaceAll = function(str1, str2, ignore) {
    str1 = str1.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
    return this.replace(new RegExp("([^(" + str1 + ")]*)(" + str1 + ")([^(" + str1 + ")]*)", "gi"), "$1<span class=\"" + str2 + "\">$2</span>$3");
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

angular.module("ngSmartSelect").run(["$templateCache", function($templateCache) {$templateCache.put("selector.html","<label ng-init=\"focus=false\" ng-class=\"{ \'is-current\': focus }\" class=\"selector-wrapper\"><input ng-click=\"handleClick($event)\" smart-selector-body-click=\"clearSelector()\" is-active=\"focus\" ng-class=\"{ \'is-disabled\' : ngDisabled }\" ng-keypress=\"keyPressed($event)\" ng-disabled=\"ngDisabled\" ng-model=\"selectedItem\" type=\"text\" ng-focus=\"onFocus()\" placeholder=\"{{placeholder}}\" class=\"input-selector\"/><i ng-click=\"handleArrowClick($event)\" class=\"selector-arrow\"></i><span class=\"input-hint\">{{label}}</span><div ng-class=\"{\'empty\': !focus}\" class=\"select-list\"><div ng-if=\"properItems.length &gt; 0\" class=\"select-list-box\"><div ng-show=\"properItems &amp;&amp; focus \" ng-repeat=\"properItem in properItems\" ng-click=\"setItem(properItem);$event.stopImmediatePropagation();$event.preventDefault();\" class=\"select-item\"><span ng-bind-html=\"properItem[modelValue] || properItem[\'name\']\" class=\"select-item-text\"></span></div></div><span ng-if=\"properItems.length == 0 &amp;&amp; focus\" class=\"empty-result\">{{emptyResultMessage}}</span><div ng-show=\"focus &amp;&amp; adding\" class=\"select-btn-box\"><button ng-click=\"addNewItem()\" class=\"select-btn\">{{adding}}</button></div></div></label>");}]);