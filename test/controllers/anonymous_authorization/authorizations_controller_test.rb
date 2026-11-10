require "test_helper"

module AnonymousAuthorization
  class AuthorizationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @resource = dummy_articles(:one)
      @original_cache = Rails.cache
      Rails.cache = ActiveSupport::Cache::MemoryStore.new
    end

    teardown do
      Rails.cache = @original_cache
    end

    test "should get new" do
      get new_authorization_path(
        resource_gid: @resource.to_gid.to_param,
        resource_name: @resource.name,
        redirect_url: root_url
      )

      assert_response :success
      assert_includes @response.body, @resource.name
      assert_select 'input[name="authorization[redirect_url]"]', value: root_url
    end

    test "return URL does not enter the cookie" do
      get new_authorization_path(resource_gid: @resource.to_gid.to_param, redirect_url: root_url)

      assert_nil session[:redirect_url]
    end

    test "should create authorization" do
      post authorizations_path, params: {
        authorization: {
          resource_gid: @resource.to_gid.to_param,
          access_code: anonymous_authorization_access_codes(:one).code
        }
      }

      assert_redirected_to root_url
      assert AuthorizationSession.new(session:).authorized?(@resource)
    end

    test "should forbid authorization with invalid access code" do
      post authorizations_path, params: {
        authorization: {
          resource_gid: @resource.to_gid.to_param,
          access_code: "WrongCode"
        }
      }

      assert_redirected_to root_url
      assert_not AuthorizationSession.new(session:).authorized?(@resource)
      assert_equal I18n.t("anonymous_authorization.invalid_access_code"), flash[:alert]
    end
    test "authorization requires CSRF when forgery protection is enabled" do
      with_forgery_protection do
        assert_raises(ActionController::InvalidAuthenticityToken) do
          post authorizations_path, params: {
            authorization: { resource_gid: @resource.to_gid.to_param, access_code: anonymous_authorization_access_codes(:one).code }
          }
        end
      end
    end

    test "authorization accepts the actual forms CSRF token" do
      with_forgery_protection do
        get new_authorization_path, params: { resource_gid: @resource.to_gid.to_param }
        token = response.parsed_body.at_css('input[name="authenticity_token"]')["value"]
        post authorizations_path, params: {
          authenticity_token: token,
          authorization: { resource_gid: @resource.to_gid.to_param, access_code: anonymous_authorization_access_codes(:one).code }
        }

        assert_redirected_to root_url
        assert AuthorizationSession.new(session:).authorized?(@resource)
      end
    end

    private

      def with_forgery_protection
        original = AnonymousAuthorization::AuthorizationsController.allow_forgery_protection
        AnonymousAuthorization::AuthorizationsController.allow_forgery_protection = true
        yield
      ensure
        AnonymousAuthorization::AuthorizationsController.allow_forgery_protection = original
      end
  end
end
