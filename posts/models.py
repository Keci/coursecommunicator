from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes import generic

class Post(models.Model):
	parentpost = models.ForeignKey('self', blank=True, null=True)
	username = models.ForeignKey('customuser.CustomUser')
	course = models.ForeignKey('course.Course', null=True)
	pubdate = models.DateTimeField('Date')
	text = models.TextField()
	votes = models.IntegerField()
	goodpost = models.IntegerField()
	limit = models.Q(app_label = 'challenge', model = 'mainchallenge') | models.Q(app_label = 'team', model = 'teamuserrelation')
	content_type = models.ForeignKey(
		ContentType, 
		limit_choices_to = limit,
		null=True,
		blank=True
	)
	object_id = models.PositiveIntegerField(null=True)
	content_object = generic.GenericForeignKey('content_type', 'object_id')

class Tag(models.Model):
	name = models.CharField(max_length=50)

class PostTag(models.Model):
	post = models.ForeignKey('Post')
	tag = models.ForeignKey('Tag')
	
class PostVote(models.Model):
	post = models.ForeignKey('Post')
	username = models.ForeignKey('customuser.CustomUser')
	
