require '../invite_service'

RSpec.describe InviteService, "#find_customers_in_range" do


  context "with invalid gps point" do
    let(:invite) { InviteService.new(customers_file: "test.json") }
    it "raise exception" do
      expect { invite.find_customers_in_range }.to raise_error(IOError, "No such file or directory! - #{invite.customers_file}")
    end
  end

  context "with valid arguments" do
    let(:invite) { InviteService.new }
    it "returns array of invites users" do
      expect(invite.find_customers_in_range.size).to eq(16)
    end
  end
end
