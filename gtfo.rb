#!/usr/bin/ruby
# encoding: utf-8

require "erb"
require "json"
require "sinatra"

require_relative "db.rb"

set :bind, "0.0.0.0"

def to_img_array(dataset)
    return dataset.map{|c| "images/#{c.img_url}"}
end

def get_random(number: 1)
    return to_img_array(CyberDB.get_random(number))
end

def get_all_tags()
    return CyberDB.get_all_tags()
end

def search_tags(tags)
    results = []
    tags.each do |tag|
        r = CyberDB.search_tag(tag)
        results.concat(to_img_array(r)) unless r == []
    end
    return results
end

get '/search' do
    query = params['tags']
    next unless query=~/[a-z,]+/i
    @pictures = search_tags(query.downcase.gsub("cyber","").split(','))
    erb :index
end

get '/search.json' do
    query = params['tags']
    next unless query=~/[a-z,]+/i
    @pictures = search_tags(query.split(','))
    return {pictures: @pictures}.to_json
end

get '/tags' do
    content_type :json
    return get_all_tags.to_json
end

get '/' do
    @pictures = get_random(number:10)
    erb :index
end

__END__


@@ index
<html>
<head>
  <title>Cyber||GTFO</title>
  <link rel="stylesheet" href="materialize.min.css">
</head>
<body>
  <div id="container" style="width:80%;margin-left:15px">
  <h4>Some wannabe hackers wanted to bring back old electronic Zines feels. Unfortunately they forgot to include any kind of cyber in there. This is a free repo of proper cyber illustration.</h4>
    <h1>Cyber || GTFO</h1>
  <div class="row">
		<div class="input-field inline col s4">
       <form action="/search">
        Refresh the page for some random cyber, or search for cyber stuff:
		  <input type="text" id="autocomplete-input" class="autocomplete" name="tags">
		  <label for="autocomplete-input">Search for cyber-</label>
        </form>
		</div>
	</div>
  </div>
  <% @pictures.each_slice(4) do |group| %>
  <div class='row'>
     <% group.each do |pic| %>
       <div class='col s3'>
       <img src="<%= pic %>" style="width:100%"></img>
       </div>
     <% end %>
  </div>
  <% end %>
  <script type="text/javascript" src="jquery.min.js"></script>
  <script type="text/javascript" src="materialize.min.js"></script>
  <script type="text/javascript" src="gtfo.js"></script>
</body>
</html>
