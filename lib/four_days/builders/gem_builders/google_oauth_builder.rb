require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class GoogleOauthBuilder < MainBuilder
        source_root File.expand_path('../templates', __FILE__)

        def setup
          each_environment do |env|
            inject_into_figaro env, 'GOOGLE_CLIENT_ID', @options[:client_id]
            inject_into_figaro env, 'GOOGLE_CLIENT_SECRET', @options[:client_secret]
          end

          insert_into_file 'config/initializers/devise.rb',
                           "config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], { }\n",
                           after: /# ==> OmniAuth\n/,
                           force: true

          gsub_file 'config/routes.rb',
                    /devise_for :users/,
                    'devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }',
                    force: true

          inject_into_class 'app/models/user.rb', 'User', "devise :omniauthable, :omniauth_providers => [:google_oauth2]\n"

          empty_directory 'app/controllers/users'
          template 'google_oauth_controller.rb', 'app/controllers/users/omniauth_callbacks_controller.rb'

          inject_into_class 'app/models/user.rb', 'User', model_oauth

        end

        private

        def gem_name
          'omniauth-google-oauth2'
        end

        def gem_version
          "'~> 0.4'"
        end

        def model_oauth
          %Q(def self.from_omniauth(access_token)
              data = access_token.info
              user = User.where(:email => data['email']).first

              # Uncomment the section below if you want users to be created if they don't exist
              unless user
                  user = User.create(email: data['email'],
                     password: Devise.friendly_token[0,20]
                  )
              end
              user
          end\n)
        end
      end
    end
  end
end