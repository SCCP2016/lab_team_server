require 'data_mapper'

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :mail, String
  property :pass, String
end

DataMapper.finalize
