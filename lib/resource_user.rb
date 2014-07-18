class ResourceUser
  attr_accessor :user,
                :resource,
                :role

  def initialize(user, resouce, role)
    self.user = user
    self.resource = resource
    self.role = role
  end
end
