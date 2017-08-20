--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: nb; Type: TABLE; Schema: public; Owner: jh
--

CREATE TABLE nb (
    id integer NOT NULL,
    doc_id text,
    category text,
    feature text
);


ALTER TABLE nb OWNER TO jh;

--
-- Name: nb_id_seq; Type: SEQUENCE; Schema: public; Owner: jh
--

CREATE SEQUENCE nb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nb_id_seq OWNER TO jh;

--
-- Name: nb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jh
--

ALTER SEQUENCE nb_id_seq OWNED BY nb.id;


--
-- Name: nb id; Type: DEFAULT; Schema: public; Owner: jh
--

ALTER TABLE ONLY nb ALTER COLUMN id SET DEFAULT nextval('nb_id_seq'::regclass);


--
-- Name: nb nb_pkey; Type: CONSTRAINT; Schema: public; Owner: jh
--

ALTER TABLE ONLY nb
    ADD CONSTRAINT nb_pkey PRIMARY KEY (id);


--
-- Name: nb_cat_doc_id; Type: INDEX; Schema: public; Owner: jh
--

CREATE INDEX nb_cat_doc_id ON nb USING btree (category, doc_id);


--
-- Name: nb_cat_feature; Type: INDEX; Schema: public; Owner: jh
--

CREATE INDEX nb_cat_feature ON nb USING btree (category, feature);


--
-- Name: nb_doc_id; Type: INDEX; Schema: public; Owner: jh
--

CREATE INDEX nb_doc_id ON nb USING btree (doc_id);


--
-- Name: nb_feature; Type: INDEX; Schema: public; Owner: jh
--

CREATE INDEX nb_feature ON nb USING btree (feature);


--
-- PostgreSQL database dump complete
--

