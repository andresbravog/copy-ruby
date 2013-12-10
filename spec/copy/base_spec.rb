require "spec_helper"

describe Copy::Base do
  describe "#parse_timestamps" do
    context "given #created_time is present" do
      it "creates a Time object" do
        base = Copy::Base.new(created_time: 1358300444)
        expect(base.created_time.class).to eql(Time)
      end
    end
  end
end
