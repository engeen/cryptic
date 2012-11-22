class IssuesController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :project, :through => :account
  load_and_authorize_resource :issue, :through => :project


  def index
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
    
    
    @existing_issues = @account.issues.where(:phone => @issue.phone).all
    logger.warn "PHONE = #{@issue.phone}"
    logger.warn "ISSUES = #{@existing_issues}"
    if @existing_issues.length > 0
      respond_to do |format|
        format.js {
          logger.warn "=========POINT 1==========#{@issue.errors[:phone]}"
          #но с сообщением об ошибке
          
          logger.warn "=====existing issues count: #{ @existing_issues.count}"
          if @existing_issues.count == 1
            @issue = @existing_issues.first
            @issue.valid?
            logger.warn "=========POINT 2=========="
            render :action => 'edit'
          else
            logger.warn(render_to_string(:template => 'issues/new', :formats => [:js], :handler => [:js]))
            render :action => 'new'
          end
          
        }
      end
    
    elsif @issue.save
      respond_to do |format|
        format.html {
          redirect_to account_project_issue_url(@account, @project, @issue), :notice => "Successfully created issue."
        }
        format.js {
          @issues = @project.issues.by_user(current_user).order('created_at DESC')
          params[:focus] = "issue_source"
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
    @issue.calls.build() if params[:new_call]=="1"
    @issue.valid?
  end

  def update
    @issue = Issue.find(params[:id])
    params[:issue][:calls_attributes].each do |k,v|
      params[:issue][:calls_attributes][k][:next_date] = Chronic.parse(v[:next_date]).to_s
      params[:issue][:calls_attributes][k][:meeting_date] = Chronic.parse(v[:meeting_date]).to_s
      logger.warn "DATETIME TRANSFORM next_date: #{params[:issue][:calls_attributes][k][:next_date]}"
      logger.warn "DATETIME TRANSFORM meeting_date: #{params[:issue][:calls_attributes][k][:meeting_date]}"
    end if params[:issue][:calls_attributes]
    
    if @issue.update_attributes(params[:issue])
      #successfully updated
      render :action => 'edit'
    else
      logger.warn "============== But the call.result in issue is #{@issue.calls.last.result if @issue.calls.last}"
      render :action => 'edit'
    end
    logger.warn "ISSUE VALIDATION: ============== #{@issue.errors.keys.join(", ")}"
    logger.warn "ISSUE VALIDATION: =======current meeting_date #{@issue.calls.last.meeting_date if @issue.calls.last}"
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to issues_url, :notice => "Successfully destroyed issue."
  end
end
