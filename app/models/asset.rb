# == Schema Information
#
# Table name: assets
#
#  id                  :integer          not null, primary key
#  expected_return     :float
#  expected_volatility :float
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Asset < ApplicationRecord
end
