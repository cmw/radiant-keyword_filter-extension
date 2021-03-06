namespace :radiant do
  namespace :extensions do
    namespace :keyword_filter do

      desc "Runs the migration of the Page Tags extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          KeywordFilterExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          KeywordFilterExtension.migrator.migrate
        end
      end

      desc "Copies public assets of the Page Tags to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from KeywordFilterExtension"
        Dir[KeywordFilterExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(KeywordFilterExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
    end
  end
end
