CREATE TABLE IF NOT EXISTS auth_attempts (
  key_hash TEXT PRIMARY KEY,
  window_start TEXT NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 0
);