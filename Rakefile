require 'dm-core'
require 'dm-migrations'
# Model Classes
require_relative 'src/models'


task 'db:migrate' do
  DataMapper::Logger.new($stdout, :debug)
  #DataMapper.setup(:default, 'postgres://postgres:@db/myapp')
  config = YAML.load_file('./config/database.yml')
  DataMapper.setup(:default, config)
  DataMapper.auto_upgrade!
  self
end
