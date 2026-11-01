-- Initial migration. Apply once in the D1 Dashboard console, before seed.sql.
PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS users (discord_id TEXT PRIMARY KEY, username TEXT NOT NULL, avatar TEXT, created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')), last_login TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')), testing_status TEXT NOT NULL DEFAULT 'Not enrolled');
CREATE TABLE IF NOT EXISTS sessions (id TEXT PRIMARY KEY, discord_id TEXT NOT NULL REFERENCES users(discord_id) ON DELETE CASCADE, expires_at INTEGER NOT NULL);
CREATE INDEX IF NOT EXISTS sessions_expiry ON sessions(expires_at);
CREATE TABLE IF NOT EXISTS admins (discord_id TEXT PRIMARY KEY, label TEXT NOT NULL, suspended INTEGER NOT NULL DEFAULT 0 CHECK(suspended IN(0,1)), permissions TEXT NOT NULL CHECK(json_valid(permissions)), added_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS sections (key TEXT PRIMARY KEY, visible INTEGER NOT NULL DEFAULT 1 CHECK(visible IN(0,1)), sort_order INTEGER NOT NULL DEFAULT 0, content TEXT NOT NULL DEFAULT '{}' CHECK(json_valid(content)));
CREATE TABLE IF NOT EXISTS nav_items (key TEXT PRIMARY KEY, label TEXT NOT NULL, visible INTEGER NOT NULL DEFAULT 1 CHECK(visible IN(0,1)), sort_order INTEGER NOT NULL DEFAULT 0);
CREATE TABLE IF NOT EXISTS posts (id INTEGER PRIMARY KEY AUTOINCREMENT, kind TEXT NOT NULL CHECK(kind IN('official','developer')), title TEXT NOT NULL, body TEXT NOT NULL, image_key TEXT, button_label TEXT, button_url TEXT, pinned INTEGER NOT NULL DEFAULT 0 CHECK(pinned IN(0,1)), visible INTEGER NOT NULL DEFAULT 1 CHECK(visible IN(0,1)), created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')), updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
CREATE INDEX IF NOT EXISTS posts_public ON posts(visible,created_at DESC,id DESC);
CREATE TABLE IF NOT EXISTS heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, role TEXT NOT NULL CHECK(role IN('Tank','Fighter','Assassin','Mage','Marksman','Support')), description TEXT NOT NULL DEFAULT '', image_key TEXT, visible INTEGER NOT NULL DEFAULT 0 CHECK(visible IN(0,1)), sort_order INTEGER NOT NULL DEFAULT 0);
CREATE INDEX IF NOT EXISTS heroes_public ON heroes(visible,sort_order,id);
CREATE TABLE IF NOT EXISTS staff (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, role TEXT NOT NULL, image_key TEXT, sort_order INTEGER NOT NULL DEFAULT 0, visible INTEGER NOT NULL DEFAULT 1 CHECK(visible IN(0,1)));
CREATE INDEX IF NOT EXISTS staff_public ON staff(visible,sort_order,id);
CREATE TABLE IF NOT EXISTS feedback (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL CHECK(type IN('Suggestion','Feedback','Bug')), message TEXT NOT NULL, discord_name TEXT NOT NULL DEFAULT '', status TEXT NOT NULL DEFAULT 'New' CHECK(status IN('New','Handled')), created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
CREATE INDEX IF NOT EXISTS feedback_status ON feedback(status,created_at DESC);
CREATE TABLE IF NOT EXISTS legal_pages (slug TEXT PRIMARY KEY CHECK(slug IN('terms','privacy')), title TEXT NOT NULL, body TEXT NOT NULL, updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
CREATE TABLE IF NOT EXISTS images (key TEXT PRIMARY KEY, size_bytes INTEGER NOT NULL, width INTEGER NOT NULL, height INTEGER NOT NULL, uploaded_by TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
CREATE TABLE IF NOT EXISTS audit_log (id INTEGER PRIMARY KEY AUTOINCREMENT, discord_id TEXT NOT NULL, action TEXT NOT NULL, area TEXT NOT NULL, item TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
CREATE INDEX IF NOT EXISTS audit_time ON audit_log(created_at DESC,id DESC);
-- Persistent, atomic cross-isolate rate limits. Only daily HMAC IP hashes, never raw IPs.
CREATE TABLE IF NOT EXISTS rate_limits (key TEXT PRIMARY KEY, hits INTEGER NOT NULL DEFAULT 1, expires_at INTEGER NOT NULL);
CREATE INDEX IF NOT EXISTS rate_expiry ON rate_limits(expires_at);
