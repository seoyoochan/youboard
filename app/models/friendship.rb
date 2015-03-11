class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: "User", foreign_key: :friend_id


	def self.request(current_user, friend)
	  unless self.myself?(current_user, friend) || Friendship.exists?(user_id: current_user, friend_id: friend) || Friendship.exists?(user_id: friend, friend_id: current_user)
		# For data integrity
		transaction do
			# one user sends a friend request and his state becomes pending
			friendship1 = Friendship.create(user_id: current_user, friend_id: friend, state: "pending", sent_at: Time.now)
			# Check if the friendship has been successfully recorded in db
			friendship1.send_friend_request if !friendship1.new_record?
			# Being friends was requested to the other user and his state becomes requested
			friendship2 = Friendship.create(user_id: friend, friend_id: current_user, state: "requested", received_at: Time.now)
		end
	  end
	end

	# cancel is used for cancellation of friendship/friend request
	def self.cancel(current_user, friend)
		if self.valid_relationship?(current_user, friend)
			transaction do
				self.mutual_friendships(current_user, friend)
				@friendship1.destroy!
				@friendship2.destroy!
			end
		end
	end

	def self.accept(current_user, friend)
		if self.valid_relationship?(current_user, friend)
			transaction do
				self.mutual_friendships(current_user, friend)
				@friendship1.update_attributes!(state: "accepted", accepted_at: Time.now)
				@friendship2.update_attributes!(state: "accepted", accepted_at: Time.now)
				@friendship1.send_acceptance
			end
		end
	end

	def self.block(current_user, friend)
		unless self.myself?(current_user, friend)
			logger.debug " unless self.myself?(current_user, friend) "

			unless self.mutual?(current_user, friend)
				# Individual block
				Friendship.create!(user_id: current_user, friend_id: friend, state: "blocked", blocked_at: Time.now)
			else
				# Mutual block
				self.mutual_friendships(current_user, friend)
				@friendship1.update_attributes!(user_id: current_user, friend_id: friend, state: "blocked", blocked_at: Time.now)
				@friendship2.update_attributes!(user_id: friend, friend_id: current_user, state: "blocked", blocked_at: Time.now)
			end
		end
	end

	def self.unblock(current_user, friend)
		unless self.myself?(current_user, friend)
			friendship = self.where(user_id: current_user, friend_id: friend).first
			friendship.destroy!
		end
	end

	def self.mutual_friendships(current_user, friend)
		@friendship1 = self.where(user_id: current_user, friend_id: friend).first
		@friendship2 = self.where(user_id: friend, friend_id: current_user).first
	end

	def send_friend_request
		UserMailer.friend_requested(id).deliver
	end

	def send_acceptance
		UserMailer.friend_request_accepted(id).deliver
	end

 	def self.mutual?(current_user, friend)
		Friendship.exists?(user_id: current_user, friend_id: friend) && Friendship.exists?(user_id: friend, friend_id: current_user) ? true : false
	end

	def self.valid_relationship?(current_user, friend)
   	!self.myself?(current_user,friend) && self.mutual?(current_user, friend) ? true : false
   end

	def self.myself?(current_user, friend)
		current_user == friend ? true : false
	end

end
