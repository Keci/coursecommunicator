$(document).ready(function () {
	$(".newposttxt").autogrow(); 
	
	$(".tagselect").multiselect({
		button: 'btn btn-mini',
		text: function(options) {
			if (options.length == 0) {
			  return 'Tags';
			}
			else if (options.length > 3) {
			  return options.length + ' tags selected';
			}
			else {
			  var selected = '';
			  options.each(function() {
				selected += '#' + $(this).text() + ', ';
			  });
			  return selected.substr(0, selected.length -2);
			}
		}
	});
		
	$(".optionselect").multiselect({
		button: 'btn btn-mini',
		text: function(options) {
			return "Options";
		}
	});
});

var CourseCommunicator = angular.module("CourseCommunicator", ['ui.directives'], 
	function ($interpolateProvider) {
		$interpolateProvider.startSymbol('[[');
		$interpolateProvider.endSymbol(']]');
	}
);

CourseCommunicator.config(['$routeProvider', function($routeProvider) {
	$routeProvider
		.when('/', {
			templateUrl: 'templates/feed.html',
		})
		.when('/filter/:filter', {
			templateUrl: 'templates/feed.html',
			controller: FilterCtrl
		})
		.otherwise({
			redirectTo: '/'
		});
}]);

// Feed Controller
var FeedCtrl = function($scope, $rootScope, $http, $location, $route, $routeParams) {
	$http.get('/api/get/posts/?format=json').success(function(data) {
		$scope.feed = data.objects;
	});
	
	/*$http.get('/api/get/tag/?format=json').success(function(data) {
		$scope.tags = data.objects;
		//$(".tagselect").html($scope.tags);
	});*/
}

// Filter Controller
var FilterCtrl = function($scope, $route, $routeParams) {
	$scope.filter = $routeParams.filter;
	$(".currentfilter").html($scope.filter);
}

// NewPost Controller
var newPostCtrl = function($scope) {
	$scope.taglist = $scope.tags;
}

// Custom (jQuery) Directives
CourseCommunicator.directive('hidePlusMinus', function() {
	return {
		restrict: 'E',
		link: function(scope, element, attrs) {
			element.parent().prev().hide();
		}
	}
});
CourseCommunicator.directive('replyPost', function() {
	return {
		restrict: 'E',
		link: function(scope, element, attrs) {
			element.children().autogrow();
		}
	}
});
CourseCommunicator.directive('togglePosts', function() {
	return {
		restrict: 'E',
		link: function(scope, element, attrs) {
			var button = element.children();
			button.click(function () {
				if(button.hasClass("icon-minus-sign")) {
					button.removeClass("icon-minus-sign");
					button.addClass("icon-plus-sign");
				} else {
					button.removeClass("icon-plus-sign");
					button.addClass("icon-minus-sign");
				}
			});
		}
	}
});
CourseCommunicator.directive('reldate', function() {
	return {
		restrict: 'A',
		link: function(scope, element, attrs) {
			element.attr("title", scope.this.post.pubdate);
			element.html(scope.this.post.pubdate);
			element.timeago();
		}
	}
});
CourseCommunicator.value('ui.config', {
	jq: {
		tooltip: {
			placement: 'left'
		}
	}
});