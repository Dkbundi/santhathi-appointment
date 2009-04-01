class CreatePrescribedTests < ActiveRecord::Migration
  def self.up
    create_table :prescribed_tests do |t|
      t.integer :prescription_id
      t.integer :service_id
      t.string :result
    end
  end

  def self.down
    drop_table :prescribed_tests
  end
end
