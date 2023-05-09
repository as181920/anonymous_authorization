class CreateTestArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :test_articles do |t|
      t.string :name

      t.timestamps
    end
  end
end
