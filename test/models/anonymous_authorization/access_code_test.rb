require "test_helper"

module AnonymousAuthorization
  class AccessCodeTest < ActiveSupport::TestCase
    setup do
      @resource = dummy_articles(:one)
    end

    test "should create" do
      access_code = AccessCode.new accessible: @resource

      assert access_code.save
      assert access_code.code
      assert_nil access_code.expires_at
    end
  end
end
