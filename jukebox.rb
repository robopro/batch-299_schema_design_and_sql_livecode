require 'sqlite3'

DATABASE_PATH = File.join(File.dirname(__FILE__), 'chinook.sqlite')
DB = SQLite3::Database.new(DATABASE_PATH)

def list_customers
  # TODO: List all customers (name + email), ordered alphabetically
  DB.execute("SELECT first_name, last_name, email FROM customers ORDER BY first_name ASC")
end

def list_classical_tracks
  # TODO: List all tracks (name + composer) of the *Classical* playlist
  query = <<-SQL
    SELECT tracks.name, tracks.composer
    FROM tracks
    JOIN playlist_tracks ON playlist_tracks.track_id = tracks.id
    JOIN playlists ON playlists.id = playlist_tracks.playlist_id
    WHERE playlists.name = "Classical"
  SQL
  DB.execute(query)
end

def list_top_ten
  # TODO: List the 10 artists *most listed* in all playlists
  query = <<-SQL
    SELECT count(*) AS occurences, artists.name
    FROM artists
    JOIN albums ON albums.artist_id = artists.id
    JOIN tracks ON tracks.album_id = albums.id
    JOIN playlist_tracks ON playlist_tracks.track_id = tracks.id
    GROUP BY artists.name
    ORDER BY occurences DESC
    LIMIT 10
  SQL
  DB.execute(query)
end

def purchased_twice
  # TODO: List tracks which have been purchased
  #       *at least* twice, ordered by number of purchases
  query = <<-SQL
    SELECT tracks.name, COUNT(*) AS purchases
    FROM tracks
    JOIN invoice_lines ON invoice_lines.track_id = tracks.id
    GROUP BY tracks.name
    HAVING purchases >= 2
    ORDER BY purchases DESC
  SQL
  DB.execute(query)
end
