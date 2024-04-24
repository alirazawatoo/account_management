require 'rails_helper'

RSpec.describe Bank, type: :model do

  describe 'Associations' do
    it { should have_many(:transactions) }
    it { should have_many(:accounts) }    
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
