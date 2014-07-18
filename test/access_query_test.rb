require 'test_helper'

describe AccessQuery do
  describe '#has_access?' do
    it "is :denied by default" do
      resource_queries = Object.new
      user = Object.new
      AccessQuery.new(resource_queries).access_type(user, "resource_foo").must_equal :denied
    end
  end
end
