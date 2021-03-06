# StatSheet.create

# require 'csv'
#
# csv = CSV.read("voted_movies.csv")
#
# csv.each do |imdb_id|
#
#     response = RestClient.get("http://www.omdbapi.com/?apikey=YOUR KEY HERE=#{imdb_id[0]}")
#     json = JSON.parse(response)
#     votes = json["imdbVotes"].delete(",").to_i
#
#     # get rotten tomatoes value
#     rt = json["Ratings"].find{|i| i["Source"] == "Rotten Tomatoes"}
#     if rt
#       rotten_tomatoes_value = rt["Value"]
#     else
#       rotten_tomatoes_value = nil
#     end
#
#     # get metascore value
#     if json["Metascore"] == "N/A"
#         metascore = nil
#     else
#         metascore = json["Metascore"].to_i
#     end
#
#     Movie.create({
#       title: json["Title"],
#       year: json["Year"].to_i,
#       rated: json["Rated"],
#       released: json["Released"],
#       runtime: json["Runtime"],
#       genre: json["Genre"],
#       director: json["Director"],
#       writer: json["Writer"],
#       actors: json["Actors"],
#       plot: json["Plot"],
#       language: json["Language"],
#       country: json["Country"],
#       awards: json["Awards"],
#       poster_url: json["Poster"],
#       rotten_tomatoes: rotten_tomatoes_value,
#       metascore: metascore,
#       imdbRating: json["imdbRating"].to_f,
#       imdbVotes: votes,
#       imdbID: json["imdbID"],
#       media_type: json["Type"],
#       production_companies: json["Production"],
#       website_url: json["Website"]
#      })
#
#     puts imdb_id[0]
# end # end loop
