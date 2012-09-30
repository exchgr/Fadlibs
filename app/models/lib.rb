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

class Lib < ActiveRecord::Base
  # attr_accessible :title, :body
end
