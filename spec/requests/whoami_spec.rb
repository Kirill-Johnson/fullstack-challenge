require 'rails_helper'

RSpec.describe "WhoAmI", type: :request do
  include_context "db_cleanup_each"
  let(:account) { signup FactoryGirl.attributes_for(:user) }

  def whoami user
    jget authn_whoami_path
    expect(response).to have_http_status(:ok)
    payload=parsed_body
    if user
      expect(payload).to include("id"=>user["id"])
      expect(payload).to include("email"=>user["email"])
      expect(payload).to include("user_roles")
      payload["user_roles"]
    else 
      expect(payload).to_not include("id")
      expect(payload).to_not include("email")
      expect(payload).to_not include("user_roles")
      []
    end
  end

  shared_examples "no roles" do
    it "" do
      user_roles=whoami(user)
      expect(user_roles).to be_empty
    end
  end

  context "anonymous" do
    let(:user)    { nil }
    before(:each) { logout nil }
    it_should_behave_like "no roles"
  end
  context "authenticated" do
    let(:user)    { login account }
    it_should_behave_like "no roles"
  end
  context "admin" do
    let(:user) { apply_admin(login(account)) }
    it "has admin role" do
      user_roles=whoami(user)
      expect(user_roles.size).to eq(1)
      expect(user_roles[0]).to include("role_name"=>Role::ADMIN)
      expect(user_roles[0]).to_not include("resource")
    end
  end
end
