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
    @issue.valid?
    render :locals => {:issue => @issue, :existing_issues => nil}
  end

  def create
    @issue = @project.issues.build(params[:issue])
    @issue.user = current_user
    
    
    @existing_issues = Issue.where(:phone => @issue.phone).all
    logger.warn "PHONE = #{@issue.phone}"
    logger.warn "ISSUES = #{@existing_issues}"
    if @existing_issues.length > 0
      respond_to do |format|
        format.js {
          logger.warn "=========POINT 1==========#{@issue.errors[:phone]}"
          #но с сообщением об ошибке
          
          render :template => 'issues/new', :formats => [:js], :handler => [:js], :locals => {:issue => @issue, :existing_issues => @existing_issues}
          logger.warn(render_to_string(:template => 'issues/new', :formats => [:js], :handler => [:js]))
          return
        }
      end
    
    elsif @issue.save
      respond_to do |format|
        format.html {
          redirect_to account_project_issue_url(@account, @project, @issue), :notice => "Successfully created issue."
        }
        format.js {
          @issues = @project.issues.by_user(current_user).order('created_at DESC')
          render :action => 'edit'
        }
      end
      logger.warn "=========POINT 2==========="
    else
      respond_to do |format|
        format.js {
          render :action => 'new', :formats => [:js]
        }
      end
      logger.warn "=========POINT 3==========="
    end

    logger.warn "=========POINT 4==========="
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
