class AccessQuery
  attr_accessor :resource_queries

  def initialize(resource_queries)
    self.resource_queries = resource_queries
  end

  def access_type(user, resource_name)
    # Ordered by level
    rus = resource_queries.resource_users(user, resource_name)
    ru = rus.last
    if ru
      ru.role
    else
      :denied
    end
  end
end
