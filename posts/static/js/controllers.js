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

CourseCommunicator.factory("Constants", function(DjangoConstants) {
  var constants = {};
  angular.extend(constants, DjangoConstants);
 
  return {
    get: function(key) {
      return constants[key];
    },
    all: function() {
      return constants;
    }
  };
});

CourseCommunicator.filter('textfilter', function(){
	return function(text) {
		return text.replace(/\n/g, '<br/>');
	}
});

CourseCommunicator.config(['$routeProvider', function($routeProvider) {
	var course_short_name = window.location.pathname.replace(/^\/([^\/]*).*$/, '$1');
	$routeProvider
		.when('/:order', {
			templateUrl: '/' + course_short_name + '/feed/templates/posts/feed.html',
			controller: FilterCtrl
		})
		.when('/:order/filter/:filter', {
			templateUrl: '/' + course_short_name + '/feed/templates/posts/feed.html',
			controller: FilterCtrl
		})
		.when('/:order/content/:contenttype/:contentobj', {
			templateUrl: '/' + course_short_name + '/feed/templates/posts/feed_include.html',
			controller: FeedCtrl
		})
		.otherwise({
			redirectTo: '/new'
		});
}]);

/*CourseCommunicator.factory('feed', ['$resource', function($resource) {
  $resource('/api/posts/feed/?format=json');
}]);*/

// Feed Controller
var FeedCtrl = function($scope, $rootScope, $resource, $timeout, $location, $routeParams, Constants) {
	$scope.c = Constants.all();
	$scope.orderlink = $(".nav-tabs li.active").attr("id");
	
	$scope.contenttype = $routeParams.contenttype;
	$scope.contentobj = $routeParams.contentobj;
	
	if($scope.contenttype == "mainchallenge") {
		//$("div[challenge_id=" + $scope.contentobj + "]").trigger("click");
	}

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
		if(typeof $scope.contenttype === 'undefined') {
			if(typeof $scope.c.path_name === 'undefined') {
				$scope.loading=true;
				feedResource.get(
					{
						url: 'feed/', 
						format: 'json', 
						course: $scope.c.course_id
					}, function(data) {
						$scope.feed = data.objects;
						$scope.loading=false;
					}
				);
			} else {
				$(".comments").hide();
				return;
			}
		} else {
			$(".comments").show();
			$scope.loading=true;
			feedResource.get(
				{
					url: $scope.contenttype + 'feed/', 
					format: 'json', 
					course: $scope.c.course_id, 
					object_id: $scope.contentobj
				}, function(data) {
					$scope.feed = data.objects;
					$scope.loading=false;
				}
			);
		}
		$timeout(poll, 120000);
	};
	poll();

	// Submit new post
	$scope.submit = function(mode, parentpost) {
		var contenttype = null;
		var contentobj = null;
		
		// Determine contenttype and contentobj
		var location = $location.path().split("content/");
		if(typeof location[1] != 'undefined') {
			location = location[1].split("/");
			contenttype = location[0];
			contentobj = location[1];
		}
		
		var text = "";
		if(mode == "newPost") {
			text = $scope.newpost.text;
			parentpost = null;
		} else if(mode == "newReply") {
			text = $scope.newpost.replytext;
			parentpost = "/api/posts/post/" + parentpost + "/";
		}
		// If content type is available (i.e. not standard feed)
		if(typeof $scope.contenttype != 'undefined') {
			content_type = $scope.contenttype;
			object_id = $scope.contentobj;
		}
		var data = ({
			"parentpost_id": parentpost,
			//"username_id": "/api/posts/user/1/",
			"course": "/api/posts/course/" + $scope.c.course_id + "/",
			"pubdate": new Date(),
			"text": text,
			"votes": 0,
			"goodpost": 0,
			"content_type": contenttype,
			"object_id": contentobj
		});
		// Post speichern
		feedResource.save({url: 'post/'}, data, function(datatmp) {
			// Post und Tags speichern (newPost)
			// only for standard feed
			if(mode == "newPost") {
				if(typeof $scope.newpost.tags != 'undefined') {
					var tagstmp = $scope.newpost.tags.split(",");
					for(var t in tagstmp) {
						posttagResource.save({url: '/'}, {
							"tag": "/api/posts/posttag/" + tagstmp[t] + "/",
							"post": "/api/posts/post/" + datatmp.id + "/"
						}, function() {
							$timeout(function()
							{
								resetForm("newPost");
								poll();
							}, 1000);
						});
					}
				} else {
					$timeout(function()
					{
						resetForm("newPost");
						poll();
					}, 1000);
				}
			// Nur Post speichern (newReply)
			} else if (mode == "newReply") {
				$timeout(function()
				{
					resetForm("newPost");
					poll();
				}, 1000);
			}
		});
	};
	
	$scope.vote = function(mode, postid) {
		$scope.loading=true;
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
			
			postvoteResource.get({url: '/', format: 'json', 'post_id': postid, 'username_id': $scope.c.user_id}, function(data) {
				if(data.meta.total_count > 0) {
					console.info("You already have voted for this post.");
				} else {
					feedResource.put({url: 'post/' + postid + '/'}, {
						"votes": votes
					}, function(data) {
						postvoteResource.save({url: '/'}, {
							"post_id": "/api/posts/post/" + postid + "/",
							//"username_id": "/api/posts/user/1/"
						}, function(data) {
							$timeout(function()
							{
								//$scope.feed = data.objects;
								poll();
							}, 1000);
						});
					});
				}
			});
		});
		$scope.loading=false;
	};
	
	$scope.editPost = function(post, $event) {
		$($event.target.parentElement.parentElement.parentElement).children(".text")
			.prop("contenteditable", true)
			.addClass("textareadiv editpost");
	};
}

// Filter Controller
var FilterCtrl = function($scope, $rootScope, $route, $routeParams, Constants) {
	$scope.filter = $routeParams.filter;
	if(typeof $scope.filter === 'undefined'){
		$(".currentfilter").html("all");
	} else {
		$(".currentfilter").html($scope.filter);
	}
	$scope.ordertmp = $routeParams.order;

	if($routeParams.order == "") {
		$scope.order = "pubdate";
	} else if($routeParams.order == "hot") {
		$scope.order = "votes";
	}
	
	$scope.c = Constants.all();
	
	$(".nav-tabs li").removeClass();
	$(".nav-tabs li#" + $routeParams.order).addClass("active");
	
	$(".filterlink").each(function() {
		var currentlink = $(this).children("a").attr("href");
		var part = currentlink.split("/filter/");
		var newlink = "/" + $scope.c.course_short_title + "/feed" + "/#/" + $routeParams.order + "/filter/" + part[1];
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