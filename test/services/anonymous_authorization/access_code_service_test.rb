require "test_helper"

module AnonymousAuthorization
  class AccessCodeServiceTest < ActiveSupport::TestCase
    setup do
      @resource = dummy_articles(:one)
    end

    test "should generate access code for resource" do
      assert AccessCodeService.new(@resource).access_code
    end

    test "should use predifined access code from resource" do
      @resource.expects(:anonymous_access_code).returns("XXXYYY")

      assert_equal "XXXYYY", @resource.anonymous_access_code
    end

    test "should generate new access code for resource" do
      AccessCode.where(accessible: @resource).destroy_all

      assert_difference "AccessCode.count", 1 do
        AccessCodeService.new(@resource).access_code
      end

      assert_no_difference "AccessCode.count" do
        AccessCodeService.new(@resource).access_code
      end

      access_code = AccessCode.last

      assert_equal access_code.code, AccessCodeService.new(@resource).access_code
    end

    test "should authorize access code" do
      code = AccessCodeService.new(@resource).access_code

      assert AccessCodeService.new(@resource).authorize?(code)
      assert AccessCodeService.new(@resource).authorize?(" #{code} ")
      assert_not AccessCodeService.new(@resource).authorize?("ERROR CODE")
    end
  end
end
