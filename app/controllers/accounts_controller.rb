class AccountsController < ApplicationController
  load_and_authorize_resource :account

  def index
    @accounts = current_user.accounts
  end

  def show
    redirect_to account_projects_url(@account)
  end
end
