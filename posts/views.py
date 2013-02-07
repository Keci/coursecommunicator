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

def index(request):
	return render(request, 'index.html', 
		{
			'taglist': Tag.objects.all(),
			'taglist_json': serialize('json', Tag.objects.all())
		}
	)

def feed(request):
	return render(request, 'feed.html')
	
def rightbar(request):
	return render(request, 'rightbar.html')
	
def header(request):
	return render(request, 'header.html')
