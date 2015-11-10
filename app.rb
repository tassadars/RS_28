#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:leprosorium.db"

class Post < ActiveRecord::Base
	validates :author, presence: true, length: {minimum: 3}
	validates :content, presence: true, length: {minimum: 3}
	has_many :comments, :foreign_key => 'postID'
end

class Comment < ActiveRecord::Base
	  validates :content, presence: true, length: {minimum: 3}
	  belongs_to :post, :foreign_key => 'postID'
end

get '/' do
	@results = Post.order "id DESC"
	erb :index
end


before '/new' do
  @p = Post.new  
end

get '/new' do
  	erb :new
end

post '/new' do
	@p = Post.new params[:post]
	if @p.save
		redirect to '/' 
	else
		@error = @p.errors.full_messages.first
  		erb :new
  	end
end

before '/details/:post_id' do
	post_id =  params[:post_id]
	@row = Post.find(post_id)
	@comments = Comment.where(postID = post_id) 
end


get '/details/:post_id' do
	erb :details
end

post '/details/:post_id' do
	@c = Comment.new params[:comment]
	@c.post_id = params[:post_id]
	if @c.save
		return erb :details
#		redirect to '/details/' + post_id
	else
		@error = @c.errors.full_messages.first
  		erb :details
	end

end 
