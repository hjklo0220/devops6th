from django.db import models
from django.contrib.auth.models import User


# Create your models here.
class Topic(models.Model):
    name = models.TextField(max_length=128, unique=True)
    is_private = models.BooleanField(default=False)
    owner = models.ForeignKey(User, on_delete=models.PROTECT)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    posts: models.QuerySet["Post"]  # IDE 타입힌트
    members: models.QuerySet["TopicGroupUser"]

    def __str__(self) -> str:
        return self.name

    def can_be_access_by(self, user: User):
        if (
            not self.is_private
            or self.owner == user
            or self.members.filter(user=user).exists()
        ):
            return True
        return False


class Post(models.Model):
    topic = models.ForeignKey(Topic, on_delete=models.CASCADE, related_name="posts")
    title = models.TextField(max_length=200)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    image_url = models.URLField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self) -> str:
        return self.title


class TopicGroupUser(models.Model):
    class GroupChoices(models.IntegerChoices):
        common = 0
        admin = 1

    topic = models.ForeignKey(Topic, on_delete=models.CASCADE, related_name="members")
    group = models.IntegerField(default=0, choices=GroupChoices.choices)
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.topic} | {self.GroupChoices.choices} | {self.user}"
