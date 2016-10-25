class Movie < ActiveRecord::Base
    def Movie.ratings
        Movie.select(:rating).distinct.order(:rating).collect do |movie|
            movie.rating            
        end
    end
end
