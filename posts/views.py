from posts.models import Post
from posts.models import Tag
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.contrib.auth import login
from django.template import Context, loader
from django.core import serializers
from django.core.serializers import serialize
from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from customuser.models import *
from course.models import *
from django.http import HttpResponseRedirect
from customdecorator.decorators import *
from homepage.points import  PointsDetail

@login_required()
@course_permission()
def index(request, course_short_title):
	return render(request, 'main.html', 
		{
			'username':request.user.username,
			'course_short_title':course_short_title,
			'course_id':Course.objects.get(short_title=course_short_title).id,
			'taglist': Tag.objects.all(),
			'taglist_json': serialize('json', Tag.objects.all())
		}
	)

@login_required()
@course_permission()
def feed(request, course_short_title):
	return render(request, 'feed.html',
		{
			'username':request.user.username,
			'course_short_title':course_short_title
		}
	)
	
def rightbar(request, course_short_title):
	return render(request, 'rightbar.html')
	
def header(request, course_short_title):
	return render(request, 'header.html')
