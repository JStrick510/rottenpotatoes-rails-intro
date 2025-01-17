class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    @all_ratings = Movie.all_ratings
    
    @sort = params[:sort] || session[:sort]
    #session[:ratings] = session[:ratings] || @all_ratings
    #params[:ratings].nil? ? @t_param = session[:ratings] : @t_param = params[:ratings].keys
    
    session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
    @t_param = params[:ratings] || session[:ratings]
    
    session[:sort] = @sort
    session[:ratings] = @t_param
    
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    #@movies = Movie.where(rating: session[:ratings].keys).order(params[:sort_by]) if params[:sort_by] != ''
    @title_header = (params[:sort]=='title') ? 'hilite bg-warning' : ''
    @release_date_header = (params[:sort]=='release_date') ? 'hilite bg-warning' : ''
    
    if(params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
