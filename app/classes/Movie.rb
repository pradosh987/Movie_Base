class Movie

	attr_accessor :title, :name, :backdrop, :poster, :budget, :genre, :homepage, :id, :imdb_id, :language, :overview, :production_companies, :release_date, :runtime, :tagline, :ratings, :reviews

	#initialize Movie. Name and id is mendatory
  def initialize(name, id, opts={},reviews: {})
    @name = name
    @id = id
    opts.each_pair do |k ,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end
    @reviews = reviews 
  end

end