from rest_framework import serializers

from .models import Topic, Post
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id"]


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = "__all__"
        read_only_fields = (
            "id",
            "owner",
            "created_at",
            "updated_at",
        )


class PostUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = (
            "id",
            "topic",
            "title",
            "content",
            "image",
            "owner",
            "created_at",
            "updated_at",
        )
        read_only_fields = (
            "id",
            "owner",
            "created_at",
            "updated_at",
        )

    image = serializers.ImageField(required=False)


class TopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Topic
        fields = (
            "id",
            "name",
            "is_private",
            "owner",
            "created_at",
            "updated_at",
            "posts",
        )
        read_only_fields = (
            "id",
            "created_at",
            "updated_at",
            "owner",
        )

    posts = serializers.SerializerMethodField()

    def get_posts(self, obj: Topic):
        posts = obj.posts.all()
        return PostSerializer(posts, many=True).data

        # return Post.objects.filter(topic=obj)
