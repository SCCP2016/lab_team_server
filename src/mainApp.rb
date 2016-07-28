# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require 'data_mapper'
require 'json'
require_relative 'models'
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
      one.destroy
    end
    res ={
      status: 200
    }
    res.to_json
  end

  get '/user/delete/:id' do
    id = params[:id]
    if(User.all(id: id).first.nil?)
      res = {
        status: 200,
        message: "Not Exist"
      }
    else
      User.all(id: id).first.destroy
      res = {
        status: 200,
        message: "Deleted"
      }
    end
    res.to_json
  end
    
  get '/user/users' do
    dates = []
    user = User.all.each do |u|
      user_info = {
        id: u.id,
        name: u.name,
        mail: u.mail
      }
      dates.push(user_info)
    end
    
    res = {
      status: 200,
      data: dates
    }
    res.to_json
  end
 
  get '/user/:id' do
    id = params[:id]
    if(User.all(id: id).first.nil?)
      res = {
        status: 200,
        message: "Not Exist"
      }
    else
      user = User.all(id: id).first
      "#{user.id}: name = #{user.name}, mail = #{user.mail}"
      res = {
        status: 200,
        message: "ok",
         data: {
          id: user.id,
          name: user.name,
          mail: user.mail          
         }
      }
      
      res.to_json
    end
  end
  
  post '/user/new' do
    params = JSON.parse(request.body.read)
    
    if(User.all(name: params["name"]).first.nil?)
      user = User.create(name: params["name"],mail: params["mail"], pass: params["pass"])
      res = {
        status: 200,
        message: "Created",
        data: {
          id: user.id
        }
      }
    else
      p User.all(name: params["name"]).first
      res = {
        status: 200,
        message: "already registered"
      }
    end

    res.to_json
  end

  post '/event/new' do
    params = JSON.parse(request.body.read)

    
    if(Event.all(name: params["name"],owner: params["owner"]).first.nil?)
      event = Event.create(name: params["name"],kind: parms["kind"], owner: params["owner"], start: params["start"], stop: params["stop"],place: params["place"], motivation: params["motivation"])
      res = {
        status: 200,
        message: "Created",
        data: {
          id: event.id
        }
      }
    else
    res = {
        status: 200,
        message: "already registered"
      }
    end

    res.to_json
  end
  
  get '/event/events' do
    data = []
    event = Event.all.map do |e|
      owner = User.all(name: e.owner).first      
      event = {
        id: e.id,
        name: e.name,
        place: e.place,
        start: e.start,
        stop: e.stop,
        motivation: e.motivation,
        owner: owner
      }
      
      data.push(event)
    end
    res = {
      status: 200,
      message: "ok",
      data: data
    }

    res.to_json
  end

  get '/event/:kind/events' do
    data = []
    event = Event.all(kind: params[:kind]).map do |e|
      owner = User.all(name: e.owner).first      
      event = {
        id: e.id,
        name: e.name,
        place: e.place,
        start: e.start,
        stop: e.stop,
        motivation: e.motivation,
        owner: owner
      }
      
      data.push(event)
    end
    res = {
      status: 200,
      message: "ok",
      data: data
    }

    res.to_json
  end
  
  get '/event/:id' do
    id = params[:id]
    if(Event.all(id: id).first.nil?)
      res = {
        status: 200,
        message: "Not Exist"
      }
    else
      event = Event.all(id: id).first
      owner = User.all(name: event.owner).first
      res = {
        status: 200,
        message: "ok",
        data: {
          id: event.id,
          name: event.name,
          place: event.place,
          start: event.start,
          stop: event.stop,
          motivation: event.motivation,
          owner: owner
        }
      }
    end
    res.to_json
  end

  post '/test/relation' do
    
    params = JSON.parse(request.body.read)
    user_id = User.all(name: params["user_name"]).first.id
    event_id = Event.all(name: params["event_name"]).first.id
    
    u = User.all(id: user_id).first
    e = Event.all(id: event_id).first

    EventUser.create(user: u,event: e)
  end

  get '/test/tests' do
    p EventUser.first
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
