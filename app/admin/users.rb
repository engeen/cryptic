ActiveAdmin.register User do
  index do            
    column :name                
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    column :confirmed_at
    column :deleted_at
    default_actions                   
  end                                 

  filter :email                       

  form do |f|                         
    f.inputs "User Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.buttons                         
  end  
end
