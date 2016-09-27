require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class RolifyBuilder < MainBuilder

        def setup
          run 'bundle exec rails g rolify Role User'
          run 'bundle exec rake db:migrate'
        end

        private

        def gem_name
          'rolify'
        end

        def gem_version
          "'~> 5.1'"
        end
      end
    end
  end
end