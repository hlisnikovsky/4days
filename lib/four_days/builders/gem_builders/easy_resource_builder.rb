require 'four_days/builders/gem_builders/main_builder'
module FourDays
  module Builders
    module GemBuilders
      class EasyResourceBuilder < MainBuilder
        source_root File.expand_path('../templates', __FILE__)

        def setup
          run 'rails g controller resources --no-test-framework --no-helper --no-assets'
          inject_into_class 'app/controllers/resources_controller.rb',
                            'ResourcesController',
                            "include EasyResource::BaseController\n"

          copy_file 'new.html.erb', 'app/views/resources/new.html.erb'
          copy_file 'edit.html.erb', 'app/views/resources/edit.html.erb'
          copy_file 'show.html.erb', 'app/views/resources/show.html.erb'
          copy_file 'index.html.erb', 'app/views/resources/index.html.erb'
          copy_file '_form.html.erb', 'app/views/resources/_form.html.erb'
        end

        private

        def gem_name
          'easy_resource'
        end

        def gem_version
          "github: 'ciihla/easy_resource'"
        end
      end
    end
  end
end