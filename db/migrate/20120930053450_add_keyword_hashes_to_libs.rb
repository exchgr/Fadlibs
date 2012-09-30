class AddKeywordHashesToLibs < ActiveRecord::Migration
  def change
  	add_column :libs, :keyword_array, :string
  	add_column :libs, :value_array, :string
  end
end
