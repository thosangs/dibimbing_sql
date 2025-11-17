-- Day 15 - UNION and UNION ALL with realistic temp tables
-- psql: psql "postgresql://user:password@localhost:5432/dvdrental"

-- Scenario 1: Consolidating signups from multiple channels
CREATE TEMP TABLE web_signups (email text, signup_date date);
INSERT INTO web_signups VALUES
  ('alice@example.com', DATE '2025-10-01'),
  ('bob@example.com',   DATE '2025-10-02'),
  ('diana@example.com', DATE '2025-10-05');

CREATE TEMP TABLE store_signups (email text, signup_date date);
INSERT INTO store_signups VALUES
  ('carol@example.com', DATE '2025-10-01'),
  ('alice@example.com', DATE '2025-10-03'), -- same email signed up in-store later
  ('eric@example.com',  DATE '2025-10-06');

-- UNION ALL: keep duplicates to analyze channel overlaps
SELECT 'web'   AS source, email, signup_date FROM web_signups
UNION ALL
SELECT 'store' AS source, email, signup_date FROM store_signups
ORDER BY email, source;

-- UNION: remove duplicates to get unique emails across channels
SELECT email FROM web_signups
UNION
SELECT email FROM store_signups
ORDER BY email;


-- Scenario 2: Merge heterogenous "work" items into a single inbox
CREATE TEMP TABLE support_tickets (id int, created_at timestamp, customer_email text, subject text);
INSERT INTO support_tickets VALUES
  (1001, NOW() - INTERVAL '5 days', 'alice@example.com', 'Order not received'),
  (1002, NOW() - INTERVAL '4 days', 'bob@example.com',   'Refund status');

CREATE TEMP TABLE bug_reports (id int, created_at timestamp, reporter_email text, title text);
INSERT INTO bug_reports VALUES
  (2001, NOW() - INTERVAL '3 days', 'carol@example.com', 'App crashes on login'),
  (2002, NOW() - INTERVAL '2 days', 'alice@example.com', 'Payment page slow');

-- Align columns and combine
SELECT id, created_at, customer_email AS email, subject AS title, 'support' AS kind
FROM support_tickets
UNION ALL
SELECT id, created_at, reporter_email AS email, title, 'bug' AS kind
FROM bug_reports
ORDER BY created_at;


