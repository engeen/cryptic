class ProjectsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :through => :account
  
  def index
    @projects = current_account.projects.by_user(current_user)
  end
  
  
  def rating
    
    case params[:rating]
    when "number_of_calls"
      @data = @project.users.select("users.id as id, count(calls.id) as data_field").joins(:calls).group("users.id").order("data_field DESC").as_json
    when "cold_calls"
      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.source = ?", :cold).order("data_field DESC").as_json
    when "recomm_calls"
      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.source = ?", :recommendation).order("data_field DESC").as_json
    when "retry_calls"
      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.source = ?", :retry).order("data_field DESC").as_json
    when "meetings_count"
      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.result = ?", :meeting).order("data_field DESC").as_json
    when "refusal_count"
      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.result = ?", :refusal).order("data_field DESC").as_json
    when "noanswer_count"
      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.result = ?", :noanswer).order("data_field DESC").as_json
#    when "calls_count2"
#      @data = @project.users.select("users.id as id, count(issues.id) as data_field").joins(:issues).group("users.id").where("issues.result = ?", :noanswer).order("data_field DESC").as_json
    end
    
  end

  def show
    
    if current_user.manager?(@project)
      @stats = []
      user_filter = params[:operator_id].to_i > 0 ?  ["issues.user_id = ?", params[:operator_id]] : "1=1"
      calls_user_filter = params[:operator_id].to_i > 0 ?  ["calls.user_id = ?", params[:operator_id]] : "1=1"
      
      issues_date_filter = case params[:period]
      when "day"
        ["issues.created_at > ?", Date.today]
      when "yesterday"
        ["issues.created_at > ? AND issues.created_at < ?", Date.yesterday, Date.today]
      when "week"
        ["issues.created_at > ? AND issues.created_at < ?", 7.days.ago, Date.today]
      when "all"
        "1=1"
      else
        "1=1"
      end 


      calls_date_filter = case params[:period]
      when "day"
        ["calls.created_at > ?", Date.today]
      when "yesterday"
        ["calls.created_at > ? AND calls.created_at < ?", Date.yesterday, Date.today]
      when "week"
        ["calls.created_at > ? AND calls.created_at < ?", 7.days.ago, Date.today]
      when "all"
        "1=1"
      else
        "1=1"
      end 
      
      logger.warn "DEFAULT LOCALE: #{I18n.default_locale}"

      total_calls_count = @project.calls.where(calls_user_filter).where(calls_date_filter).count
      stat = {:title => :number_of_calls, :value => total_calls_count, :percentage => nil}
      @stats.push(stat)
      
      if total_calls_count > 0 
        cold_calls_count = @project.issues.by_source(:cold).where(user_filter).where(issues_date_filter).count
        stat = {:title => :cold_calls, :value => cold_calls_count, :percentage => (cold_calls_count*100 / total_calls_count) }
        @stats.push(stat)

        recomm_calls_count = @project.issues.by_source(:recommendation).where(user_filter).where(issues_date_filter).count
        stat = {:title => :recomm_calls, :value => recomm_calls_count, :percentage => (recomm_calls_count*100 / total_calls_count) }
        @stats.push(stat)

        retry_calls_count = @project.issues.by_source(:retry).where(user_filter).where(issues_date_filter).count
        stat = {:title => :retry_calls, :value => retry_calls_count, :percentage => (retry_calls_count*100 / total_calls_count) }
        @stats.push(stat)


        meetings_count = @project.issues.where(:result => :meeting).where(user_filter).where(issues_date_filter).count
        stat = {:title => :meetings_count, :value => meetings_count, :percentage => (meetings_count*100 / total_calls_count) }
        @stats.push(stat)


        refusal_count = @project.issues.where(:result => :refusal).where(issues_date_filter).where(user_filter).count
        stat = {:title => :refusal_count, :value => refusal_count, :percentage => (refusal_count*100 / total_calls_count) }
        @stats.push(stat)

        #Issues или Calls  ? Возможно имеет смысл ввести делитель total_issues_count
        noanswer_count = @project.issues.where(:result => :noanswer).where(issues_date_filter).where(user_filter).count
        stat = {:title => :noanswer_count, :value => noanswer_count, :percentage => (noanswer_count*100 / total_calls_count) }
        @stats.push(stat)

        calls_count2 = @project.issues.includes(:calls).where(:result => [:meeting, :redial]).group("issues.id").where(issues_date_filter).where(user_filter).having("count(calls.id) = ?", 2).count
        stat = {:title => :calls_count2, :value => calls_count2.count, :percentage => (calls_count2.count*100 / total_calls_count) }
        @stats.push(stat)
      
        calls_count3 = @project.issues.includes(:calls).where(:result => [:meeting, :redial]).group("issues.id").where(issues_date_filter).where(user_filter).having("count(calls.id) = ?", 3).count
        stat = {:title => :calls_count3, :value => calls_count3.count, :percentage => (calls_count3.count*100 / total_calls_count) }
        @stats.push(stat)

        instant_refusal_count = @project.calls.unscoped.where(:reaction => :instant_refusal).group("calls.issue_id").where(calls_date_filter).where(calls_user_filter).count.count
        stat = {:title => :instant_refusal_count, :value => instant_refusal_count, :percentage => (instant_refusal_count*100 / total_calls_count) }
        @stats.push(stat)

        cantspeak_count = @project.calls.where(:reaction => :cant_speak).group("calls.issue_id").where(calls_date_filter).where(calls_user_filter).count.count
        stat = {:title => :cantspeak_count, :value => cantspeak_count, :percentage => (cantspeak_count*100 / total_calls_count) }
        @stats.push(stat)


        listening_count = @project.calls.where(:reaction => :listening).group("calls.issue_id").where(calls_date_filter).where(calls_user_filter).count.count
        stat = {:title => :listening_count, :value => listening_count, :percentage => (listening_count*100 / total_calls_count) }
        @stats.push(stat)


        asking_interest_count = @project.calls.where(:reaction => [:asking, :interest]).where(calls_date_filter).where(calls_user_filter).group("calls.issue_id").count.count
        stat = {:title => :asking_interest_count, :value => asking_interest_count, :percentage => (asking_interest_count*100 / total_calls_count) }
        @stats.push(stat)


        overlimit_count = @project.issues.includes(:calls).where(issues_date_filter).where(user_filter).group("issues.id").having("count(calls.id) > ?", 3).count.count
        stat = {:title => :overlimit_count, :value => overlimit_count, :percentage => (overlimit_count*100 / total_calls_count) }
        @stats.push(stat)
      end

      
    else

      @show_title = false
      
      
      @issues = @project.issues.by_user(current_user)
      case params[:show]
      when "meeting" 
        @issues = @issues.where(:result => :meeting)
      when "redial"
        @issues = @issues.where(:result => [:redial, :noanswer])
      when "urgent"
        @issues = @issues.where(:result => :redial).includes(:calls).where("calls.next_date < ?",
          5.minutes.ago)
      when "today"
        @issues = @issues.where(:result => :redial).includes(:calls).where("calls.next_date >= :start_date AND calls.next_date <= :end_date",
          {:start_date => Date.today, :end_date => Date.tomorrow})
      when "refuse"
        @issues = @issues.where(:result => :refusal)
      when "reminders"
        # в отчете по напоминалкам: 2 цифры - назначено и сделано
        @issues = @issues.where(:result => :meeting).includes(:calls).where(:result => :meeting).where("calls.meeting_date > ?", Date.tomorrow).where("issues.created_at < ?", Date.today).having("count(calls.id) < 2")
      end
      
      #current_issue
      @issue = @project.issues.build
      @issue.valid?
      
      load_issues
    end
    
    

  end
  
  
  def issues
    load_issues
    render :layout => false
  end
  
  def load_issues
    @issues = @project.issues.by_user(current_user)
    case params[:show]
    when "meeting" 
      @issues = @issues.where(:result => :meeting)
    when "redial"
      @issues = @issues.where(:result => [:redial, :noanswer])
    when "urgent"
      @issues = @issues.where(:result => :redial).includes(:calls).where("calls.next_date < ?",
        5.minutes.ago)
    when "today"
      @issues = @issues.where(:result => :redial).includes(:calls).where("calls.next_date >= :start_date AND calls.next_date <= :end_date",
        {:start_date => Date.today, :end_date => Date.tomorrow})
    when "refuse"
      @issues = @issues.where(:result => :refusal)
    when "reminders"
      # в отчете по напоминалкам: 2 цифры - назначено и сделано
      @issues = @issues.where("issues.result = ?", :meeting).includes(:calls).where("calls.result = ? ", :meeting).where("calls.meeting_date > ?", Date.tomorrow).where("issues.created_at < ?", Date.today).having("count(calls.id) < 2")
    end
    logger.warn("!===#{@issues.to_json}")
    
    @issues = @issues.paginate(:per_page => 50, :page => params[:page])
    
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
