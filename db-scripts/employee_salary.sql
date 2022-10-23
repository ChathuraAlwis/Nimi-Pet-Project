--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.4

-- Started on 2022-10-19 15:19:48

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
-- TOC entry 211 (class 1259 OID 24613)
-- Name: employee_salary; Type: TABLE; Schema: public; Owner: postgres
--

DROP TABLE IF EXISTS public.employee_salary;

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
-- TOC entry 212 (class 1259 OID 24623)
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
-- TOC entry 3179 (class 2606 OID 24625)
-- Name: employee_salary employee_salary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_salary
    ADD CONSTRAINT employee_salary_pkey PRIMARY KEY (id);


--
-- TOC entry 3185 (class 2620 OID 24626)
-- Name: employee_salary employee_salary; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER employee_salary AFTER INSERT OR DELETE OR UPDATE ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.employee_salary_logger();


--
-- TOC entry 3184 (class 2620 OID 24631)
-- Name: employee_salary epf_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER epf_net_salary_update AFTER UPDATE OF epf ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.epf_update();


--
-- TOC entry 3183 (class 2620 OID 24635)
-- Name: employee_salary etf_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER etf_net_salary_update AFTER UPDATE OF etf ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.etf_update();


--
-- TOC entry 3182 (class 2620 OID 24639)
-- Name: employee_salary other_deduction_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER other_deduction_net_salary_update AFTER UPDATE OF other_deduction ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.other_deduction_update();


--
-- TOC entry 3181 (class 2620 OID 24637)
-- Name: employee_salary tax_deduction_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tax_deduction_net_salary_update AFTER UPDATE OF tax_deduction ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.tax_deduction_update();


--
-- TOC entry 3180 (class 2620 OID 24633)
-- Name: employee_salary total_salary_net_salary_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER total_salary_net_salary_update AFTER UPDATE OF total_salary ON public.employee_salary FOR EACH ROW EXECUTE FUNCTION public.total_salary_update();


-- Completed on 2022-10-19 15:19:48

--
-- PostgreSQL database dump complete
--

