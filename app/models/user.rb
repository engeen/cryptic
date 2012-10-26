class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable, :confirmable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :users_accounts
  has_many :accounts, :through => :users_accounts
  has_many :users_projects
  has_many :projects, :through => :users_projects
  has_many :calls

  before_save :ensure_authentication_token
  has_many :issues
  
  
  scope :by_role,  lambda {|user_role| joins(:users_accounts).where('users_accounts.role = ?', user_role) unless user_role.nil?}
  scope :by_project_role,  lambda {|user_role| joins(:users_projects).where('users_projects.role = ?', user_role) unless user_role.nil?}
  
  
  
  def display_name
    email
  end
  
  
  

  def member?(resource)
     if resource.is_a?(Account)
       res = account_member?(resource) 
       logger.warn "============????=======#{res}"
       res
     else
       project_member?(resource) && account_member?(resource.account) if resource.is_a?(Project)
      end
  end
  
  def owner?(account)
    res = account_owner?(account)
    logger.warn "============WTH=======#{res}"
    res
  end
  
  def manager?(project)
    project_manager?(project)
  end
  
  def account_member?(account)
    users_accounts.where(:account_id => account.id).first
  end
  
  def project_member?(project)
    project.users.where(:id => self.id).first
  end
  
  def account_owner?(account)
    users_accounts.where(:account_id => account.id, :role => :owner).first
  end
  
  def project_manager?(project)
    project.managers.where(:id=> self.id).first
  end
  
  
  
  

end
