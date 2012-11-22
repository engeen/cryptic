class CommentsController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :project, :through => :account
  load_and_authorize_resource :issue, :through => :project
  load_and_authorize_resource :comment, :through => :issue

  def create
    comment = @issue.comments.build(params[:comment])
    comment.user = current_user
    comment.save!
    @issue.reload
  end

end
