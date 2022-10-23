--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.4

-- Started on 2022-10-19 15:20:23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 24605)
-- Name: activity_log; Type: TABLE; Schema: public; Owner: postgres
--
DROP TABLE IF EXISTS public.activity_log;

CREATE TABLE public.activity_log (
    id integer NOT NULL,
    record_id integer NOT NULL,
    operation character varying(255) NOT NULL,
    new_val json,
    old_val json
);


ALTER TABLE public.activity_log OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 24610)
-- Name: activity_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.activity_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.activity_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3174 (class 2606 OID 24612)
-- Name: activity_log activity_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT activity_log_pkey PRIMARY KEY (id);


-- Completed on 2022-10-19 15:20:24

--
-- PostgreSQL database dump complete
--

