require 'json'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]
  protect_from_forgery except: :create

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if params[:name]
      @project = Project.where(name: "#{params[:name]}").first
    else
      set_project
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create

    begin

      if params[:access_token]
      #   # get name and email by GitHub API with access_token
        client = Octokit::Client.new(access_token: params[:access_token])
        user = client.user
        name = user.login

        # if user with this name not exists...
        @user = User.where(name: name).first
        if @user.blank?
          @user = User.create(name: name)
        end

        project_json = JSON.parse(params[:project])
        project_name = project_json['name']
        project_data = JSON.pretty_generate(project_json['data'])

        @project = @user.project.build(name: project_name, data: project_data)
        @project.name = @project.name.delete(" ")

        # JSON.parse project data and create nodes and links
        # nodes -> node_ids, links -> link_ids
        # check if node and link already exists
        # (node unique parameter : name && author && year)
        # (link unique parameter : refering node id && referred node id)
        # create node and link only when it not exists
        # update node_ids and link_ids

        if @project.save # auto check if project uniqueness ?
          @success = true
        else
          @success = false
        end
      else
        @success = false
      end
    rescue => e
      @success = false
    end

  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :data)
    end

end
