from django.conf.urls import patterns, include, url
from django.conf import settings
from django.contrib import admin
from tastypie.api import Api
from posts.api import GetPostsResource, TagResource, PostTagResource, AvatarResource, UserResource
admin.autodiscover()

api = Api(api_name='get')
api.register(AvatarResource())
api.register(UserResource())
api.register(TagResource())
api.register(PostTagResource())
api.register(GetPostsResource())

urlpatterns = patterns('',
	url(r'^$', 'posts.views.index'),
	url(r'^templates/feed.html/$', 'posts.views.feed'),
	url(r'^test/posts/', 'posts.views.GetPosts'),
	url(r'^api/', include(api.urls)),
	url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
	url(r'^admin/', include(admin.site.urls)),
	url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {
		'document_root': settings.STATIC_ROOT,
	})
)