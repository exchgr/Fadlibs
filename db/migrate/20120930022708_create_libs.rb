class CreateLibs < ActiveRecord::Migration
  def change
    create_table :libs do |t|
      t.string :frame_text
      t.string :keyword_text

      t.timestamps
    end
  end
end
