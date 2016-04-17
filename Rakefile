# Rakefile

# Asset pipeline
require 'sinatra/asset_pipeline/task'
require './app'

Sinatra::AssetPipeline::Task.define!(App)

# Active record stuff
require 'sinatra/activerecord/rake'

# Rake console is fun!
task :console do
  require 'irb'
  require 'irb/completion'
  require './app' # You know what to do.
  ARGV.clear
  IRB.start
end

task :test do
  puts "Test in progress"
end

task :assign_batches_to_each_game do
  rounds = Round.order(played_date: :asc)
  puts "found #{Round.count} rounds"
  puts "there are currently #{Batch.count} batches"
  rounds.each do |r|
    if r.batch_id.nil?
      batch = Batch.find_or_create_by(tee_id: r.tee_id, date: r.played_date, sex: r.user.sex.upcase, format: r.format)
      r.batch_id = batch.id
      r.save
      puts "round #{r.id} assigned to batch #{r.batch_id}"
    else
      puts "round #{r.id} already assigned to batch #{r.batch_id}"
    end
  end
end
