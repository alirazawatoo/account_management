require 'rails_helper'

RSpec.describe Transaction, type: :model do
  
  describe 'Associations' do
    it { should belong_to(:bank) }
    it { should belong_to(:account) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:date) }
  end
end
