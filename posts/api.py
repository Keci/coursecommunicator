import datetime
from tastypie.authorization import *
from tastypie.authentication import BasicAuthentication
from tastypie import resources
from tastypie.resources import ModelResource
from tastypie.serializers import Serializer
from django.contrib.contenttypes.models import ContentType
from tastypie import fields
from tastypie.contrib.contenttypes.fields import GenericForeignKeyField
from tastypie.constants import ALL, ALL_WITH_RELATIONS
from posts.models import Post, Tag, PostTag, PostVote
from django.contrib.auth.models import User
from customuser.models import CustomUser
from course.models import Course
from challenge.models import MainChallenge
import urllib, hashlib

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

class MainChallengeObjResource(ModelResource):
	class Meta:
		queryset = MainChallenge.objects.all()
		resource_name = 'mainchallenge'

class CommAuthentication(BasicAuthentication):
    def __init__(self, *args, **kwargs):
        super(CommAuthentication, self).__init__(*args, **kwargs)

    def is_authenticated(self, request, **kwargs):
        return request.user.is_authenticated()

class UserResource(ModelResource):
	class Meta:
		queryset = CustomUser.objects.all()
		resource_name = 'user',
		excludes = ['last_login', 'password', 'date_joined', 'first_name', 'last_name', 'is_superuser', 'is_active', 'username']

	def dehydrate(self, bundle):
		bundle.data['gravatar_url'] = "http://www.gravatar.com/avatar/" + hashlib.md5(bundle.data['email'].lower()).hexdigest() + "?"
		bundle.data['gravatar_url'] += urllib.urlencode({'d':'identicon', 's':str(32)})
		return bundle
		
class TagResource(ModelResource):
	class Meta:
		queryset = Tag.objects.all()
		resource_name = 'tag'
		
class CourseResource(ModelResource):
	class Meta:
		queryset = Course.objects.all()
		resource_name = 'course'

class PostResource(ModelResource):
	username_id = fields.ForeignKey(UserResource, 'username', full=True)
	parentpost_id = fields.ForeignKey('self', 'parentpost', null=True)
	course = fields.ForeignKey(CourseResource, 'course', null=True)

	class Meta:
		queryset = Post.objects.all()
		resource_name = 'post'
		authentication = CommAuthentication()
		authorization = Authorization()
		always_return_data = True
		
	def obj_create(self, bundle, request, **kwargs):
		try:
			return super(PostResource, self).obj_create(
				bundle, 
				request, 
				username=CustomUser.objects.get(user_ptr_id=request.user), 
				content_type=ContentType.objects.get(model=bundle.data['content_type'])
			)
		except ContentType.DoesNotExist:
			return super(PostResource, self).obj_create(
				bundle, 
				request, 
				username=CustomUser.objects.get(user_ptr_id=request.user), 
			)
		
class PostTagResource(ModelResource):
	post = fields.ForeignKey(PostResource, 'post')
	tag = fields.ForeignKey(TagResource, 'tag', full=True)

	class Meta:
		queryset = PostTag.objects.all()
		resource_name = 'posttag'
		authentication = CommAuthentication()
		authorization = Authorization()

class PostVoteResource(ModelResource):
	post_id = fields.ForeignKey(PostResource, 'post')
	username_id = fields.ForeignKey(UserResource, 'username', full=True)
	
	class Meta:
		queryset = PostVote.objects.all()
		resource_name = 'postvote'
		authentication = CommAuthentication()
		authorization = Authorization()
		filtering = {
			'post_id': ('exact'),
			'username_id': ('exact')
		}
		
	def obj_create(self, bundle, request, **kwargs):
		return super(PostVoteResource, self).obj_create(bundle, request, username=CustomUser.objects.get(user_ptr_id=request.user))
		
class FeedResource(ModelResource):
	user = fields.ForeignKey(UserResource, 'username', full=True)
	replies = fields.ToManyField('self', attribute=lambda bundle: Post.objects.filter(parentpost=bundle.obj), null=True, full=True)
	tags = fields.ToManyField(PostTagResource, attribute=lambda bundle: PostTag.objects.filter(post_id=bundle.obj), null=True, full=True)
	course = fields.ForeignKey(CourseResource, 'course', full=True)
	content_object = GenericForeignKeyField({
        MainChallenge: MainChallengeObjResource
    }, 'content_object', null=True, full=True)
	
	class Meta:
		queryset = Post.objects.filter(parentpost__isnull=True).order_by('-pubdate')
		resource_name = 'feed'
		authentication = CommAuthentication()
		authorization = ReadOnlyAuthorization()
		excludes = ['parentpost']
		filtering = {
			'course': ('exact'),
		}
		
	def get_object_list(self, request):
		return super(FeedResource, self).get_object_list(request).filter(content_type__isnull=True)

class ChallengeResource(ModelResource):
	user = fields.ForeignKey(UserResource, 'username', full=True)
	replies = fields.ToManyField('self', attribute=lambda bundle: Post.objects.filter(parentpost=bundle.obj), null=True, full=True)
	course = fields.ForeignKey(CourseResource, 'course', full=True)
	content_object = GenericForeignKeyField({
        MainChallenge: MainChallengeObjResource
    }, 'content_object', null=True, full=True)
	
	class Meta:
		queryset = Post.objects.filter(parentpost__isnull=True).order_by('-pubdate')
		resource_name = 'mainchallengefeed'
		authentication = CommAuthentication()
		authorization = ReadOnlyAuthorization()
		excludes = ['parentpost']
		filtering = {
			'course': ('exact'),
			'object_id': ('exact'),
		}
		
	def get_object_list(self, request):
		return super(ChallengeResource, self).get_object_list(request).filter(content_type=ContentType.objects.get(model='mainchallenge').id)