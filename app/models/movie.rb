class Movie < ActiveRecord::Base
    def self.filter_ratings ratings
       return all unless ratings and ratings.length > 0
       movies = []
       ratings.each do |rating|
           movies += where({ rating: rating[0] }) 
       end
       return movies
    end
end
