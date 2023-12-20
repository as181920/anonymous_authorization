require "test_helper"

module AnonymousAuthorization
  class AuthorizationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @resource = dummy_articles(:one)
      @session_id = Rack::Session::SessionId.new(SecureRandom.hex)
      ActionDispatch::Request::Session.any_instance.stubs(:id).returns(@session_id)
      AccessSessionService.new(@session_id).clear(@resource)
    end

    test "should get new" do
      get new_authorization_path(
        resource_gid: @resource.to_gid.to_param,
        resource_name: @resource.name,
        redirect_url: root_url
      )

      assert_response :success
      assert_includes @response.body, @resource.name
      assert_equal root_url, session[:redirect_url]
    end

    test "should create authorization" do
      post authorizations_path, params: {
        authorization: {
          resource_gid: @resource.to_gid.to_param,
          access_code: anonymous_authorization_access_codes(:one).code
        }
      }

      assert_redirected_to root_url
      assert AccessSessionService.new(session.id).authorized?(@resource)
    end

    test "should forbid authorization with invalid access code" do
      post authorizations_path, params: {
        authorization: {
          resource_gid: @resource.to_gid.to_param,
          access_code: "WrongCode"
        }
      }

      assert_redirected_to root_url
      assert_not AccessSessionService.new(session.id).authorized?(@resource)
      assert_equal I18n.t("anonymous_authorization.invalid_access_code"), flash[:alert]
    end
  end
end
