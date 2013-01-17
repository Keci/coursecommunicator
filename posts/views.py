from posts.models import Post
from posts.models import Tag
from django.template import Context, loader
from django.core import serializers
from django.http import HttpResponse

def index(request):
	template = loader.get_template('index.html')
	context = Context({
		'taglist': Tag.objects.all()
	})
	return HttpResponse(template.render(context))

def feed(request):
	template = loader.get_template('feed.html')
	context = Context({'url':'test'})
	return HttpResponse(template.render(context))
	
def detail(request, post_id):
	return HttpResponse("You're looking at post %s." % post_id)
	
def GetPosts(request, **kwargs):
	items = Post.objects.all()
	items = serializers.serialize('json', items, indent=4)
	return HttpResponse(items, mimetype='application/json')
