#!/usr/bin/env ruby

require 'optparse'
require 'json'

@data_path = 'movies_data.json'

def read_file
  content = ''
  File.open(@data_path, 'r') {|file| content = file.read}
  JSON.parse(content)
end

def save_file(json)
  File.write(@data_path, JSON.unparse(json))
end

def random
  puts "Randomized list, without immediate duplicates:\n\n"

  movies = read_file['movies']
  movies.size.times do
    sampled = movies[0..movies.size>>1].sample
    movies <<= movies.delete(sampled)

    puts "#{sampled['title']}: #{sampled['rate']} stars"
  end
end

options = {}
rate = ARGV

OptionParser.new do |opts|
  opts.banner = 'Welcome to anselMovie Rating System ™'
  opts.separator ''
  opts.separator 'Usage: movies.rb [options]'
  opts.on('-a', '--add MOVIE RATING', String, 'Add a new MOVIE with RATING (0-5) stars.', '(by default it adds 0 (zero) stars if RATE is omitted)') {|movie| options[:add] = movie.capitalize}
  opts.on('-r', '--remove MOVIE', String, 'Remove an existing MOVIE.') {|movie| options[:remove] = movie.capitalize}
  opts.on('-u', '--update MOVIE RATING', String, 'Update an existing MOVIE with RATING stars.') {|movie| options[:update] = movie.capitalize}
  opts.on('-d', '--display MOVIE', String, 'Display the MOVIE already included;', 'Tip: display ALL to view all movies.') {|movie| options[:display] = movie.capitalize}
  opts.on('-?', '--random', 'List some movies in a random order', '(with possible duplicates but NOT in sequence!)') {random}
  opts.on('-h', '--help', 'Show this help.') {puts opts}
end.parse!

if options[:add] && rate.join.to_i < 6
  json = read_file
  json['movies'].each {|movie| raise "Sorry, #{options[:add]} was already added." if movie['title'] == options[:add]}
  new_movie = {title: "#{options[:add]}", rate: rate.join.to_i}
  json['movies'] << new_movie
  json['movies'].sort_by! {|el| el.values}
  save_file(json)
  puts "#{options[:add]} successfully added!"
elsif options[:add] && rate.join.to_i > 5
  puts 'Invalid. Please make sure the rating is between 0-5.'
end

if options[:remove]
  json = read_file
  movie_candidates = json['movies'].select {|movie| movie['title'] == options[:remove]}
  unless movie_candidates.size == 0
    json['movies'].delete(movie_candidates.first)
    save_file(json)
    puts "#{options[:remove]} has been removed."
  end
end

if options[:update]
  json = read_file
  movie_candidates = json['movies'].select {|movie| movie['title'] == options[:update]}
  unless movie_candidates.size == 0 || rate.join.to_i > 5
    movie_candidates.first['rate'] = rate.join.to_i
    save_file(json)
    puts "#{options[:update]} has been updated with #{rate.join.to_i} stars."
  end
end

if options[:display]
  json = read_file
  json['movies'].each do |movie|
    puts "#{movie['title']}: #{movie['rate']} stars." if options[:display] == 'All'
    puts "#{movie['title']}: #{movie['rate']} stars." if options[:display] == movie['title']
  end
end