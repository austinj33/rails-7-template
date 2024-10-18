class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.string :name
      t.float :expected_return
      t.float :expected_volatility

      t.timestamps
    end
  end
end
