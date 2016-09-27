require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class SimpleFormBuilder < MainBuilder
        private

        def gem_name
          'simple_form'
        end

        def gem_version
          "'~> 3.3'"
        end
      end
    end
  end
end