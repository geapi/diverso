namespace :jasmine do
  namespace :ci do
    desc "Run Jasmine CI build headlessly"
    task :headless do
      # this is how it should work if ci has the righ permission so that 
      # the ci user can destroy headless
      #Headless.ly do
      #  puts "Running Jasmine Headlessly"
      #  Rake::Task['jasmine:ci'].invoke
      #end

      headless = Headless.new({})
      headless.start
      puts "Running Jasmine Headlessly"
      Rake::Task['jasmine:ci'].invoke
      headless.destroy rescue nil
    end
  end
end