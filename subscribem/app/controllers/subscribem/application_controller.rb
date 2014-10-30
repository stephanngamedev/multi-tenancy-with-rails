module Subscribem
	class ApplicationController < ActionController::Base
		helper_method :current_account, :current_user, :user_signed_in?

		def authenticate_user!
			unless user_signed_in?
				flash[:notice] = 'Please sign in.'
				redirect_to '/sign_in'
			end
		end

		def force_authentication!( account, user )
			env['warden'].set_user( user, scope: :user )
			env['warden'].set_user( account, scope: :account )
		end

		def current_account
			if user_signed_in?
				@current_account ||= begin
					account_id = env['warden'].user( scope: :account )
					Subscribem::Account.find( account_id )
				end
			end
		end

		def current_user
			if user_signed_in?
				@current_user ||= begin
					user_id = env['warden']	.user( scope: :user )
					Subscribem::User.find( user_id )
				end
			end
		end

		def user_signed_in?
			env['warden'].authenticated?( :user )
		end
	end
end
