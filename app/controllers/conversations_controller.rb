class ConversationsController < ApplicationController
  before_action :get_mailbox
  before_action :get_conversation, except: [:index]
  before_action :get_box, only: [:index]

  def index
    if @box.eql? 'inbox'
      @conversations = @mailbox.inbox
    elsif @box.eql? 'sent'
      @conversations = @mailbox.sent
    elsif
     @conversations = @mailbox.trash
    end      

    @conversations = @mailbox.inbox.paginate(page: params[:page], per_page: 10)
  end

  def show
    
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    flash[:success] = 'Reply sent'
    redirect_to conversation_path(@conversation)  
  end

  def destroy
    @conversation.move_to_trash(current_user)
    flash[:success] = 'The conversation is moved to trash.'
    redirect_to conversation_path
  end

  def restore
    @conversation.untrash(current_user)
    flash[:success] 'The conversation is restored'
    redirect_to conversation_path
  end

  private
  def get_box
    if params[:box].blank? or !["inbox","sent","trash"].include?(params[:inbox])
      params[:box] = 'inbox'
    end
    @box = params[:box]    
  end

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_conversation
    @conversations ||= @mailbox.conversations.find(params[:id])
  end

end  