from posts.models import Post
from posts.models import Tag
from posts.models import PostTag
from django.contrib import admin

class PostAdmin(admin.ModelAdmin):
	list_display = ('pk', 'pubdate', 'user', 'text', 'parent')
	
	def user(self, obj):
		return '%s'%(obj.username.name)
		
	def parent(self, obj):
		return '%s'%(obj.parentpost.pk)

admin.site.register(Post, PostAdmin)
admin.site.register(Tag)
admin.site.register(PostTag)