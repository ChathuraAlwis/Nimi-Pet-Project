--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.4

-- Started on 2022-10-19 16:01:24

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

DROP DATABASE "pet-project";
--
-- TOC entry 3334 (class 1262 OID 16394)
-- Name: pet-project; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "pet-project" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';


ALTER DATABASE "pet-project" OWNER TO postgres;

\connect -reuse-previous=on "dbname='pet-project'"

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

--
-- TOC entry 229 (class 1255 OID 24602)
-- Name: employee_salary_logger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employee_salary_logger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF TG_OP = 'INSERT'
		THEN INSERT INTO public.activity_log (record_id, operation, new_val) 
		VALUES (NEW.id, TG_OP, row_to_json(NEW));
		RETURN NEW;
	ELSIF TG_OP = 'UPDATE'
		THEN INSERT INTO public.activity_log (record_id, operation, new_val, old_val)
		VALUES (NEW.id, TG_OP, row_to_json(NEW), row_to_json(OLD));
		RETURN NEW;
	ELSIF TG_OP = 'DELETE'
		THEN INSERT INTO public.activity_log(record_id, operation, old_val)
		VALUES (OLD.id, TG_OP, row_to_json(OLD));
		RETURN OLD;
	END IF;
END$$;


ALTER FUNCTION public.employee_salary_logger() OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 24628)
-- Name: epf_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.epf_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public.employee_salary SET net_salary=(OLD.net_salary - (NEW.epf - OLD.epf)) 
	WHERE id=NEW.id;
	RETURN NEW;
END$$;


ALTER FUNCTION public.epf_update() OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 24634)
-- Name: etf_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.etf_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public.employee_salary SET net_salary=(OLD.net_salary - (NEW.etf - OLD.etf)) 
	WHERE id=NEW.id;
	RETURN NEW;
END$$;


ALTER FUNCTION public.etf_update() OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 24638)
-- Name: other_deduction_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.other_deduction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public.employee_salary SET net_salary=(OLD.net_salary - (NEW.other_deduction - OLD.other_deduction)) 
	WHERE id=NEW.id;
	RETURN NEW;
END$$;


ALTER FUNCTION public.other_deduction_update() OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 24636)
-- Name: tax_deduction_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tax_deduction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public.employee_salary SET net_salary=(OLD.net_salary - (NEW.tax_deduction - OLD.tax_deduction)) 
	WHERE id=NEW.id;
	RETURN NEW;
END$$;


ALTER FUNCTION public.tax_deduction_update() OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 24632)
-- Name: total_salary_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.total_salary_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public.employee_salary SET net_salary=(OLD.net_salary - (NEW.total_salary - OLD.total_salary)) 
	WHERE id=NEW.id;
	RETURN NEW;
END$$;


ALTER FUNCTION public.total_salary_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 24660)
-- Name: activity_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_log (
    id integer NOT NULL,
    record_id integer NOT NULL,
    operation character varying(255) NOT NULL,
    new_val json,
    old_val json
);


ALTER TABLE public.activity_log OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24665)
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
-- TOC entry 209 (class 1259 OID 24640)
-- Name: employee_salary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_salary (
    id integer NOT NULL,
    emp_id integer NOT NULL,
    emp_name character varying(255) NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    total_salary numeric NOT NULL,
    epf numeric DEFAULT 0,
    etf numeric DEFAULT 0,
    tax_deduction numeric DEFAULT 0,
    other_deduction numeric DEFAULT 0,
    net_salary numeric NOT NULL,
    archived boolean DEFAULT false NOT NULL
);


ALTER TABLE public.employee_salary OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 24650)
-- Name: employee_salary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employee_salary ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.employee_salary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3183 (class 2606 OID 24667)
-- Name: activity_log activity_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT activity_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3181 (class 2606 OID 24652)
-- Name: employee_salary employee_salary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_salary
    ADD CONSTRAINT employee_salary_pkey PRIMARY KEY (id);


--
-- TOC entry 3189 (class 2620 OID 24653)
-- Name: employee_salary employee_salary; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER employee_salary AFTER INSERT OR DELETE OR UPDATE ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.employee_salary_logger();


--
-- TOC entry 3188 (class 2620 OID 24654)
-- Name: employee_salary epf_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER epf_net_salary_update AFTER UPDATE OF epf ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.epf_update();


--
-- TOC entry 3187 (class 2620 OID 24655)
-- Name: employee_salary etf_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER etf_net_salary_update AFTER UPDATE OF etf ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.etf_update();


--
-- TOC entry 3186 (class 2620 OID 24656)
-- Name: employee_salary other_deduction_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER other_deduction_net_salary_update AFTER UPDATE OF other_deduction ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.other_deduction_update();


--
-- TOC entry 3185 (class 2620 OID 24657)
-- Name: employee_salary tax_deduction_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tax_deduction_net_salary_update AFTER UPDATE OF tax_deduction ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.tax_deduction_update();


--
-- TOC entry 3184 (class 2620 OID 24658)
-- Name: employee_salary total_salary_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER total_salary_net_salary_update AFTER UPDATE OF total_salary ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.total_salary_update();


--
-- TOC entry 3335 (class 0 OID 0)
-- Dependencies: 229
-- Name: FUNCTION employee_salary_logger(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.employee_salary_logger() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.employee_salary_logger() FROM postgres;


-- Completed on 2022-10-19 16:01:24

--
-- PostgreSQL database dump complete
--

