require 'data_mapper'
require_relative 'user'

class Event
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :start, String
  property :place, String
  property :motivation, Text
  property :created_at, DateTime

  belongs_to :user
end

DataMapper.finalize
