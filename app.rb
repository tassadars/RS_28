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

get '/details/:post_id' do
	post_id =  params[:post_id]

	@row = Post.find(post_id)
	@comments = Comment.select(:post_id) 

#	results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
#	@row = results[0]
#	@comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? order by id', [post_id]
 
	erb :details
end

post '/details/:post_id' do
	post_id =  params[:post_id]
	content = params[:content]

	if content.length <= 0 
		@error = 'Enter content'
	
		#duplicate code. Need to be changed
	#	results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
	#	@row = results[0]
	#	@comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? order by id', [post_id]

		return erb :details
	end

	#@db.execute 'INSERT INTO Comments (content, created_date, post_id) values (?, datetime(),?)',[content, post_id]

	redirect to '/details/' + post_id
end 
