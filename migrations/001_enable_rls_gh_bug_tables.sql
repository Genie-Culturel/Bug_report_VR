-- Enable RLS on gh_bug_sessions and gh_bug_entries tables
-- This migration restores the public-PIN workflow where client-side PIN authentication
-- (handled in JavaScript) gates all database access via the anon role.

-- Enable Row Level Security on both tables
ALTER TABLE gh_bug_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE gh_bug_entries ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (for idempotency)
DROP POLICY IF EXISTS "anon_select_gh_bug_sessions" ON gh_bug_sessions;
DROP POLICY IF EXISTS "anon_insert_gh_bug_sessions" ON gh_bug_sessions;
DROP POLICY IF EXISTS "anon_update_gh_bug_sessions" ON gh_bug_sessions;
DROP POLICY IF EXISTS "anon_delete_gh_bug_sessions" ON gh_bug_sessions;

DROP POLICY IF EXISTS "anon_select_gh_bug_entries" ON gh_bug_entries;
DROP POLICY IF EXISTS "anon_insert_gh_bug_entries" ON gh_bug_entries;
DROP POLICY IF EXISTS "anon_update_gh_bug_entries" ON gh_bug_entries;
DROP POLICY IF EXISTS "anon_delete_gh_bug_entries" ON gh_bug_entries;

-- Create policies for gh_bug_sessions
CREATE POLICY "anon_select_gh_bug_sessions"
  ON gh_bug_sessions FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "anon_insert_gh_bug_sessions"
  ON gh_bug_sessions FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "anon_update_gh_bug_sessions"
  ON gh_bug_sessions FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "anon_delete_gh_bug_sessions"
  ON gh_bug_sessions FOR DELETE
  TO anon
  USING (true);

-- Create policies for gh_bug_entries
CREATE POLICY "anon_select_gh_bug_entries"
  ON gh_bug_entries FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "anon_insert_gh_bug_entries"
  ON gh_bug_entries FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "anon_update_gh_bug_entries"
  ON gh_bug_entries FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "anon_delete_gh_bug_entries"
  ON gh_bug_entries FOR DELETE
  TO anon
  USING (true);

-- Grant necessary permissions to anon role
GRANT SELECT, INSERT, UPDATE, DELETE ON gh_bug_sessions TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON gh_bug_entries TO anon;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;
