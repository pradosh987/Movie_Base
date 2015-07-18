class Movie

	attr_accessor :title, :backdrop, :poster, :budget, :genres, :homepage, :id, :imdb_id, :language, :overview, :production_companies, :release_date, :runtime, :tagline, :ratings, :cast, :similar_movies, :reviews

	#initialize Movie. Name and id is mendatory
  def initialize(title, id, opts={},reviews: {})
    @title = title
    @id = id
    opts.each_pair do |k ,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end
    @reviews = reviews 
  end

end