require "test_helper"

module AnonymousAuthorization
  class AccessGuardTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @resource = dummy_articles(:one)
      @session_id = Rack::Session::SessionId.new(SecureRandom.hex)
      ActionDispatch::Request::Session.any_instance.stubs(:id).returns(@session_id)
      AccessSessionService.new(@session_id).clear(@resource)
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
      assert AccessSessionService.new(session.id).authorized?(@resource)
    end
  end
end
