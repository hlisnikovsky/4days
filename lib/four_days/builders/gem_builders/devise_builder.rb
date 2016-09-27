require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class DeviseBuilder < MainBuilder

        def setup
          run 'bundle exec rails generate devise:install'

          each_environment do |env|
            inject_into_environment env,
                                    "config.action_mailer.default_url_options = { host: ENV['MAILER_HOST_NAME'], port: 3000 }"
            inject_into_figaro env,
                               'MAILER_HOST_NAME',
                               host_name(env)
          end
          run 'bundle exec rails generate devise User'
          run 'bundle exec rake db:migrate'
        end

        private

        def gem_name
          'devise'
        end

        def gem_version
          "'~> 4.2'"
        end

        def host_name(env = '')
          %w(development test).include?(env) ? 'localhost' : @options[:host_name]
        end
      end
    end
  end
end