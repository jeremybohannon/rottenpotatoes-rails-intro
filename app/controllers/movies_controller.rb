class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # persist sort by column
    @id = params['sortby']
    session[:id] = @id if @id
    @id = session[:id] if session[:id]
    
    # persist ratings (unless all unchecked)
    @ratings = params['ratings'] 
    @ratings = {} if params['reset'] and !params['ratings']
    session[:ratings] = @ratings if @ratings 
    @ratings = session[:ratings] if session[:ratings]
    
    # filter movies by rating
    @movies = Movie.filter_ratings @ratings
    
    # predefine ratings
    @all_ratings = ['G','PG','PG-13','R']
    
    # redirect to be restful
    if params['sortby'] != session[:id]
      redirect_to movies_path(:sortby => session[:id])
      return
    end
    
    
    @ratings = {"G"=>true, "PG"=>true, "PG-13"=>true, "R"=>true} if @ratings and @ratings.length == 0
    @ratings = {"G"=>true, "PG"=>true, "PG-13"=>true, "R"=>true} unless @ratings 
    

    if @ratings.length > 0
      if params['ratings'] != session[:ratings]
        redirect_to movies_path(:sortby => session[:id], :ratings => @ratings)
        return
      end
    end
    
    # sort movies if sortby param is present
    if @id
      @movies = @movies.sort do |a, b|
        a[@id.to_sym] <=> b[@id.to_sym]
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
