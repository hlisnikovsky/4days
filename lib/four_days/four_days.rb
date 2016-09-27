require 'yaml'
require 'thor'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string/inflections'
require 'four_days/builders/gem_builders/pg_builder'
require 'four_days/builders/gem_builders/devise_builder'
require 'four_days/builders/gem_builders/figaro_builder'
require 'four_days/builders/gem_builders/google_oauth_builder'
require 'four_days/builders/gem_builders/easy_resource_builder'
require 'four_days/builders/gem_builders/rolify_builder'
require 'four_days/builders/gem_builders/better_errors_builder'
require 'four_days/builders/gem_builders/binding_of_caller_builder'
require 'four_days/builders/gem_builders/simple_form_builder'
require 'four_days/builders/gem_builders/main_builder'
require 'four_days/builders/model_builder'
require 'four_days/builders/controller_builder'
require 'four_days/file_manipulator'

module FourDays
  class FourDays < Thor
    include Thor::Actions
    include FileManipulator::Actions

    def initialize(*args, filename)
      super *args
      @file = YAML.load_file(filename).with_indifferent_access
      @project_path = @file[:application_name]
    end

    def setup_application
      run "rails new #{@project_path} -B -T -d #{@file[:db][:type]} --skip-spring"
      Dir.chdir(@project_path)

      postgresql_builder = Builders::GemBuilders::PgBuilder.new({app_name: @project_path,
                                                                 username: @file[:db][:username],
                                                                 password: @file[:db][:password]})
      figaro_builder = Builders::GemBuilders::FigaroBuilder.new(require: true)

      builders = []
      builders << Builders::GemBuilders::EasyResourceBuilder.new(require: true)
      builders << Builders::GemBuilders::BetterErrorsBuilder.new(require: true)
      builders << Builders::GemBuilders::BindingOfCallerBuilder.new(require: true)
      builders << Builders::GemBuilders::SimpleFormBuilder.new(require: true)
      @file[:gems].each do |gem, options|
        builder_class = "FourDays::Builders::GemBuilders::#{gem.camelize}Builder".safe_constantize
        if builder_class && builder_class.class == Class
          builders << builder_class.new(options)
        else
          puts "#{gem} not supported"
        end
      end

      figaro_builder.add_to_gemfile
      builders.map &:add_to_gemfile
      run 'bundle install'
      figaro_builder.setup
      postgresql_builder.setup
      builders.map &:setup

      #generate models and controllers
      @file[:entities].each do |name, entity|
        Builders::ModelBuilder.new(name, entity[:model]).build
        Builders::ControllerBuilder.new(name, entity[:controller]).build
      end

      run 'bundle exec rails g controller Welcome index --no-test-framework --no-helper --no-assets'
      insert_into_file "#{@project_path}/config/routes.rb",
                       "root 'welcome#index'\n",
                       after: /\.routes\.draw do\s*\n/m,
                       force: true

      run 'bundle exec rake db:migrate'
    end
  end
end
