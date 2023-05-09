class CreateAnonymousAuthorizationAccessCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :anon_access_codes do |t|
      t.belongs_to :accessible, polymorphic: true
      t.string :code
      t.datetime :expires_at

      t.timestamps
    end
  end
end
