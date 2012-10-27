ActiveAdmin.register Account do
  index do                            
    column :id                     
    column :owner do |a|
      raw a.owners.map {|o| link_to o.display_name, admin_user_path(o) }.join(", ")
    end
    column :account_type do |a|
      I18n.t(Account::TYPES[a.account_type], :scope => "account.types")
    end
    default_actions                   
  end
  
  
  show do |a|
    attributes_table do
      row :id
      row :owner do
        raw a.owners.map {|o| link_to o.display_name, admin_user_path(o) }.join(", ")
      end
      row :account_type do
        I18n.t(Account::TYPES[a.account_type], :scope => "account.types")
      end
      row :members do 
        render "admin/account_members", :account => a
      end
    end
    active_admin_comments
  end
  
end
