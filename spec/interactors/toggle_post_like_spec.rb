require 'rails_helper'

RSpec.describe TogglePostLike, type: :interactor do
  describe '.call' do
    let(:account) { create(:account) }
    let(:post_record) { create(:post) }

    context 'when no reaction exists' do
      it 'creates a reaction and marks created in context' do
        result = described_class.call(account: account, post: post_record)

        expect(result.success?).to be true
        expect(result.created).to be_truthy
        expect(result.reaction).to be_present
        expect(Reaction.exists?(result.reaction.id)).to be true
      end
    end

    context 'when a reaction already exists' do
      before do
        # Reaction requires a polymorphic target to exist (target: post)
        Reaction.create!(account: account, post: post_record, target: post_record)
      end

      it 'destroys the reaction and marks deleted in context' do
        expect {
          result = described_class.call(account: account, post: post_record)
          expect(result.success?).to be true
          expect(result.deleted).to be_truthy
        }.to change(Reaction, :count).by(-1)
      end
    end

    context 'when required context is missing' do
      it 'fails when account is nil' do
        result = described_class.call(account: nil, post: post_record)
        expect(result.success?).to be false
        expect(result.message).to be_present
      end

      it 'fails when post is nil' do
        result = described_class.call(account: account, post: nil)
        expect(result.success?).to be false
        expect(result.message).to be_present
      end
    end
  end
end
