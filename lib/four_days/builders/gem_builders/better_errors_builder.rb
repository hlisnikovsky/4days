require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class BetterErrorsBuilder < MainBuilder
        private

        def gem_name
          'better_errors'
        end

        def gem_version
          "'~> 2.1'"
        end
      end
    end
  end
end