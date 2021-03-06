require 'warden'
require 'dynamic_form'
require 'subscribem/active_record_extensions'

module Subscribem
	class Engine < ::Rails::Engine
		isolate_namespace Subscribem

		config.generators do |g|
			g.test_framework :rspec, :view_specs => false
		end

		config.to_prepare do
			root = Subscribem::Engine.root
			extenders_path = root + 'app/extenders/**/*.rb'
			Dir.glob(extenders_path) do |file|
				Rails.configuration.cache_classes ? require( file ) : load( file )
			end
		end
		
		initializer 'subscribem.middleware.warder' do
			Rails.application.config.middleware.use Warden::Manager do |manager|
				manager.default_strategies :password
				
				manager.serialize_into_session do |user|
					user.id
				end

				manager.serialize_from_session do |id|
					Subscribem::User.find( id )
				end
			end
		end
	end
end
