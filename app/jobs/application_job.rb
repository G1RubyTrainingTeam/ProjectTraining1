class ApplicationJob < ActiveJob::Base
  queue_as :default

  def perform course
    notifications = []
    content = I18n.t("notification.create.content", name: course.user.name, course_name: course.name)
    course.user.followers.pluck(:id).each do |for_user_id|
      noti = {
        user_id: for_user_id,
        slug: course.slug,
        content: content
      }
      notifications << noti
    end
    Notification.create notifications
    ActionCable.server.broadcast 'notification_channel',
        user_follow: course.user.followers.pluck(:id),
        url: "<li><a href='/en/courses/#{course.slug}'>#{content}</a></li>"
  end
end
