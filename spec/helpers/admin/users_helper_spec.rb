require "rails_helper"

describe Admin::UsersHelper do
  describe "#format_last_activity_timestamp" do
    it "renders the proper 'Last activity' date for a user that was active today" do
      timestamp = Time.zone.today
      date = timestamp.strftime("%d %b")
      formatted_date = helper.format_last_activity_timestamp(timestamp)
      expect(formatted_date).to eq "Today, #{date}"
    end

    it "renders the proper 'Last activity' date for a user that was active yesterday" do
      timestamp = Date.yesterday
      date = timestamp.strftime("%d %b")
      formatted_date = helper.format_last_activity_timestamp(timestamp)
      expect(formatted_date).to eq "Yesterday, #{date}"
    end

    it "renders the proper 'Last activity' date for a user that was active recently" do
      timestamp = 11.days.ago
      date = timestamp.strftime("%d %b, %Y")
      formatted_date = helper.format_last_activity_timestamp(timestamp)
      expect(formatted_date).to eq date.to_s
    end
  end

  describe "#cascading_high_level_roles" do
    let(:user) { create(:user) }

    it "renders the proper role for a Super Admin" do
      user.add_role(:super_admin)
      role = helper.cascading_high_level_roles(user)
      expect(role).to eq "Super Admin"
    end

    it "renders the proper role for an Admin" do
      user.add_role(:admin)
      role = helper.cascading_high_level_roles(user)
      expect(role).to eq "Admin"
    end

    it "renders the proper role for a Resource Admin" do
      user.add_role(:single_resource_admin, Article)
      role = helper.cascading_high_level_roles(user)
      expect(role).to eq "Resource Admin"
    end

    it "renders the proper role for a user that isn't a Super Admin, Admin, or Resource Admin" do
      user = create(:user)
      role = helper.cascading_high_level_roles(user)
      expect(role).to be_nil
    end
  end

  describe "#format_role_tooltip" do
    let(:user) { create(:user) }

    it "renders the proper tooltip for a Super Admin" do
      user.add_role(:super_admin)
      role = helper.format_role_tooltip(user)
      expect(role).to eq "Super Admin"
    end

    it "renders the proper tooltip for an Admin" do
      user.add_role(:admin)
      role = helper.format_role_tooltip(user)
      expect(role).to eq "Admin"
    end

    it "renders the proper tooltip for a Resource Admin" do
      user.add_role(:single_resource_admin, Article)
      role = helper.format_role_tooltip(user)
      expect(role).to eq "Resource Admin: Article"
    end

    it "renders the proper, comma-separated tooltip for a Resource Admin with multiple resource_types" do
      user.add_role(:single_resource_admin, Article)
      user.add_role(:single_resource_admin, Badge)
      role = helper.format_role_tooltip(user)
      expect(role).to eq "Resource Admin: Article, Badge"
    end

    it "does not render a the resource_type for a Trusted user" do
      user.add_role(:trusted)
      role = helper.format_role_tooltip(user)
      expect(role).to be_nil
    end
  end
end