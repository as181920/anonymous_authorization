require "test_helper"

module AnonymousAuthorization
  class AuthorizationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @resource = dummy_articles(:one)
    end

    test "should get new" do
      get new_authorization_path(
        resource_gid: @resource.to_gid.to_param,
        resource_name: @resource.name,
        redirect_url: root_url
      )

      assert_response :success
      assert_includes @response.parsed_body, @resource.name
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
  end
end
