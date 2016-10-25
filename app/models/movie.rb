class Movie < ActiveRecord::Base
    def Movie.ratings
        Movie.select(:rating).distinct.order(:rating).collect do |movie|
            movie.rating            
        end
    end
    
    def Movie.movies(sorted_by,ratings)
        Movie.where(rating: ratings).order(sorted_by)
    end
end
