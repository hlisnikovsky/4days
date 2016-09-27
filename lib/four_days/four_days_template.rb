require 'thor'

module FourDays
  class FourDays < Thor
    include Thor::Actions
    source_root File.expand_path('../templates', __FILE__)

    def self.generate
      template 'structure.yml', 'structure.yml'
    end
  end
end
