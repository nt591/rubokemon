class Pokemon
  attr_reader :name

  def initialize(name)
    @name = name
  end

  class << self
    def for(name)
      Pokemon.new(name)
    end
  end
end