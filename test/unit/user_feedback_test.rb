require 'test_helper'

class UserFeedbackTest < ActiveSupport::TestCase
  context "A user's feedback" do
    setup do
      @user = create(:user)
      @mod = create(:moderator_user)
      CurrentUser.user = @mod
      CurrentUser.ip_addr = "127.0.0.1"
    end

    teardown do
      CurrentUser.user = nil
      CurrentUser.ip_addr = nil
    end

    should "create a dmail" do
      dmail = <<~EOS.chomp
        @#{@mod.name} created a "positive record":/user_feedbacks?search[user_id]=#{@user.id} for your account:

        good job!
      EOS
      assert_difference("Dmail.count", 1) do
        FactoryBot.create(:user_feedback, user: @user, body: "good job!")
        assert_equal(dmail, @user.dmails.last.body)
      end
    end

    should "not validate if the creator is the user" do
      feedback = FactoryBot.build(:user_feedback, user: @mod)
      feedback.save
      assert_equal(["You cannot submit feedback for yourself"], feedback.errors.full_messages)
    end

    should "not validate if the creator has no permissions" do
      privileged = FactoryBot.create(:privileged_user)

      CurrentUser.user = privileged
      feedback = FactoryBot.build(:user_feedback, user: @user)
      feedback.save
      assert_equal(["You must be moderator"], feedback.errors.full_messages)
    end
  end
end
