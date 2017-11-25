CREATE EXTENSION "pgcrypto";
CREATE EXTENSION "uuid-ossp";

CREATE OR REPLACE FUNCTION public.integrity_enforcement() RETURNS TRIGGER AS $$
BEGIN
	NEW.id = OLD.id;
	NEW.genesis = OLD.genesis;
	NEW.modified = current_timestamp;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


---- Auth Dependencies ----

CREATE SCHEMA IF NOT EXISTS water AUTHORIZATION water_user;

SET SEARCH_PATH TO water,public;

CREATE TABLE user_login (
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT,
	active BOOLEAN DEFAULT TRUE
);

GRANT SELECT, INSERT, UPDATE, DELETE ON user_login TO water_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON user_login
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();

CREATE TABLE users (
	id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	genesis TIMESTAMPTZ DEFAULT now(),
	modified TIMESTAMPTZ DEFAULT now(),
	name TEXT,
	street TEXT,
	city TEXT,
	state TEXT,
	zip TEXT,
	active BOOLEAN DEFAULT TRUE
);

GRANT SELECT, INSERT, UPDATE, DELETE ON users TO water_user;
CREATE TRIGGER integrity_enforcement BEFORE UPDATE ON users
	FOR EACH ROW EXECUTE PROCEDURE public.integrity_enforcement();
	