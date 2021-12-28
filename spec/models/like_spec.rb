require 'rails_helper'

RSpec.describe Like, type: :model do

let!(:like) { create(:like)}

  describe  do
    context 'Validations' do

      it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) }

      it 'expect not be valid without user and post' do
        like = Like.new
        expect(like).to_not be_valid
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
