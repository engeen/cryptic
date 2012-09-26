class ProjectsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :through => :account
  

  
  
  def index
    @projects = current_account.projects.by_user(current_user)
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new

  end

  def create
    
    @project = @account.projects.build(params[:project])
    
    #if I create project - I'm a manager!
    @project.users_projects.build(:user_id => current_user.id, :role => :manager)
    if @project.save
      redirect_to account_project_url(@account, @project), :notice => "Successfully created project."
    else
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to account_project_url(@account, @project), :notice  => "Successfully updated project."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to account_projects_url(@account), :notice => "Successfully destroyed project."
  end
  
  

  def current_account
    @account
  end
  
  
  
end
