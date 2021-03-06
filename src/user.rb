require 'data_mapper'
require_relative 'event'

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :mail, String
  property :pass, String
  property :created_at, DateTime

  has n, :events
end

DataMapper.finalize
