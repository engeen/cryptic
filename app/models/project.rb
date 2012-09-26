class Project < ActiveRecord::Base
  after_save :invite_members, :unless => lambda {|object| object.emails_list.nil?}
  
  belongs_to :account
  has_many :users_projects
  has_many :users, :through => :users_projects

  attr_accessible :name,  :emails_list, :users_projects_attributes
  accepts_nested_attributes_for :users_projects, :allow_destroy => true, :reject_if => :all_blank
  attr_accessor :emails_list
  
  has_many :issues
  
  
  scope :by_user,  lambda {|user| joins(:users_projects).where('users_projects.user_id = ?', user.id) unless user.nil?}
  
  
  def role_for(user)
    users_projects.find_by_user_id(user.id).role || nil
  end
  
  
  def managers
    users.by_project_role(:manager)
  end
  
  
  
  protected
  
  def invite_members
    #parse email string
    valid_emails, invalid_emails = ProjectTools::parse_emails(emails_list)
    logger.warn "===> PARSING EMAILS: #{valid_emails.to_s}"
    
      valid_emails.each do |email|
        begin
          user = User.find_or_create_by_email(email[:email], {:password => "newuser", :password_confirmation => "newuser"})
          logger.warn user.to_json
          if user.valid?
            user_account = account.users_accounts.find_or_create_by_user_id_and_role(user.id, :member)
            logger.warn user_account.to_json
            user_project = users_projects.find_or_create_by_user_id_and_role(:user_id => user.id, :role => :member)
            logger.warn user_project.to_json
          else
            logger.warn "===> CANT CREATE USER: USER PROBABLY INVALID"
          end

          
        rescue Exception => ex
          logger.warn "===> CANT INVITE USERS_PROJECTS"
          logger.warn ex.to_s
        end
        
      end
      
      
  end
end
