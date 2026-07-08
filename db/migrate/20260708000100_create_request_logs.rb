class CreateRequestLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :request_logs do |t|
      t.string :query, null: false
      t.string :engine, null: false
      t.integer :page, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.integer :duration_ms
      t.jsonb :response, null: false, default: {}
      t.text :error
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :request_logs, %i[query engine created_at]
    add_index :request_logs, :status
  end
end
