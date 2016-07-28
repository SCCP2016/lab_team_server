require 'data_mapper'

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :mail, String
  property :pass, String
  property :created_at, DateTime
  
  has n, :events,:through => Resource
end

class Event
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :kind, Integer
  property :start, String
  property :stop, String
  property :place, String
  property :owner, String
  property :motivation, Integer
  property :created_at, DateTime
  
  has n, :user,:through => Resource
end
DataMapper.finalize
