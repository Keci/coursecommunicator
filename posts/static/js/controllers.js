$(document).ready(function () {
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
		},
		onchange: function($scope) {
			$("input[name=tagselect]").val($("select[name=tags]").val());
			$("input[name=tagselect]").removeClass("ng-pristine").addClass("ng-dirty");
			$("input[name=tagselect]").trigger("change");
		}
	});
		
	$(".optionselect").multiselect({
		button: 'btn btn-mini',
		text: function(options) {
			return "Options";
		}
	});
});

var CourseCommunicator = angular.module("CourseCommunicator", ['ui.directives', 'ngResource', 'ngSanitize'], 
	function ($interpolateProvider) {
		$interpolateProvider.startSymbol('[[');
		$interpolateProvider.endSymbol(']]');
	}
);

CourseCommunicator.filter('textfilter', function(){
	return function(text) {
		return text.replace(/\n/g, '<br/>');
	}
});

CourseCommunicator.config(['$routeProvider', function($routeProvider) {
	$routeProvider
		.when('/:order', {
			templateUrl: 'templates/feed.html',
			controller: FilterCtrl
		})
		.when('/:order/filter/:filter', {
			templateUrl: 'templates/feed.html',
			controller: FilterCtrl
		})
		.otherwise({
			redirectTo: '/new'
		});
}]);

CourseCommunicator.factory('feed', ['$resource', function($resource) {
  $resource('/api/posts/feed/?format=json');
}]);

// Feed Controller
var FeedCtrl = function($scope, $rootScope, $resource, $timeout, $routeParams) {
	$scope.orderlink = $(".nav-tabs li.active").attr("id");

	// Feed Resource
	var feedResource = $resource('/api/posts/:url',{
		url: '@url',
	},{
		query: 	{method: 'GET'},
		create:	{method: 'POST'},
		put:	{method: 'PUT'}
	});
	
	// PostTag Resource
	var posttagResource = $resource('/api/posts/posttag:url',{
		url: '@url',
	},{
		create:	{method: 'POST'},
		put:	{method: 'PUT'}
	});
	
	// PostVote Resource
	var postvoteResource = $resource('/api/posts/postvote:url',{
		query:	{method: 'GET'},
		create:	{method: 'POST'}
	});

	function resetForm(form) {
		if(form == "newPost") {
			$scope.newpost = {};
			$("#newPost select[name=tags] option").each(function () {
				$(this).attr('selected', false);
			});
			$("#newPost .btn-group input").each(function () {
				$(this).attr('checked', false);
			});
			$("#newPost .btn-group").first().children("button").html("Tags <b class='caret'></b>");
			$("#newPost li.active").each(function () {
				$(this).removeClass();
			});
			$(".tagselect").multiselect({
				text: "Tags"
			});
		} else if(form == "newReply") {
			$scope.newreply = {};
		}
	};
	
	// Get Feed by default (and update every 120s)
	function poll() {
		feedResource.get({url: 'feed/', format: 'json'}, function(data) {
			$scope.feed = data.objects;
		});
		$timeout(poll, 120000);
	};
	poll();

	// Submit new post
	$scope.submit = function(mode, parentpost) {
		var text = "";
		if(mode == "newPost") {
			text = $scope.newpost.text;
			parentpost = null;
		} else if(mode == "newReply") {
			text = $scope.newpost.replytext;
			parentpost = "/api/posts/post/" + parentpost + "/";
		}
		var data = ({
			"parentpost_id": parentpost,
			"username_id": "/api/posts/user/1/",
			"pubdate": new Date(),
			"text": text,
			"votes": 0,
			"goodpost": 0
		});
		// Post speichern
		feedResource.save({url: 'post/'}, data, function(datatmp) {
			// Post und Tags speichern (newPost)
			if(mode == "newPost") {
				var tagstmp = $scope.newpost.tags.split(",");
				for(var t in tagstmp) {
					posttagResource.save({url: '/'}, {
						"tag": "/api/posts/posttag/" + tagstmp[t] + "/",
						"post": "/api/posts/post/" + datatmp.id + "/"
					}, function() {
						$timeout(function()
						{
							$scope.feed = data.objects;
							resetForm("newPost");
							poll();
						}, 1000);
					});
				}
			// Nur Post speichern (newReply)
			} else if (mode == "newReply") {
				$timeout(function()
				{
					poll();
				}, 1000);
			}
		});
	};
	
	$scope.vote = function(mode, postid) {
		var votes = null;
		feedResource.get({url: 'post/' + postid + '/', format: 'json'}, function(data) {
			if(mode == "up") {
				votes = (data.votes+1);
			} else if(mode == "down") {
				votes = (data.votes-1);
				if(votes < 0)
				{
					votes = 0;
				}
			}
			
			postvoteResource.get({url: '/', format: 'json', 'post_id': postid, 'username_id': 1}, function(data) {
				if(data.meta.total_count > 0) {
					console.info("You already have voted for this post.");
				} else {
					feedResource.put({url: 'post/' + postid + '/'}, {
						"votes": votes
					}, function(data) {
						postvoteResource.save({url: '/'}, {
							"post_id": "/api/posts/post/" + postid + "/",
							"username_id": "/api/posts/user/1/"
						}, function(data) {
							$timeout(function()
							{
								$scope.feed = data.objects;
								poll();
							}, 1000);
						});
					});
				}
			});
		});
	};
	
	$scope.editPost = function(post, $event) {
		$($event.target.parentElement.parentElement.parentElement).children(".text")
			.prop("contenteditable", true)
			.addClass("textareadiv editpost");
	};
}

// Filter Controller
var FilterCtrl = function($scope, $rootScope, $route, $routeParams) {
	$scope.filter = $routeParams.filter;
	$scope.ordertmp = $routeParams.order;
	$(".currentfilter").html($scope.filter);

	if($routeParams.order == "") {
		$scope.order = "pubdate";
	} else if($routeParams.order == "hot") {
		$scope.order = "votes";
	}
	
	$(".nav-tabs li").removeClass();
	$(".nav-tabs li#" + $routeParams.order).addClass("active");
	
	$(".filterlink").each(function() {
		var currentlink = $(this).children("a").attr("href");
		var part = currentlink.split("/filter/");
		var newlink = "/#/" + $routeParams.order + "/filter/" + part[1];
		$(this).children("a").attr("href", newlink);
	});
}

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
CourseCommunicator.directive('hidePlusMinus', function() {
	return {
		restrict: 'E',
		link: function(scope, element, attrs) {
			element.parent().parent().find("i").hide();
		}
	}
});
CourseCommunicator.directive('reldate', function() {
	return {
		restrict: 'A',
		link: function(scope, element, attrs) {
			if(attrs.reldate == "post") {
				element.attr("title", scope.this.post.pubdate);
				element.html(scope.this.post.pubdate);
			} else if(attrs.reldate == "reply") {
				element.attr("title", scope.this.reply.pubdate);
				element.html(scope.this.reply.pubdate);
			}
			element.timeago();
		}
	}
});
CourseCommunicator.directive('contenteditable', function() {
    return {
		restrict: 'A',
		require: '?ngModel',
		link: function(scope, element, attrs, ngModel) {
			if(!ngModel) return;
			 
			ngModel.$render = function() {
				element.html(ngModel.$viewValue || '');
			};
			 
			element.bind('blur keyup change', function() {
				scope.$apply(read);
			});
			read();
			 
			function read() {
				ngModel.$setViewValue(element.html().replace(/<br>/g,"\n").trim());
			}
		}
    }
});
CourseCommunicator.directive('editpost', function() {
    return {
		restrict: 'A',
		require: '?ngModel',
		link: function(scope, element, attrs, ngModel) {
			element.parent().find(".icon-pencil").click(function () {
				if(scope.editPost == "true") {
					console.info("test");
				} else {
					console.info("test2");
				}
				console.info(scope.editPost);
			});
			
			
			
			/*if(!ngModel) return;
			 
			ngModel.$render = function() {
				element.html(ngModel.$viewValue || '');
			};
			 
			element.bind('blur keyup change', function() {
				scope.$apply(read);
			});
			read();
			 
			function read() {
				ngModel.$setViewValue(element.html().replace(/<br>/g,"\n").trim());
			}*/
		}
    }
});
CourseCommunicator.directive('tagselecttmp', function() {
    return {
		restrict: 'A',
		link: function(scope, element, attrs) {
			element.change(function () {
				scope.$apply(function () {
					scope.newpost.tags = element.val();
				});
			});
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