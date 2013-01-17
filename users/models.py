from django.db import models

class Avatar(models.Model):
	cssclass = models.CharField(max_length=1)

class User(models.Model):
	name = models.CharField(max_length=30)
	avatar = models.ForeignKey('Avatar')
	email = models.EmailField()
	statement = models.TextField()
