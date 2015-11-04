#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do 
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
	(
		id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 
		created_date DATETIME, 
		content TEXT
	)'

	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
	(
		id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 
		created_date DATETIME, 
		content TEXT,
		post_id INTEGER
	)'

end


get '/' do
	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'
	erb :index
end

get '/new' do
  	erb :new
end

post '/new' do
	content = params[:content]

	if content.length <= 0
		@error = 'Type post text'
		return erb :new
	end

	@db.execute 'INSERT INTO Posts (content, created_date) values (?, datetime())',[content]

	redirect to '/'
end

get '/details/:post_id' do
	post_id =  params[:post_id]

	results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? order by id', [post_id]

	erb :details
end

post '/details/:post_id' do
	post_id =  params[:post_id]
	content = params[:content]

	@db.execute 'INSERT INTO Comments (content, created_date, post_id) values (?, datetime(),?)',[content, post_id]

	redirect to '/details/' + post_id
end 
