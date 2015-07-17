class Profile

attr_accessor :name, :id, :place_of_birth, :profie_picture, :birthday, :deathday, :homepage, :biography, :imdb_id 

  #initialize profile. Name and id is mendatory
  def initialize(name, id, opts={})
    @name = name
    @id = id
    opts.each_pair do |k ,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end 
  end

end
