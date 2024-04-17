require 'rails_helper'

RSpec.describe Account, type: :model do
  
  describe 'Association' do
    it { should belong_to(:bank) }
    it { should have_many(:transactions) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
