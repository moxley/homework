class AccessQuery
  def initialize(resources)
  end

  def access_type(user, resource_name)
    :denied
  end
end
