require 'test_helper'

class UserPasswordResetNonceTest < ActiveSupport::TestCase
  context "Creating a new nonce" do
    setup do
      @user = FactoryBot.create(:user)
      @nonce = FactoryBot.create(:user_password_reset_nonce, user: @user)
    end

    should "validate" do
      assert_equal([], @nonce.errors.full_messages)
    end

    should "populate the key with a random string" do
      assert_equal(24, @nonce.key.size)
    end

    should "reset the password when reset" do
      @nonce.reset_user! "test", "test"
    end
  end
end
