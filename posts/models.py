from django.db import models

class Post(models.Model):
	parentpost = models.ForeignKey('self', blank=True, null=True)
	username = models.ForeignKey('users.User')
	pubdate = models.DateTimeField('Date')
	text = models.TextField()
	votes = models.IntegerField()
	goodpost = models.IntegerField()

class Tag(models.Model):
	name = models.CharField(max_length=50)

class PostTag(models.Model):
	post = models.ForeignKey('Post')
	tag = models.ForeignKey('Tag')
	
class PostVote(models.Model):
	post = models.ForeignKey('Post')
	username = models.ForeignKey('users.User')
	
