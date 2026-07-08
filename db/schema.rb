ActiveRecord::Schema[7.2].define(version: 2026_07_08_000100) do
  enable_extension "plpgsql"

  create_table "request_logs", force: :cascade do |t|
    t.string "query", null: false
    t.string "engine", null: false
    t.integer "page", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.integer "duration_ms"
    t.jsonb "response", default: {}, null: false
    t.text "error"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["query", "engine", "created_at"], name: "index_request_logs_on_query_and_engine_and_created_at"
    t.index ["status"], name: "index_request_logs_on_status"
  end
end
