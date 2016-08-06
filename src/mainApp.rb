# coding: utf-8
require 'sinatra/base'
require 'sinatra/reloader'
require 'data_mapper'
require 'json'
require_relative 'models'
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, (ENV['DATABASE_URL'] ||= "postgres://postgres:@db"))

# Sinatra Main controller
class MainApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  
  get '/' do
    "HELLO"
  end

  #API USER ----------------------------------------------------
  get '/users' do
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

  
  post '/users/new' do
    params = JSON.parse(request.body.read)
    
    if(User.all(name: params["name"]).first.nil?)
      user = User.create(name: params["name"],mail: params["mail"], pass: params["pass"],motivation: params["motivation"])
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

  
  get '/users/:id' do
    id = params[:id]
    if(User.all(id: id).first.nil?)
      res = {
        status: 200,
        message: "Not Exist"
      }
    else
      user = User.all(id: id).first
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
  
  get '/users/deleteALL' do
    user = User.all
    user.each do |one|
      one.destroy
    end
    res ={
      status: 200
    }
    res.to_json
  end
  
  get '/users/:id/delete' do
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

  post '/users/update' do
    params = JSON.parse(request.body.read)
    user = User.all(id: params["id"])

    if (!params["pass"].nil?)
      user.pass = params["pass"]
    end
    
    if (!params["mail"].nil?)
      user.mail = params["mail"]
    end

    if (!params["motivation"].nil?)
      user.motivation = params["motivation"]
    end
    user.save

    res = {
      status: 200,
      message: "Update"
    }
    res.to_json
  end

  #API EVENT ------------------------------------------------------
  
  get '/events' do
    data = []
    events = Event.all.map do |e|
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


  post '/events/new' do
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

  get '/events/:kind' do
    data = []
    events = Event.all(kind: params[:kind],motivation: params["motivation"]).map do |e|
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
  
  post '/events/attend' do
    params = JSON.parse(request.body.read)
    u = User.all(id: params["user_id"]).first
    e = Event.all(id: Event.all(name: params["event_name"],owner: params["owner"]).first.id).first
    
    if(EventUser.all(user: u,event: e).nil?)
      event_user = EventUser.create(user: u,event: e)
      
      res = {
        status: 200,
        message: "ok",
        data: {
          user_id: event_user.user_id,
          event_id: event_user.event_id
        }
      }
    else
      res = {
        status: 200,
        message: "Already Exist"
      }
    end
    res.to_json
  end
  
  get '/events/users' do
    data = []
    event_user = EventUser.all(event_id: params["id"]).map do |eu|
      info = {
        user: eu.user
      }

      data.push(info)
    end

    res = {
      status: 200,
      message: "ok",
      event_id: params["id"],
      data: data
    }
    p res
    res.to_json
  end

  
  get '/events/:id' do
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
    p res
    res.to_json
  end
  

  get '/events/deleteALL' do
    event = Event.all
    Event.each do |one|
      one.destroy
    end
    res ={
      status: 200
    }
    res.to_json
  end  
  
  get '/test/tests' do
    p EventUser.first
  end

  get '/events/:id/delete' do
    id = params[:id]
    if(Event.all(id: id).first.nil?)
      res = {
        status: 200,
        message: "Not Exist"
      }
    else
      Event.all(id: id).first.destroy
      res = {
        status: 200,
        message: "Deleted"
      }
    end
    res.to_json
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
