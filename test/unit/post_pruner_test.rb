require 'test_helper'

class PostPrunerTest < ActiveSupport::TestCase
  def setup
    super

    @user = FactoryBot.create(:admin_user)
    CurrentUser.user = @user
    CurrentUser.ip_addr = "127.0.0.1"
    @old_post = FactoryBot.create(:post, created_at: 31.days.ago, is_pending: true)

    PostPruner.new.prune!
  end

  def teardown
    super

    CurrentUser.user = nil
    CurrentUser.ip_addr = nil
  end

  should "prune old pending posts" do
    @old_post.reload
    assert(@old_post.is_deleted?)
  end
end
