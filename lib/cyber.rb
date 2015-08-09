require 'erb'
require 'active_record'

class Cyber
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def current_user
    @current_user ||= User.find(@request.session[:user_id]) if @request.session[:user_id]
  end

  def response
    case @request.path
    when "/"
      unless current_user
        Rack::Response.new do |response|
          response.redirect('/login')
        end
      else
        Rack::Response.new(render("index.html.erb")) do |response|
        end
      end
    when "/signup"
      Rack::Response.new(render("signup.html.erb")) do |response|
      end
    when "/login"
      Rack::Response.new(render("login.html.erb")) do |response|
      end
    when "/logout"
      @request.session[:user_id] = nil
      Rack::Response.new do |response|
        response.redirect('/login')
      end
    when "/sessions"
      Rack::Response.new do |response|
        if @request.post?
          u = User.authenticate(@request.params['email'],@request.params['password'])
          if u
            puts "authentication succeeded!"
            @request.session[:user_id] = u.id
            response.redirect('/')
          else
            response.redirect('/login')
          end
        end
      end
    when "/users"
      Rack::Response.new do |response|
        if @request.post?
          u = User.new(@request.params['user'])
          if u.save
            @request.session[:user_id] = u.id
            response.redirect('/')
          else
            response.redirect('/signup')
          end
        end
      end
    else Rack::Response.new("Not Found", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
