require 'test_helper'

describe AccessQuery do
  let(:resource_queries) { ResourceQueries.new }
  let(:access_query) { AccessQuery.new(resource_queries) }
  let(:user) { Object.new }
  let(:resource) { Resource.new("resource_foo") }
  let(:resource_user) { ResourceUser.new(user, resource, :user) }

  describe '#access_type' do
    it "is :denied by default" do
      access_query.access_type(user, "resource_foo").must_equal :denied
    end

    it "is :user when a ResourceUser with :user is found" do
      resource_queries.stub :find_resource_user, resource_user do
        access_query.access_type(user, "resource_foo").must_equal :user
      end
    end
  end
end
