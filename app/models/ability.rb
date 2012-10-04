class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    
    if user.accounts.count > 0 
    
      

      can :read, Account do |account|
        user.member?(account)
      end

      
      can :manage, Account do |account|
        user.owner?(account)
      end
      


      can :read, Project do |project|
        user.member?(project)
      end
      
      
      can :manage, Project do |project|
        user.manager?(project)
      end
      
      
      can :create, Project 
      
      
      can :manage, Issue do |issue|
        user.manager?(issue.project)
      end
      
      can :create, Issue
      can :update, Issue
      can :read, Issue
      
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
