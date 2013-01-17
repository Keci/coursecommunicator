import datetime
from tastypie.authorization import Authorization
from tastypie.resources import ModelResource
from tastypie.serializers import Serializer
from tastypie import fields
from posts.models import Post, Tag, PostTag
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
		
class PostTagResource(ModelResource):
	tag = fields.ForeignKey(TagResource, 'tag', full=True)

	class Meta:
		queryset = PostTag.objects.all()
		resource_name = 'posttag'
		
class GetPostsResource(ModelResource):
	user = fields.ForeignKey(UserResource, 'username', full=True)
	replies = fields.ToManyField('self', attribute=lambda bundle: Post.objects.filter(parentpost=bundle.obj), null=True, full=True)
	tags = fields.ToManyField(PostTagResource, attribute=lambda bundle: PostTag.objects.filter(post_id=bundle.obj), null=True, full=True)
	
	class Meta:
		queryset = Post.objects.filter(parentpost__isnull=True)
		detail_allowed_methods = ['post', 'put', 'delete']
		resource_name = 'posts'
		#authorization = Authorization()
		excludes = ['parentpost']
	
	#def dehydrate(self, bundle):
	#	bundle.data['date'] = format_datetime(bundle.data['pubdate'])
	#	return bundle