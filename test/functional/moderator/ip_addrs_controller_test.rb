require 'test_helper'

module Moderator
  class IpAddrsControllerTest < ActionDispatch::IntegrationTest
    context "The ip addrs controller" do
      setup do
        travel_to(1.month.ago) do
          @user = create(:moderator_user)
        end

        as_user do
          create(:comment)
        end
      end

      should "find by ip addr" do
        get_auth moderator_ip_addrs_path, @user, params: { search: { ip_addr: "127.0.0.1" } }
        assert_response :success
      end

      should "find by user id" do
        get_auth moderator_ip_addrs_path, @user, params: { search: { user_id: @user.id } }
        assert_response :success
      end

      should "find by user name" do
        get_auth moderator_ip_addrs_path, @user, params: { search: { user_name: @user.name } }
        assert_response :success
      end
    end
  end
end
