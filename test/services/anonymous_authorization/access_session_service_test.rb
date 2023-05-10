require "test_helper"

module AnonymousAuthorization
  class AccessSessionServiceTest < ActiveSupport::TestCase
    setup do
      @resource = dummy_articles(:one)
      @session_id = "session_01"
    end

    test "should authorize access code for resource" do
      code = AccessSessionService.new(@session_id).authorize(@resource)

      assert_predicate code, :present?
      assert AccessSessionService.new(@session_id).authorized?(@resource)
    end

    test "should clear authorization" do
      AccessSessionService.new(@session_id).clear(@resource)

      assert_not AccessSessionService.new(@session_id).authorized?(@resource)
    end
  end
end
