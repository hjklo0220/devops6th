from django.contrib import admin

from forum.models import Post, Topic

# Register your models here.

@admin.register(Topic)
class TopicAdmin(admin.ModelAdmin):
    list_display = ["name", "owner", "created_at", "updated_at", "is_private"]


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    pass
    # list_display = ["*"]

