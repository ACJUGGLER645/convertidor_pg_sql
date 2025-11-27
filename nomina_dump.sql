--
-- PostgreSQL database dump
--

\restrict CjyufOoFe2bze2g7iCoAd3Jr6mpKCaUjznLbq3MycdhOWxLp2t7USDi8nCJAywV

-- Dumped from database version 15.14 (Homebrew)
-- Dumped by pg_dump version 15.14 (Homebrew)

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
-- Name: depto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.depto (
    iddepto integer NOT NULL,
    descrip character varying(40),
    localidad character varying(30)
);


ALTER TABLE public.depto OWNER TO postgres;

--
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    idemp integer NOT NULL,
    apellidos character varying(50),
    nombres character varying(50),
    cargo character varying(30),
    salario double precision,
    comm double precision,
    iddepto integer,
    idjefe integer
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- Data for Name: depto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depto (iddepto, descrip, localidad) FROM stdin;
10	Gerencia	Bogotá
20	Sub-gerencia	Bogotá
30	Contabilidad	Bogotá
40	Ventas	Bogotá
50	Recursos Humanos	Bogotá
\.


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleado (idemp, apellidos, nombres, cargo, salario, comm, iddepto, idjefe) FROM stdin;
12	Rodríguez Beltrán	manuel 	Sub-Gerente	6000	0	10	1
101	Alvarez Corniza	Antonio José	Asistente de Contabilidad	2000	0	20	100
10	Morales Cañón	Humberto\n José	Gerente	10000	0	10	0
200	Acosta Cabrera	Andrés	Director de Ventas	3000	0	40	1
202	Castillo Gil	Johnson Stiven	Vendedor	1500	1500	40	200
104	Gonzalez Médez	Andres Felipe	Asistente Contabilidad	2000	0	20	100
106	Casas Arroyo	Pedro Manuel	Contador	3000	0	20	100
201	Arevalo Angel	Tomás David	Vendedor	1500	4000	40	200
203	Cuervo Bello	Jahider Felipe	Vendedor	1500	3500	40	200
100	Martínez Gómez	Kevin Elías 	Director Contabolidad	3000	0	20	1
\.


--
-- Name: depto depto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depto
    ADD CONSTRAINT depto_pkey PRIMARY KEY (iddepto);


--
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (idemp);


--
-- Name: empleado empleado_iddepto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_iddepto_fkey FOREIGN KEY (iddepto) REFERENCES public.depto(iddepto) NOT VALID;


--
-- PostgreSQL database dump complete
--

\unrestrict CjyufOoFe2bze2g7iCoAd3Jr6mpKCaUjznLbq3MycdhOWxLp2t7USDi8nCJAywV

