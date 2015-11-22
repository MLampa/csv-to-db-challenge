require "pg"
require 'csv'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

@ingredients = []
	    CSV.foreach("ingredients.csv") do |ingredient|
	      @ingredients << ingredient
	    end

	@ingredients.each do |ingredient|
	  db_connection do |conn|
	    conn.exec_params("INSERT INTO ingredients (id, name)
	    VALUES ($1, $2)", [ingredient[0],ingredient[1]])
	  end
	end

	db_connection do |conn|
	  @ingredients_from_table = conn.exec ("SELECT id, name FROM ingredients")
	end

	@ingredients_from_table.each do |ingredient|
	  puts "#{ingredient["id"]}. #{ingredient["name"]}"
	end
