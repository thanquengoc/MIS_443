-- =============================================================================
-- MIS 443 - 03_load_new_chinook.sql
-- Database : mis443_chinook
-- Run after : 02_create_new_schema.sql
-- =============================================================================

---/// POPULATE TABLES ///---
INSERT INTO new_chinook.artist (artist_id, name)
SELECT artist_id, name
FROM public.artist;

INSERT INTO new_chinook.album (album_id, title, artist_id)
SELECT album_id, title, artist_id
FROM public.album;

INSERT INTO new_chinook.genre SELECT genre_id, name FROM public.genre;

INSERT INTO new_chinook.media_type SELECT media_type_id, name FROM public.media_type;

INSERT INTO new_chinook.playlist SELECT playlist_id, name FROM public.playlist;

INSERT INTO new_chinook.employee
SELECT employee_id, last_name, first_name, title, reports_to,
       birth_date::DATE, hire_date::DATE,
       address, city, state, country, postal_code, phone, fax, email
FROM public.employee;

INSERT INTO new_chinook.track SELECT * FROM public.track;

INSERT INTO new_chinook.customer SELECT * FROM public.customer;

INSERT INTO new_chinook.playlist_track SELECT * FROM public.playlist_track;

INSERT INTO new_chinook.invoice SELECT * FROM public.invoice;

INSERT INTO new_chinook.invoice_line SELECT * FROM public.invoice_line;


---/// CROSS-CHECK ///---
-- Every row must show the same count in both columns. Screenshot this output
-- for the report: it is the evidence that the re-implementation is faithful.
SELECT 'artist' AS table_name, (SELECT COUNT(*) FROM public.artist) AS public_result, (SELECT COUNT(*) FROM new_chinook.artist) AS new_chinook_result
UNION ALL SELECT 'album',          (SELECT COUNT(*) FROM public.album),          (SELECT COUNT(*) FROM new_chinook.album)
UNION ALL SELECT 'genre',          (SELECT COUNT(*) FROM public.genre),          (SELECT COUNT(*) FROM new_chinook.genre)
UNION ALL SELECT 'media_type',     (SELECT COUNT(*) FROM public.media_type),     (SELECT COUNT(*) FROM new_chinook.media_type)
UNION ALL SELECT 'playlist',       (SELECT COUNT(*) FROM public.playlist),       (SELECT COUNT(*) FROM new_chinook.playlist)
UNION ALL SELECT 'employee',       (SELECT COUNT(*) FROM public.employee),       (SELECT COUNT(*) FROM new_chinook.employee)
UNION ALL SELECT 'track',          (SELECT COUNT(*) FROM public.track),          (SELECT COUNT(*) FROM new_chinook.track)
UNION ALL SELECT 'customer',       (SELECT COUNT(*) FROM public.customer),       (SELECT COUNT(*) FROM new_chinook.customer)
UNION ALL SELECT 'playlist_track', (SELECT COUNT(*) FROM public.playlist_track), (SELECT COUNT(*) FROM new_chinook.playlist_track)
UNION ALL SELECT 'invoice',        (SELECT COUNT(*) FROM public.invoice),        (SELECT COUNT(*) FROM new_chinook.invoice)
UNION ALL SELECT 'invoice_line',   (SELECT COUNT(*) FROM public.invoice_line),   (SELECT COUNT(*) FROM new_chinook.invoice_line);
