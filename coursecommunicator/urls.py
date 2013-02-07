from django.conf.urls import patterns, include, url
from django.conf import settings
from django.contrib import admin
from tastypie.api import Api
from posts.api import *
admin.autodiscover()

api = Api(api_name='posts')
api.register(AvatarResource())
api.register(UserResource())
api.register(TagResource())
api.register(PostTagResource())
api.register(FeedResource())
api.register(PostResource())
api.register(PostVoteResource())

urlpatterns = patterns('',
	url(r'^$', 'posts.views.index'),
	url(r'^templates/feed.html/$', 'posts.views.feed', name='feed_url'),
	url(r'^templates/rightbar.html/$', 'posts.views.rightbar', name='rightbar_url'),
	url(r'^templates/header.html/$', 'posts.views.header', name='header_url'),
	url(r'^api/', include(api.urls)),
	url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
	url(r'^admin/', include(admin.site.urls)),
	url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {
		'document_root': settings.STATIC_ROOT,
	})
)