import datetime
from tastypie.authorization import *
from tastypie.authentication import BasicAuthentication
from tastypie import resources
from tastypie.resources import ModelResource
from tastypie.serializers import Serializer
from tastypie import fields
from tastypie.constants import ALL, ALL_WITH_RELATIONS
from posts.models import Post, Tag, PostTag, PostVote
from users.models import User, Avatar

def format_datetime(self):
	data = self.replace(tzinfo=None)
	diff = datetime.datetime.utcnow() - data
	s = diff.seconds
	if diff.days > 7 or diff.days < 0:
		return data.strftime('%d %b %y')
	elif diff.days == 1:
		return '1d ago'
	elif diff.days > 1:
		return '{}d ago'.format(diff.days)
	elif s <= 1:
		return 'just now'
	elif s < 60:
		return '{}s ago'.format(s)
	elif s < 120:
		return '1m ago'
	elif s < 3600:
		return '{}m ago'.format(s/60)
	elif s < 7200:
		return '1h ago'
	else:
		return '{}h ago'.format(s/3600)

class AvatarResource(ModelResource):
	class Meta:
		queryset = Avatar.objects.all();
		resource_name = 'avatar'
		excludes = ['id']

class UserResource(ModelResource):
	avatar = fields.ForeignKey(AvatarResource, 'avatar', null=True, full=True)

	class Meta:
		queryset = User.objects.all()
		resource_name = 'user'

class TagResource(ModelResource):
	class Meta:
		queryset = Tag.objects.all()
		resource_name = 'tag'

class PostResource(ModelResource):
	username_id = fields.ForeignKey(UserResource, 'username')
	parentpost_id = fields.ForeignKey('self', 'parentpost', null=True)

	class Meta:
		queryset = Post.objects.all()
		resource_name = 'post'
		authentication = BasicAuthentication()
		authorization = Authorization()
		always_return_data = True
		
class PostTagResource(ModelResource):
	tag = fields.ForeignKey(TagResource, 'tag', full=True)
	post = fields.ForeignKey(PostResource, 'post')

	class Meta:
		queryset = PostTag.objects.all()
		resource_name = 'posttag'
		authentication = BasicAuthentication()
		authorization = Authorization()
		
class FeedResource(ModelResource):
	user = fields.ForeignKey(UserResource, 'username', full=True)
	replies = fields.ToManyField('self', attribute=lambda bundle: Post.objects.filter(parentpost=bundle.obj), null=True, full=True)
	tags = fields.ToManyField(PostTagResource, attribute=lambda bundle: PostTag.objects.filter(post_id=bundle.obj), null=True, full=True)
	
	class Meta:
		queryset = Post.objects.filter(parentpost__isnull=True).order_by('-pubdate')
		resource_name = 'feed'
		authentication = BasicAuthentication()
		authorization = ReadOnlyAuthorization()
		excludes = ['parentpost']
		
class PostVoteResource(ModelResource):
	post_id = fields.ForeignKey(PostResource, 'post')
	username_id = fields.ForeignKey(UserResource, 'username')
	
	class Meta:
		queryset = PostVote.objects.all()
		resource_name = 'postvote'
		authentication = BasicAuthentication()
		authorization = Authorization()
		filtering = {
			'post_id': ('exact'),
			'username_id': ('exact')
		}