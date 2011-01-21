namespace :spree do
  namespace :extensions do
    namespace :yandex_market do
      desc "Copies public assets of the Yandex Market to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[YandexMarketExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(YandexMarketExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
      
      
      desc "Generate Yandex.Market export file"
      task :generate_ym => :environment do 
        directory = File.join(RAILS_ROOT,'public', "yandex_market")
        mkdir_p directory unless File.exist?(directory)
        require File.expand_path(File.join(RAILS_ROOT,"config/environment"))
        require "#{File.expand_path('../..', File.dirname(__FILE__))}/lib/export/yandex_market.rb"
        ::Time::DATE_FORMATS[:ym] = "%Y-%m-%d %H:%M"
        yml_xml = Export::YandexMarket.new.export
        
        # Создаем файл, сохраняем в нужной папке,
        tfile = File.new( File.join(directory,"yandex_market_#{Time.now.strftime("%Y_%m_%d_%H_%M")}" ), "w+")
        tfile.write(yml_xml)
        tfile.close  
        # пакуем в gz и делаем симлинк на ссылку файла yandex_market_last.gz
        `ln -sf "#{tfile.path}" "#{File.join(directory, 'yandex_market.xml')}"`

        # Удаляем лишнии файлы
        @config = ::YandexMarketConfiguration.first
        @number_of_files = @config.preferred_number_of_files
         
        @export_files =  Dir[File.join(directory, '**','*')].
          map {|x| [File.basename(x), File.mtime(x)] }.
          sort{|x,y| y.last <=> x.last }
        e =@export_files.find {|x| x.first == "yandex_market.xml" }
        @export_files.reject! {|x| x.first == "yandex_market.xml" }
        @export_files.unshift(e)
        
        @export_files[@number_of_files..-1] && @export_files[@number_of_files..-1].each do |x|
          if File.exist?(File.join(directory,x.first))
            Rails.logger.info '[ yandex market ] удаляем устаревший файл'
            Rails.logger.info "[ yandex market ] путь к файлу #{File.join(directory,x.first)}"
            File.delete(File.join(directory,x.first)) 
          end
        end
        
      end
      
    end
  end
end
