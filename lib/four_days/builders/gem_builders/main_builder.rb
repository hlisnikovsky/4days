require 'thor'
require 'four_days/file_manipulator'
module FourDays
  module Builders
    module GemBuilders
      class MainBuilder < Thor
        include Thor::Actions
        include FourDays::FileManipulator::Actions

        def initialize(options = {}, *args)
          super *args
          @options = options
        end

        def setup
        end

        def add_to_gemfile
          append_to_file 'Gemfile', gem_string
        end

        private

        def each_environment(&block)
          Dir['config/environments/*.rb'].each do |filename|
            env = filename.gsub('.rb','').split('/').last
            yield(env)
          end
        end

        def gem_string
          "\ngem '#{gem_name}', #{gem_version}, require: #{!!@options[:require]}"
        end

        def gem_name
          raise 'implement me'
        end

        def gem_version
          raise 'implement me'
        end
      end
    end
  end
end