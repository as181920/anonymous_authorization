require "test_helper"

module AnonymousAuthorization
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get welcome_index_path

      assert_response :success

      get root_path

      assert_response :success
      assert_includes @response.body, I18n.t("anonymous_authorization.engine")
    end

    test "should show message on index" do
      message = "MESSAGE FILLER"
      get welcome_index_path(message:)

      assert_response :success
      assert_includes @response.body, message
    end
  end
end
