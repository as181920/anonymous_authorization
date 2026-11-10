require "test_helper"

module AnonymousAuthorization
  class AccessGuardTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @resource = dummy_articles(:one)
      @original_cache = Rails.cache
      Rails.cache = ActiveSupport::Cache::MemoryStore.new
    end

    teardown do
      Rails.cache = @original_cache
    end

    test "should verify access code before resource show" do
      get dummy_article_path(@resource)

      assert_redirected_to anonymous_authorization.new_authorization_path(
        redirect_url: dummy_article_url(@resource),
        resource_gid: @resource.to_gid.to_param,
        resource_name: @resource.name
      )
    end

    test "should show resource anonymously for authorized" do
      redirect_url = dummy_article_url(@resource)

      post authorizations_path params: {
        authorization: {
          redirect_url:,
          resource_gid: @resource.to_gid.to_param,
          access_code: anonymous_authorization_access_codes(:one).code
        }
      }

      assert_redirected_to redirect_url
      assert AuthorizationSession.new(session:).authorized?(@resource)
    end
    test "successful authorization survives the redirect with real browser cookies" do
      post authorizations_path, params: {
        authorization: { resource_gid: @resource.to_gid.to_param, access_code: anonymous_authorization_access_codes(:one).code,
                         redirect_url: dummy_article_url(@resource) }
      }
      follow_redirect!

      assert_response :success
      assert_equal "FILLER CONTENT", response.body
    end

    test "another browser cannot use the authorized browsers grant" do
      post authorizations_path, params: {
        authorization: { resource_gid: @resource.to_gid.to_param, access_code: anonymous_authorization_access_codes(:one).code }
      }
      other = open_session
      other.get Rails.application.routes.url_helpers.dummy_article_path(@resource)

      assert_equal 302, other.response.status
      assert_equal URI(new_authorization_url).path, URI(other.response.location).path
    end

    test "authorization accepts an expiry serialized by the browser" do
      post authorizations_path, params: {
        authorization: { resource_gid: @resource.to_gid.to_param, access_code: anonymous_authorization_access_codes(:one).code,
                         expires_at: 2.minutes.from_now.iso8601 }
      }
      path = Rails.application.routes.url_helpers.dummy_article_path(@resource)
      get path

      assert_response :success
      travel 3.minutes do
        get path

        assert_response :redirect
      end
    end

    test "checking an unauthorized browser does not initialize its session" do
      get dummy_article_path(@resource)

      assert_nil session.id
    end
  end
end
