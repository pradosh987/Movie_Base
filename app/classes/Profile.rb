class Profile

  attr_accessor :name, :id, :place_of_birth, :profile_picture, :birthday, :deathday, :homepage, :biography, :imdb_id, :starred_in

  #initialize profile. Name and id is mendatory
  def initialize(id, name, opts={})
    @name = name
    @id = id
    opts.each_pair do |k ,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end 
  end
end
