require 'four_days/file_manipulator'
require 'active_support/core_ext/string/inflections'
require 'thor'

module FourDays
  module Builders
    class ControllerBuilder < Thor
      include Thor::Actions
      include FourDays::FileManipulator::Actions

      def initialize(model_name, params, *args)
        super *args
        @model_name = model_name
        @params = params
      end

      def build
        say "generating controller #{@model_name.pluralize}"
        cmd = 'rails g controller '
        cmd += @model_name.pluralize
        cmd += ' --no-test-framework --no-helper --no-assets'
        append_to_route "resource :#{@model_name.pluralize}\n"
        run cmd

        gsub_file "app/controllers/#{@model_name.pluralize}_controller.rb",
                  /ApplicationController/,
                  'ResourcesController',
                  force: true
      end
    end
  end
end