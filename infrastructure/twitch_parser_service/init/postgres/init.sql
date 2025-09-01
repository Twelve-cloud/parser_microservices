-- This executes if the data folder is empty otherwise it is not executed

-- Create database
CREATE DATABASE "twitch";

-- Create users with passwords
CREATE USER "twitch-parser" WITH PASSWORD 'password';
CREATE USER "pgadmin" WITH PASSWORD 'password';

-- Grant all privileges on the twitch database to twitch-parser and pgadmin users
GRANT ALL PRIVILEGES ON DATABASE "twitch" TO "twitch-parser";
GRANT ALL PRIVILEGES ON DATABASE "twitch" TO "pgadmin";

-- Connect twitch database
\c "twitch"

-- Grant all privileges on the public schema to twitch-parser and pgadmin users
GRANT ALL ON SCHEMA public TO "twitch-parser";
GRANT ALL ON SCHEMA public TO "pgadmin";
