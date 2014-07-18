class ResourceQueries
  # Results are ordered by hierarchy level, ascending
  def resource_users(user, resource_name)
    ru = ResourceUser.where(user_id: user.id)
      joins(:resources).
      where(resource: {name: resource_name}).
      first

    return [] unless ru

    # The resource_users table has "lft" and "rgt" columns
    # that follow the "nested set" model for hierarchical data
    # in relational databases.
    # See http://mikehillyer.com/articles/managing-hierarchical-data-in-mysql/
    ResourceUser.
      joins(:resources).
      where('resources.lft <= ? AND resources.rgt => ?', ru.lft, ru.rgt).
      order('resources.lft')
  end
end
