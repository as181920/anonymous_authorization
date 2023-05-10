class CreateTestArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :dummy_articles do |t|
      t.string :name
    end
  end
end
