class AddStreamIdToHeroTable < ActiveRecord::Migration
  def change
    add_column :heros, :stream_id, :integer, :default => 1
  end
end
