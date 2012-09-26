class IssuesController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :project, :through => :account
  load_and_authorize_resource :issue, :through => :project


  def index
    @issues = Issue.all
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def new
    @issue = @project.issues.build
    @call = @issue.calls.build
  end

  def create
    @issue = @project.issues.build(params[:issue])
    @issue.user = current_user
    if @issue.save
      respond_to do |format|
        format.html {
          redirect_to @issue, :notice => "Successfully created issue."
        }
        format.js {
          @issues = @project.issues.by_user(current_user).order('created_at DESC')
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
      end
    end
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      redirect_to @issue, :notice  => "Successfully updated issue."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to issues_url, :notice => "Successfully destroyed issue."
  end
end
