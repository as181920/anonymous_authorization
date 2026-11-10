require "test_helper"

module AnonymousAuthorization
  class AuthorizationSessionTest < ActiveSupport::TestCase
    setup do
      @resource = dummy_articles(:one)
      @original_cache = Rails.cache
      Rails.cache = ActiveSupport::Cache::MemoryStore.new
      @session = ActionController::TestSession.new
      @authorization = AuthorizationSession.new(session: @session)
    end

    teardown do
      Rails.cache = @original_cache
    end

    test "authorizes the current resource" do
      code = @authorization.authorize(@resource)

      assert_equal AccessCodeService.new(@resource).current_code, code
      assert @authorization.authorized?(@resource)
    end

    test "clear removes only the specified resource authorization" do
      other = DummyArticle.create!(name: "Another article")
      @authorization.authorize(@resource)
      @authorization.authorize(other)
      @authorization.clear(@resource)

      refute @authorization.authorized?(@resource)
      assert @authorization.authorized?(other)
    end

    test "authorization expires after the default day even when expiry is nil" do
      @authorization.authorize(@resource, expires_at: nil)

      travel 1.day + 1.second do
        refute @authorization.authorized?(@resource)
      end
    end

    test "explicit expiry is honored without being extended by reads" do
      @authorization.authorize(@resource, expires_at: 2.minutes.from_now)

      travel 1.minute do
        assert @authorization.authorized?(@resource)
      end
      travel 3.minutes do
        refute @authorization.authorized?(@resource)
      end
    end

    test "changing the resource access code invalidates its existing authorization" do
      @authorization.authorize(@resource)
      AccessCode.find_by!(accessible: @resource).update!(code: "NEW-CODE")

      refute @authorization.authorized?(@resource)
    end

    test "authorization is isolated between session instances" do
      @authorization.authorize(@resource)
      other = AuthorizationSession.new(session: ActionController::TestSession.new)

      refute other.authorized?(@resource)
    end

    test "uninitialized session checks and clearing do not initialize a session" do
      session = stub(id: nil)
      session.expects(:update).never
      authorization = AuthorizationSession.new(session:)

      refute authorization.authorized?(@resource)
      assert_nil authorization.clear(@resource)
    end

    test "authorizing preserves existing session contents" do
      @session[:usr_user_id] = 1
      @session[:tnt_user_id] = 2
      before = @session.to_hash
      @authorization.authorize(@resource)

      assert_equal before, @session.to_hash
    end
  end
end
