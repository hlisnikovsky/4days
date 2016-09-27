require 'four_days/file_manipulator'
require 'active_support/core_ext/string/inflections'
require 'thor'

module FourDays
  module Builders
    class ModelBuilder < Thor
      include Thor::Actions
      include FourDays::FileManipulator::Actions

      def initialize(model_name, params, *args)
        super *args
        @model_name = model_name
        @params = params
      end

      def build
        say "generating model #{@model_name}"
        cmd = 'rails g model '
        cmd += @model_name
        cmd += ' '
        @params[:fields].each do |key, val|
          cmd += " #{key}:#{val[:type]}"
          cmd += ':index' if val[:index]
          cmd += ':uniq' if val[:uniq]
        end

        # generate model using rails g model
        run cmd

        migration_file = Dir.glob("db/migrate/*_create_#{@model_name}s.rb").first

        # add not null constraints to migration file
        @params[:fields].each do |key, val|
          if val.has_key? :is_null
            insert_into_file migration_file, ", null: #{val[:is_null]}", after: /t\.#{val[:type]} :#{key}/, force: true
          end
        end

        # add validations to model
        model_filename = "app/models/#{@model_name}.rb"
        model_string = ''
        @params[:validations].each do |field, val|
          model_string += "validates :#{field}, #{val.map { |key, val| "#{key}: #{val}" }.join(', ')}\n"
        end
        #add relations to model
        @params[:relations].each do |field, val|
          model_string += "#{val} :#{val == 'has_many' ? field.pluralize : field}\n"
        end
        inject_into_class model_filename, @model_name.camelize, model_string, force: true
      end
    end
  end
end