class ChangeRememberDigestForUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :remembe_digest, :remember_digest
  end
end
