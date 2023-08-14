from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Topic(models.Model):
    name = models.TextField(max_length=128, unique=True)
    is_private = models.BooleanField(default=False)
    owner = models.ForeignKey(User, on_delete=models.PROTECT)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    posts:models.QuerySet["Post"] # IDE 타입힌트

    def __str__(self) -> str:
        return self.name


class Post(models.Model):
   topic = models.ForeignKey(Topic, on_delete=models.CASCADE, related_name="posts")
   title = models.TextField(max_length=200)
   owner = models.ForeignKey(User, on_delete=models.CASCADE)
   content = models.TextField()
   created_at = models.DateTimeField(auto_now_add=True)
   updated_at = models.DateTimeField(auto_now=True)

   def __str__(self) -> str:
       return self.title
