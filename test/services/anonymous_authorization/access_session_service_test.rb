require "test_helper"

module AnonymousAuthorization
  class AccessSessionServiceTest < ActiveSupport::TestCase
    setup do
      @resource = test_articles(:one)
      @session_id = "session_01"
    end

    test "should authorize access code for resource" do
      code = AccessSessionService.new(@session_id).authorize(@resource)

      assert_predicate code, :present?
      assert AccessSessionService.new(@session_id).authorized?(@resource)
    end
  end
end
