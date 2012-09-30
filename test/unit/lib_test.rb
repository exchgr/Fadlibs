# == Schema Information
#
# Table name: libs
#
#  id           :integer          not null, primary key
#  frame_text   :string(255)
#  keyword_text :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class LibTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
