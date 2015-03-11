class FriendshipsController < ApplicationController
	before_filter :authenticate_user!
	before_action :do_friendship, only: [:accept, :send_request, :cancel, :unfriend, :block, :unblock]

	def index

	end

	def block

	end

	def unblock
	end

	def accept
	end

	def send_request
  end

	def cancel
	end

	def unfriend
	end

	private
	  def friendship_association
	  end

	  def do_friendship
	  	translated_action = t('friendships.action.'+params[:action])

			if params[:id]
				begin
					Friendship.method(action_mapper).call(current_user.id, params[:id])
					flash[:success] = "#{translated_action + t('default.success')}"
					go_back
				rescue
					flash[:error] = "#{translated_action + t('default.fail')}"
					logger.debug "#{params[:action]} failed in #{params[:controller]}"
					go_back
				end
			else
				flash[:error] = "#{translated_action + t('default.error')}"
				logger.debug "#{params[:action]} failed because of absence of id param in #{params[:controller]}"
				go_back
			end
	  end

	 def action_mapper
			case params[:action]
				when "cancel"
					:cancel
				when "accept"
					:accept
				when "send_request"
					:request
				when "unfriend"
					:cancel
				when "block"
					:block
				when "unblock"
					:unblock
			end
	 end

end
