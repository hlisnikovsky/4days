require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class PgBuilder < MainBuilder
        source_root File.expand_path('../templates', __FILE__)

        def setup
          template 'database.yml', 'config/database.yml', force: true

          each_environment do |env|
            inject_into_figaro env, 'DATABASE_PASSWORD', @options[:password]
            inject_into_figaro env, 'DATABASE_USERNAME', @options[:username]
          end
          run 'bundle exec rake db:create'
        end

        def add_to_gemfile
        end
      end
    end
  end
end