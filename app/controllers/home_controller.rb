class HomeController < ApplicationController

def index
  if current_user
    user_account_cnt = current_user.accounts.count

    if  user_account_cnt > 1
      redirect_to accounts_url
    elsif user_account_cnt == 1
      redirect_to account_url(current_user.accounts.first)
    end
  end
end

end
