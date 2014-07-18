class Resource
  attr_accessor :parent,
                :children,
                :name

  def initialize(name)
    self.name = name
    self.children = []
  end

  def root?
    !parent
  end
end
