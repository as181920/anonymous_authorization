require "test_helper"

module AnonymousAuthorization
  class AuthorizationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
    end

    # test "should get new" do
    #   get new_authorization_url
    #   assert_response :success
    # end
    #
    # test "should create authorization" do
    #   assert_difference("Authorization.count") do
    #     post authorizations_url, params: { authorization: {  } }
    #   end
    #
    #   assert_redirected_to authorization_url(Authorization.last)
    # end
    #
    # test "should show authorization" do
    #   get authorization_url(@authorization)
    #   assert_response :success
    # end
  end
end
