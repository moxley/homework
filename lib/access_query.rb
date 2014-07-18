class AccessQuery
  attr_accessor :resource_queries

  def initialize(resource_queries)
    self.resource_queries = resource_queries
  end

  def access_type(user, resource_name)
    ru = resource_queries.find_resource_user(user, resource_name)
    if ru
      ru.role
    else
      :denied
    end
  end
end
