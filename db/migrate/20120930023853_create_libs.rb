class CreateLibs < ActiveRecord::Migration
  def change
    create_table :libs do |t|

      t.timestamps
    end
  end
end
