class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project
  before_action :authenticate_user!

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @project.tasks.create(task_params)

    respond_to do |format|
      if @task.save
        (@project.users.uniq - [current_user]).each do |user|
          if user.notify_when_task_created?
            TaskMailer.with(task: @task, user: user, author: current_user).task_created.deliver_later
          end
        end
        format.html { redirect_to project_path(@project), notice: 'Task was successfully created.' }
      else
        format.html { redirect_to project_path(@project) }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = @project.tasks.find(params[:task][:id])
    respond_to do |format|
      if params[:task][:complete] == true
        @task.update(complete: true)
      end

      if @task.update(task_params)
          (@project.users.uniq - [current_user]).each do |user|
            if user.notify_when_task_completed?
              TaskMailer.with(task: @task, user: user, author: current_user).task_completed.deliver_later
            end
          end
        format.json { render :show, status: :ok, location: project_path(@project)}
      else
        format.html { redirect_to project_path(@project) }

      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:id, :body, :project_id, :complete)
    end
end
