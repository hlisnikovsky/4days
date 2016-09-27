require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class BindingOfCallerBuilder < MainBuilder
        private

        def gem_name
          'binding_of_caller'
        end

        def gem_version
          "'~> 0.7'"
        end
      end
    end
  end
end