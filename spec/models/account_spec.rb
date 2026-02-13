require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'валідації' do
    it 'не дозволяє однаковий емейл' do
      create(:account, email: 'artem@test.com')
      user2 = build(:account, email: 'artem@test.com')

      user2.valid?
      expect(user2.errors.details[:email].any? { |e| e[:error] == :taken }).to be true
    end

    it 'викидає помилку бази даних при спробі запису дубліката' do
      create(:account, email: 'artem@test.com')
      user2 = build(:account, email: 'artem@test.com')

      expect { user2.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end


describe 'scopes' do
    describe '.active' do
    let!(:active_user) { create(:account, username: 'artem_top') }
    let!(:inactive_user) do
        user = build(:account, username: nil)
        user.save(validate: false) 
        user
    end

    it 'повертає лише користувачів із заповненим юзернеймом' do
        result = Account.active

        expect(result).to include(active_user)
        expect(result).not_to include(inactive_user)
    end
  end
end
  

  describe 'асоціації' do
    let!(:account) { create(:account) }
    let!(:post) { create(:post, account: account) }

    it 'видаляє залежні реакції при видаленні акаунта' do
      create(:reaction, account: account, post: post)
      
      expect { account.destroy }.to change(Reaction, :count).by(-1)
    end

    it 'видаляє залежні коментарі при видаленні акаунта' do
      create(:comment, account: account, post: post)
      
      expect { account.destroy }.to change(Comment, :count).by(-1)
    end
  end
end