require 'rails_helper'

RSpec.describe Reaction, type: :model do
    it 'не є валідним без акаунта' do
        reaction = build(:reaction, account: nil)
        expect(reaction).not_to be_valid
        expect(reaction.errors.details[:account].any? { |e| e[:error] == :blank }).to be true
        
    end
end
