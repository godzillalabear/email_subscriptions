class EmailsController < ApplicationController
  def unsubscribe
    user = User.find_by_unsubscribe_hash(params[:unsubscribe_hash])

    case params[:subscription]
      when "user_added_to_project"
        @reason = "being added to project"
        user.update(notify_when_added_to_project: false)
      when "task_created"
        @reason = "new tasks"
        user.update(notify_when_task_created: false)
      when "task_completed"
        @reason = "completing task"
        user.update(notify_when_task_completed: false)
    end
  end
end
