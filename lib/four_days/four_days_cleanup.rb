module FourDays
  class FourDaysCleanup
    def self.run(path)
      Dir.chdir(path) do
        system 'bundle exec rake db:drop'
      end
      system "rm -rf #{path}"
    end
  end
end
