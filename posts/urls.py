from django.conf.urls import patterns, include, url
from django.conf import settings
from django.contrib import admin
from tastypie.api import Api
from posts.api import *
admin.autodiscover()

#api = Api(api_name='posts')
#api.register(UserResource())
#api.register(TagResource())
#api.register(FeedResource())
#api.register(PostResource())
#api.register(PostTagResource())
#api.register(PostVoteResource())

urlpatterns = patterns('',
	url(r'^$', 'posts.views.index'),
	url(r'^templates/posts/feed.html/$', 'posts.views.feed', name='feed_url'),
	url(r'^templates/posts/feed_include.html/$', 'posts.views.feed_include', name='feed_include_url'),
	url(r'^templates/posts/rightbar.html/$', 'posts.views.rightbar', name='rightbar_url'),
	url(r'^templates/posts/header.html/$', 'posts.views.header', name='header_url'),
	#url(r'^api/', include(api.urls)),
	url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
	url(r'^admin/', include(admin.site.urls)),
	url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {
		'document_root': settings.STATIC_ROOT,
	})
)