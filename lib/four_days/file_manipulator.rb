require 'tempfile'
module FourDays
  class FileManipulator
    module Actions

      def inject_into_environment(environment, value)
        insert_into_file "config/environments/#{environment}.rb",
                         "#{value}\n",
                         after: /Rails\.application\.configure do\n|Rails\.application\.configure do .*\n/,
                         force: true
      end

      def inject_into_figaro(environment, variable, value)
        insert_into_file 'config/application.yml',
                         "  #{variable}: '#{value}'\n",
                         after: /^#{environment}:\n/,
                         force: true
      end

      def inject_into_route(value)
        insert_into_file 'config/routes.rb',
                         "#{value}\n",
                         after: /\.routes\.draw do\s*\n/m,
                         force: true
      end

      def append_to_route(value)
        insert_into_file 'config/routes.rb',
                         "#{value}\n",
                         before: /end\n*\Z/m,
                         force: true
      end


      # def append_to_line(filename, regexp, append)
      #   tempfile_manipulator(filename) do |tempfile|
      #     File.open(filename).each do |line|
      #       if line =~ regexp
      #         tempfile.puts line.gsub("\n", '') + append + "\n"
      #       else
      #         tempfile.puts line
      #       end
      #     end
      #   end
      # end

      # def add_line_after(filename, regexp, new_line)
      #   tempfile_manipulator(filename) do |tempfile|
      #     File.open(filename).each do |line|
      #       if line =~ regexp
      #         tempfile.puts line
      #         tempfile.puts new_line + "\n"
      #       else
      #         tempfile.puts line
      #       end
      #     end
      #   end
      # end
    end
  end
end