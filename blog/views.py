from pymongo import MongoClient

client = MongoClient(host="mongo")
db=client.likelion


def create_blog(request) -> bool:
    blog = {
        "title": "My second blog",
        "content": "This is my second blog",
        "author": "lion",
    }
    try:
        db.blogs.insert_one(blog)
        return True
    except Exception as e:
        print(e)
        return False

def update_blog():
    pass

def delete_blog():
    pass

def read_blog():
    pass