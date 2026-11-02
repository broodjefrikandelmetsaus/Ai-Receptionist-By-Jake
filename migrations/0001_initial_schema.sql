PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS businesses (
  id TEXT PRIMARY KEY, name TEXT NOT NULL, slug TEXT NOT NULL UNIQUE,
  default_language TEXT NOT NULL DEFAULT 'nl' CHECK (default_language IN ('nl','en')),
  timezone TEXT NOT NULL DEFAULT 'Europe/Amsterdam', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS agents (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL UNIQUE REFERENCES businesses(id) ON DELETE CASCADE,
  display_name TEXT NOT NULL DEFAULT 'Jake AI',
  greeting_nl TEXT NOT NULL DEFAULT 'Goedendag! U spreekt met de AI-receptionist. Waarmee kan ik u helpen?',
  greeting_en TEXT NOT NULL DEFAULT 'Hello! You are speaking with the AI receptionist. How can I help you?',
  instructions TEXT NOT NULL DEFAULT '', voice_language TEXT NOT NULL DEFAULT 'nl-NL',
  enabled INTEGER NOT NULL DEFAULT 1 CHECK (enabled IN (0,1)), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS services (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  name TEXT NOT NULL, description TEXT NOT NULL DEFAULT '',
  duration_minutes INTEGER NOT NULL DEFAULT 30 CHECK (duration_minutes BETWEEN 5 AND 480),
  price_cents INTEGER, active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS opening_hours (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  weekday INTEGER NOT NULL CHECK (weekday BETWEEN 0 AND 6), opens_at TEXT, closes_at TEXT,
  closed INTEGER NOT NULL DEFAULT 0 CHECK (closed IN (0,1)), UNIQUE (business_id, weekday)
);
CREATE TABLE IF NOT EXISTS contacts (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  name TEXT NOT NULL, email TEXT, phone TEXT, notes TEXT NOT NULL DEFAULT '', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS appointments (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  service_id TEXT REFERENCES services(id) ON DELETE SET NULL, contact_id TEXT REFERENCES contacts(id) ON DELETE SET NULL,
  starts_at TEXT NOT NULL, ends_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'booked' CHECK (status IN ('booked','cancelled','completed')),
  source TEXT NOT NULL DEFAULT 'web' CHECK (source IN ('web','phone','manual')), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS conversations (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  channel TEXT NOT NULL DEFAULT 'web' CHECK (channel IN ('web','phone')), language TEXT NOT NULL DEFAULT 'nl',
  started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, ended_at TEXT, summary TEXT NOT NULL DEFAULT ''
);
CREATE TABLE IF NOT EXISTS messages (
  id TEXT PRIMARY KEY, conversation_id TEXT NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user','assistant','system')), content TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS phone_numbers (
  id TEXT PRIMARY KEY, business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  e164 TEXT NOT NULL UNIQUE, provider TEXT NOT NULL DEFAULT 'sip', status TEXT NOT NULL DEFAULT 'unconfigured',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS usage_daily (
  business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  usage_date TEXT NOT NULL, ai_requests INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (business_id, usage_date)
);
CREATE TABLE IF NOT EXISTS platform_usage (
  usage_date TEXT PRIMARY KEY, ai_requests INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_services_business ON services(business_id, active);
CREATE INDEX IF NOT EXISTS idx_contacts_business ON contacts(business_id, created_at);
CREATE INDEX IF NOT EXISTS idx_appointments_business_start ON appointments(business_id, starts_at);
CREATE INDEX IF NOT EXISTS idx_conversations_business_start ON conversations(business_id, started_at);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id, created_at);
