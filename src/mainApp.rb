# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require 'data_mapper'
require 'json'
require 'pry'
require_relative 'word'
require_relative 'user'
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://postgres:@db')

# Sinatra Main controller
class MainApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  
  get '/' do
    "HELLO"
  end

  get '/user/deleteALL' do
    user = User.all
    user.each do |one|
      one.destroy.to_s
    end
  end

  get '/user/delete/:id' do
    id = params[:id]
    if(User.all(id: id).first.nil?)
      "not exist"
    else
      User.all(id: id).first.destroy.to_s
    end
  end
    
  get '/user/users' do
    user = User.all.map do |u|
      u.id.to_s + ": #{u.name},#{u.mail}"
    end
    user.join(', ')
  end
 
  get '/user/:id' do
    id = params[:id]
    if(User.all(id: id).first.nil?)
      "not exist"
    else
      user = User.all(id: id).first
      "#{user.id}: name = #{user.name}, mail = #{user.mail}"
    end
  end
  
  post '/user/new' do
    params = JSON.parse(request.body.read)
    
    if(User.all(name: params["name"]).first.nil?)
      user = User.create(name: params["name"],mail: params["mail"], pass: params["pass"])
      user.id.to_s
    else
      p User.all(name: params["name"]).first
      "already registered"
    end
  end
=begin  
  post '/login' do
    params = JSON.parse(request.body.read)
    if(User.all(name: params["name"], pass: params["pass"]).first.nil?)
      "not registered"
    else
      session_start!
      session[:name] = params[:name]
    end
  end
=end  
end


