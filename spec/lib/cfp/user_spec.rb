require "spec_helper"

describe Cfp::User do
  subject do
    user       = User.new
    user.roles = []
    user
  end

  describe "#setup_roles" do
    context "roles is nil" do
      before do
        subject.roles = nil
      end

      it "sets it as []" do
        subject.setup_roles
        subject.roles.should eq []
      end
    end

    context "roles has something" do
      before do
        subject.roles = [1, 2, 3]
      end

      it "leaves the original value" do
        subject.roles.should eq [1, 2, 3]
      end
    end
  end

  describe "#can_review?" do
    context "user has 'reviewer' role" do
      before { subject.roles = [:reviewer] }

      it "returns true" do
        subject.can_review?.should be_true
      end
    end

    context "user doesn't have 'reviewer' role" do
      before { subject.roles = [] }

      it "returns false" do
        subject.can_review?.should be_false
      end
    end
  end

  describe "#is_admin?" do
    context "has the admin role" do
      before { subject.roles = [:admin] }
      specify { subject.is_admin?.should be_true }
    end

    context "has no admin role" do
      specify { subject.is_admin?.should be_false }
    end
  end

  describe "#should_create_profile?" do
    context "the user is reviewer" do
      before  { subject.roles = [:reviewer] }
      specify { subject.should_create_profile?.should be_false }
    end

    context "the user is admin" do
      before  { subject.roles = [:admin] }
      specify { subject.should_create_profile?.should be_false }
    end

    context "user has profile" do
      before { subject.profile = Cfp::Profile.new }
      specify { subject.should_create_profile?.should be_false }
    end

    specify { subject.should_create_profile?.should be_true }
  end

  describe "#make_reviewer" do
    context "user is not reviewer" do
      before do
        subject.roles = []
        subject.should_receive :save
        subject.make_reviewer
      end

      specify { subject.roles.should == [ :reviewer ] }
    end

    context "user is reviewer" do
      before do
        subject.roles = [ :reviewer ]
        subject.should_not_receive :save
        subject.make_reviewer
      end

      specify { subject.roles.should == [ :reviewer ] }
    end
  end
end
