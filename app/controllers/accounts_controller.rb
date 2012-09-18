class AccountsController < ApplicationController
  load_and_authorize_resource :account

end
