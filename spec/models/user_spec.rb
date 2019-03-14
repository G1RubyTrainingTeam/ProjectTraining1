require "rails_helper"

RSpec.shared_examples "can_post_course" do |role|
  it "get #{role}" do
    user = FactoryBot.create(:user, role: role)
    can_post_course = [user.name, user.id]
    expect(User.can_post_course).to include can_post_course
  end
end

RSpec.describe User, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:active_relationships).
      dependent(:destroy).
      with_foreign_key("follower_id").
      class_name("Relationship") }
    it { is_expected.to have_many(:passive_relationships).
      with_foreign_key("followed_id").
      dependent(:destroy).class_name("Relationship") }
    it { is_expected.to have_many(:following).
      source(:followed).through(:active_relationships) }
    it { is_expected.to have_many(:followers).through(:passive_relationships) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
    it { is_expected.to have_many(:courses).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_one(:wallet).dependent(:destroy) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "Delegate" do
    it { is_expected.to delegate_method(:account).to(:wallet).
      with_prefix(:wallet).allow_nil }
  end

  describe "Enum" do
    it { is_expected.to define_enum_for(:role).
      with_values(student: 0,lecture: 1, admin: 2).
      backed_by_column_of_type(:integer) }
  end

  describe "Scope" do
    context "can_post_course" do
      it_behaves_like "can_post_course", "admin"
      it_behaves_like "can_post_course", "lecture"
      it "get student" do
        user = FactoryBot.create(:user, role: "student")
        can_post_course = [user.name, user.id]
        expect(User.can_post_course).to_not include can_post_course
      end
    end
  end
end
