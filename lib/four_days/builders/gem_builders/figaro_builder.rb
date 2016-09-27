require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class FigaroBuilder < MainBuilder

        def setup
          run 'bundle exec figaro install'

          each_environment do |env|
            append_to_file 'config/application.yml', "#{env}:\n\n\n"
          end
        end

        private

        def gem_name
          'figaro'
        end

        def gem_version
          "'~> 1.1'"
        end
      end
    end
  end
end