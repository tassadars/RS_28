class CreateTablesDepends < ActiveRecord::Migration
  	def change
	  	create_table :comments do |t|
			t.belongs_to :post, index: true
			t.text :content

			t.timestamps
		end

		create_table :posts do |t|
			t.text :author
			t.text :content

			t.timestamps
		end

	Post.create :author => 'Jessie Pinkman', :content => "The reason we're going to be using Ubuntu is because the majority of code you write will run on a Linux server. Ubuntu is one of the easiest Linux distributions to use with lots of documentation so it's a great one to start with. You'll want to download the latest Desktop version here: http://releases.ubuntu.com/14.10/ Some of you may choose to develop on Ubuntu Server so that your development environment matches your production server. You can find it on the same download link above."
	Post.create :author => 'Walter White', :content => "Migrations are a convenient way for you to alter your database in a structured and organized manner. You could edit fragments of SQL by hand but you would then be responsible for telling other developers that they need to go and run them. You’d also have to keep track of which changes need to be run against the production machines next time you deploy."
	Post.create :author => 'Gus Fring', :content => "Active Record tracks which migrations have already been run so all you have to do is update your source and run rake db:migrate. Active Record will work out which migrations should be run. It will also update your db/schema.rb file to match the structure of your database."
	Post.create :author => 'Jane Ketler', :content => "This migration adds a table called products with a string column called name and a text column called description. A primary key column called id will also be added, however since this is the default we do not need to ask for this. The timestamp columns created_at and updated_at which Active Record populates automatically will also be added. Reversing this migration is as simple as dropping the table. Migrations are not limited to changing the schema. You can also use them to fix bad data in the database or populate new fields:"
	

 	end
end
