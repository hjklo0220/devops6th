from django.http import JsonResponse
from pymongo import MongoClient

client = MongoClient(host="mongo")
db=client.likelion


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