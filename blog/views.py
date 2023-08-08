from django.http import JsonResponse
from pymongo import MongoClient
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework import status

from .serializers import BlogSerializer


client = MongoClient(host="mongo")
db=client.likelion

class BlogViewSet(ViewSet):
    serializer_class = BlogSerializer

    def list(self, request):
        return Response()
    
    def create(self, request):
        serializer = BlogSerializer(data=request.data)
        if serializer.is_valid():
            serializer.create(serializer.validated_data)
            # serializer.save()
            return Response(status=status.HTTP_200_OK, data=serializer.data)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST, data=serializer.errors)


    def update(self, request):
        pass

    def retrieve(self, request):
        pass

    def destroy(self, request):
        pass


def create_blog(request) -> bool:
    blog = {
        "title": "My Third blog",
        "content": "This is my Third blog",
        "author": "lion",
    }
    try:
        db.blogs.insert_one(blog)
        return JsonResponse({'status': True})
    except Exception as e:
        print(e)
        return JsonResponse({'status': False})

def update_blog():
    pass

def delete_blog():
    pass

def read_blog():
    pass