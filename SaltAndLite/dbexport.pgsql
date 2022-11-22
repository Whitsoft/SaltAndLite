--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

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
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    id bigint NOT NULL,
    fallfee integer,
    springfee integer,
    location character varying(255),
    period_id bigint,
    section_id bigint,
    teacher_id bigint,
    helper1_id bigint,
    helper2_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    classtitle_id bigint,
    semester integer
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classes_id_seq OWNER TO postgres;

--
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- Name: classtitles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classtitles (
    id bigint NOT NULL,
    description character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.classtitles OWNER TO postgres;

--
-- Name: classtitles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classtitles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classtitles_id_seq OWNER TO postgres;

--
-- Name: classtitles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classtitles_id_seq OWNED BY public.classtitles.id;


--
-- Name: registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registrations (
    id bigint NOT NULL,
    student_id bigint,
    class_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    semester integer NOT NULL
);


ALTER TABLE public.registrations OWNER TO postgres;

--
-- Name: fall_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fall_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fall_registrations_id_seq OWNER TO postgres;

--
-- Name: fall_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fall_registrations_id_seq OWNED BY public.registrations.id;


--
-- Name: periods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periods (
    id bigint NOT NULL,
    "time" character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.periods OWNER TO postgres;

--
-- Name: periods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.periods_id_seq OWNER TO postgres;

--
-- Name: periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.periods_id_seq OWNED BY public.periods.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id bigint NOT NULL,
    title character varying(255),
    lastname character varying(255),
    firstname character varying(255),
    spousename character varying(255),
    streetaddress character varying(255),
    city character varying(255),
    state character varying(255),
    zipcode character varying(255),
    phoneone character varying(255),
    phonetwo character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profiles_id_seq OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    id bigint NOT NULL,
    description character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_id_seq OWNER TO postgres;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id bigint NOT NULL,
    firstname character varying(255),
    grade character varying(255),
    birthday character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_id_seq OWNER TO postgres;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255),
    email_address character varying(255),
    hashed_password character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    current character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- Name: classtitles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classtitles ALTER COLUMN id SET DEFAULT nextval('public.classtitles_id_seq'::regclass);


--
-- Name: periods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods ALTER COLUMN id SET DEFAULT nextval('public.periods_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: registrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations ALTER COLUMN id SET DEFAULT nextval('public.fall_registrations_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id, fallfee, springfee, location, period_id, section_id, teacher_id, helper1_id, helper2_id, inserted_at, updated_at, classtitle_id, semester) FROM stdin;
4	30	\N	\N	1	9	83	96	89	2022-06-08 00:00:00	2022-06-08 00:00:00	4	\N
6	15	\N	\N	5	5	49	80	70	2022-06-08 00:00:00	2022-06-08 00:00:00	4	\N
1	7	\N	\N	1	2	65	74	92	2022-06-08 00:00:00	2022-06-08 00:00:00	1	\N
2	3	\N	\N	4	6	63	52	92	2022-06-08 00:00:00	2022-06-08 00:00:00	2	\N
3	12	\N	\N	5	4	53	60	104	2022-06-08 00:00:00	2022-06-08 00:00:00	3	\N
7	20	\N	\N	1	9	49	79	82	2022-06-08 00:00:00	2022-06-08 00:00:00	7	\N
8	5	\N	\N	4	9	71	77	82	2022-06-08 00:00:00	2022-06-08 00:00:00	10	\N
9	5	\N	\N	5	5	78	74	94	2022-06-08 00:00:00	2022-06-08 00:00:00	11	\N
5	10	\N	\N	2	7	67	71	91	2022-06-08 00:00:00	2022-06-08 00:00:00	5	\N
10	20	\N	\N	1	7	71	93	89	2022-06-08 00:00:00	2022-06-08 00:00:00	12	\N
11	30	\N	\N	2	7	83	96	95	2022-06-08 00:00:00	2022-06-08 00:00:00	13	\N
15	5	\N	\N	5	2	70	79	90	2022-06-08 00:00:00	2022-06-08 00:00:00	17	\N
16	0	\N	\N	2	3	75	79	90	2022-06-08 00:00:00	2022-06-08 00:00:00	19	\N
17	0	\N	\N	4	3	49	79	90	2022-06-08 00:00:00	2022-06-08 00:00:00	19	\N
18	0	\N	\N	5	3	71	79	90	2022-06-08 00:00:00	2022-06-08 00:00:00	19	\N
12	2	\N	\N	5	7	79	82	63	2022-06-08 00:00:00	2022-06-08 00:00:00	13	\N
13	10	\N	\N	1	6	97	80	102	2022-06-08 00:00:00	2022-06-08 00:00:00	14	\N
14	5	\N	\N	4	7	85	104	94	2022-06-08 00:00:00	2022-06-08 00:00:00	16	\N
34	20	\N	\N	4	13	96	72	93	2022-06-08 00:00:00	2022-06-08 00:00:00	4	\N
37	5	\N	\N	2	9	106	63	102	2022-06-08 00:00:00	2022-06-08 00:00:00	9	\N
38	18	\N	\N	4	9	67	87	54	2022-06-08 00:00:00	2022-06-08 00:00:00	6	\N
24	15	\N	\N	1	7	50	77	90	2022-06-08 00:00:00	2022-06-08 00:00:00	24	\N
19	50	\N	\N	6	9	57	107	90	2022-06-08 00:00:00	2022-06-08 00:00:00	20	\N
35	25	\N	\N	4	8	84	102	89	2022-06-08 00:00:00	2022-06-08 00:00:00	36	\N
39	5	\N	\N	1	9	75	87	54	2022-06-08 00:00:00	2022-06-08 00:00:00	13	\N
41	5	\N	\N	2	9	74	70	54	2022-06-08 00:00:00	2022-06-08 00:00:00	31	\N
30	0	\N	\N	2	14	52	74	91	2022-06-08 00:00:00	2022-06-08 00:00:00	32	\N
31	0	\N	\N	4	14	65	91	91	2022-06-08 00:00:00	2022-06-08 00:00:00	32	\N
32	0	\N	\N	5	14	96	77	91	2022-06-08 00:00:00	2022-06-08 00:00:00	32	\N
33	3	\N	\N	2	13	78	79	60	2022-06-08 00:00:00	2022-06-08 00:00:00	34	\N
28	5	\N	\N	2	9	85	87	93	2022-06-08 00:00:00	2022-06-08 00:00:00	28	\N
27	5	\N	\N	1	4	74	78	72	2022-06-08 00:00:00	2022-06-08 00:00:00	27	\N
25	7	\N	\N	2	2	80	65	104	2022-06-08 00:00:00	2022-06-08 00:00:00	25	\N
20	0	\N	\N	2	5	50	72	92	2022-06-08 00:00:00	2022-06-08 00:00:00	21	\N
23	5	\N	\N	4	2	58	74	83	2022-06-08 00:00:00	2022-06-08 00:00:00	21	\N
21	5	\N	\N	3	13	58	79	60	2022-06-08 00:00:00	2022-06-08 00:00:00	22	\N
22	5	\N	\N	5	2	70	79	90	2022-06-08 00:00:00	2022-06-08 00:00:00	17	\N
26	5	\N	\N	4	9	77	82	83	2022-06-08 00:00:00	2022-06-08 00:00:00	26	\N
29	20	\N	\N	4	5	71	60	90	2022-06-08 00:00:00	2022-06-08 00:00:00	29	\N
36	50	\N	\N	5	8	107	57	89	2022-06-08 00:00:00	2022-06-08 00:00:00	23	\N
40	5	\N	\N	2	9	82	104	90	2022-06-08 00:00:00	2022-06-08 00:00:00	15	\N
42	5	\N	\N	5	9	58	91	54	2022-06-08 00:00:00	2022-06-08 00:00:00	30	\N
46	0	\N	\N	1	13	52	54	104	2022-06-08 00:00:00	2022-06-08 00:00:00	33	\N
47	5	\N	\N	5	7	75	95	54	2022-06-08 00:00:00	2022-06-08 00:00:00	1	\N
48	5	\N	\N	4	9	75	95	54	2022-06-08 00:00:00	2022-06-08 00:00:00	1	\N
43	0	\N	\N	1	14	60	70	54	2022-06-08 00:00:00	2022-06-08 00:00:00	37	1
44	30	\N	\N	5	1	84	102	54	2022-06-08 00:00:00	2022-06-08 00:00:00	37	1
45	7	\N	\N	5	13	65	72	54	2022-06-08 00:00:00	2022-06-08 00:00:00	35	1
\.


--
-- Data for Name: classtitles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classtitles (id, description, inserted_at, updated_at) FROM stdin;
1	Music	2022-06-02 00:00:00	2022-06-02 00:00:00
2	States & Capitals	2022-06-02 00:00:00	2022-06-02 00:00:00
3	Recorder	2022-06-02 00:00:00	2022-06-02 00:00:00
4	Art	2022-06-02 00:00:00	2022-06-02 00:00:00
5	Electronics	2022-06-02 00:00:00	2022-06-02 00:00:00
6	Chemistry	2022-06-02 00:00:00	2022-06-02 00:00:00
7	Art	2022-06-02 00:00:00	2022-06-02 00:00:00
8	Environmental Science	2022-06-02 00:00:00	2022-06-02 00:00:00
9	History	2022-06-02 00:00:00	2022-06-02 00:00:00
10	Thinking Games	2022-06-02 00:00:00	2022-06-02 00:00:00
11	Science & Scripture	2022-06-02 00:00:00	2022-06-02 00:00:00
12	Logic of Chess	2022-06-02 00:00:00	2022-06-02 00:00:00
13	Early American History	2022-06-02 00:00:00	2022-06-02 00:00:00
14	IEW	2022-06-02 00:00:00	2022-06-02 00:00:00
15	Spanish 1	2022-06-02 00:00:00	2022-06-02 00:00:00
16	Writing	2022-06-02 00:00:00	2022-06-02 00:00:00
17	Science	2022-06-02 00:00:00	2022-06-02 00:00:00
18	Speech	2022-06-02 00:00:00	2022-06-02 00:00:00
19	Study hall	2022-06-02 00:00:00	2022-06-02 00:00:00
21	Gym	2022-06-02 00:00:00	2022-06-02 00:00:00
22	Lunch & Gym	2022-06-02 00:00:00	2022-06-02 00:00:00
23	Jr Volleyball	2022-06-02 00:00:00	2022-06-02 00:00:00
24	Cooking	2022-06-02 00:00:00	2022-06-02 00:00:00
25	Arts & Crafts	2022-06-02 00:00:00	2022-06-02 00:00:00
26	Nutritional Science	2022-06-02 00:00:00	2022-06-02 00:00:00
27	Middle Ages	2022-06-02 00:00:00	2022-06-02 00:00:00
28	Nonfiction Writing	2022-06-02 00:00:00	2022-06-02 00:00:00
29	Chess & Games	2022-06-02 00:00:00	2022-06-02 00:00:00
30	American History	2022-06-02 00:00:00	2022-06-02 00:00:00
31	Fabric Arts	2022-06-02 00:00:00	2022-06-02 00:00:00
32	Nursery	2022-06-02 00:00:00	2022-06-02 00:00:00
33	Show & Tell	2022-06-02 00:00:00	2022-06-02 00:00:00
34	Phonics	2022-06-02 00:00:00	2022-06-02 00:00:00
35	Music & Movement	2022-06-02 00:00:00	2022-06-02 00:00:00
36	Jr Drama	2022-06-02 00:00:00	2022-06-02 00:00:00
37	Sr Drama	2022-06-02 00:00:00	2022-06-02 00:00:00
20	Sr Volleyball	2022-06-02 00:00:00	2022-06-02 00:00:00
\.


--
-- Data for Name: periods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periods (id, "time", inserted_at, updated_at) FROM stdin;
1	9:30 AM	2022-06-06 00:00:00	2022-06-06 00:00:00
2	10:30 AM	2022-06-06 00:00:00	2022-06-06 00:00:00
3	11:30 AM	2022-06-06 00:00:00	2022-06-06 00:00:00
4	12:00 PM	2022-06-06 00:00:00	2022-06-06 00:00:00
5	1:00 PM	2022-06-06 00:00:00	2022-06-06 00:00:00
6	2:00 PM	2022-06-06 00:00:00	2022-06-06 00:00:00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, title, lastname, firstname, spousename, streetaddress, city, state, zipcode, phoneone, phonetwo, user_id, inserted_at, updated_at) FROM stdin;
1		Anderson	Elaine	Dave	377 Echo Valley Road	New Galilee	PA	16141	724-714-5158	724-336-6144	96	2022-06-01 00:00:00	2022-06-01 00:00:00
2		Bartley	Carie	Wade	545 Lisbon Rd	Darlington	PA	16115	724-643-1898	724-494-1326	49	2022-06-01 00:00:00	2022-06-01 00:00:00
3		Bezdek	Toni	Bryce	PO Box 288	Rogers	OH	44455		513-266-2999	52	2022-06-01 00:00:00	2022-06-01 00:00:00
4		Billheimer	Jodi	Brad	9162 Sprucevale Road	Rogers	OH	44455		330-770-6242	53	2022-06-01 00:00:00	2022-06-01 00:00:00
5		Cageao	Cindy	Ron	4440 Tuscarawas Rd	Beaver	PA	15009		724-630-0378	57	2022-06-01 00:00:00	2022-06-01 00:00:00
6		Campbell	Vanessa	David	126 Salem Church Rd	Midland	PA	15059	724-508-0226	724-312-5385	58	2022-06-01 00:00:00	2022-06-01 00:00:00
7		Collins	Tammy	David	554 Adams Street				610-390-5913	724-691-8152	59	2022-06-01 00:00:00	2022-06-01 00:00:00
8		Crawford	Chuck	Jen	3510 Green Garden Rd				412-627-1827	215-300-8568	60	2022-06-01 00:00:00	2022-06-01 00:00:00
9		Devore	Josh	Tiffany 	352 Windsor Drive	East Liverpool	OH	43920		330-385-1754	62	2022-06-01 00:00:00	2022-06-01 00:00:00
10		Dotson	Jennifer	Mike	650 Rose Alley	Chester	WV	26034	304-387-3680	330-303-7654	63	2022-06-01 00:00:00	2022-06-01 00:00:00
11		Forton	Kimberly	Mark	1242 Shenango Rd	Darlington	PA	16115	724-827-8949	724-494-0757	99	2022-06-01 00:00:00	2022-06-01 00:00:00
12		Graves	Anne-Marie		29 North Byron Drive					740-804-1534	65	2022-06-01 00:00:00	2022-06-01 00:00:00
13		Grover	Lori	Mark	597 Sautter Drive	Crescent	PA	15046	724-457-3524	724-622-5607	66	2022-06-01 00:00:00	2022-06-01 00:00:00
14		Grubbs	Holly	Brian(VP)	475 Ridgemont Drive	Industry	PA	15052		724-495-3840	67	2022-06-01 00:00:00	2022-06-01 00:00:00
15		Hall	Bethany								94	2022-06-01 00:00:00	2022-06-01 00:00:00
16		Harbour	Amy		3671 State Route 7		OH			330-831-3796	68	2022-06-01 00:00:00	2022-06-01 00:00:00
17		Hickman	Katie								93	2022-06-01 00:00:00	2022-06-01 00:00:00
18		Horst	Randi								89	2022-06-01 00:00:00	2022-06-01 00:00:00
19		Horstman	Karen	Chuck	459 Wallace Run Road	Beaver Falls	PA	15010	724-622-4150	724-462-3658	69	2022-06-01 00:00:00	2022-06-01 00:00:00
20		Huang	Davis	Teresa	107 McCracken Drive	Monaca	PA	15061		412-956-9836	70	2022-06-01 00:00:00	2022-06-01 00:00:00
21		Kenneally	Jamie	Steven  	5262 Bye Road	East Palestine	OH	44413	330-248-1548	330-248-1772	72	2022-06-01 00:00:00	2022-06-01 00:00:00
22		Laughlin	Theresa		Adams Street	Rochester	PA			770-298-5487	71	2022-06-01 00:00:00	2022-06-01 00:00:00
23		Lauterbach	Sara		115 Spring Blossom Circle	Beaver Falls	PA	15010		724-799-9368	73	2022-06-01 00:00:00	2022-06-01 00:00:00
24		Lewyn	Sara								92	2022-06-01 00:00:00	2022-06-01 00:00:00
25		Lorah	Helen	Steve	49113 Hickman Rdl	East Liverpool	OH	43920	330-386-3007	330-386-5420	74	2022-06-01 00:00:00	2022-06-01 00:00:00
26		Martella	April								91	2022-06-01 00:00:00	2022-06-01 00:00:00
27		Masters	Kristine	Doug	3746 Green Garden Rd	Aliquippa	PA	15001	724-777-0551	724-378-9997	75	2022-06-01 00:00:00	2022-06-01 00:00:00
28		McGee	Andrea								95	2022-06-01 00:00:00	2022-06-01 00:00:00
29		Meneely	Gary	Rachel	122 Beacon Dr	Weirton	WV	26062	304-374-3269	304-670-4851 	76	2022-06-01 00:00:00	2022-06-01 00:00:00
30		Miller	Misty	Ryan	867 Gas Valley Rd	New Cumberland	WV	26047	304-387-4124	304-914-7484	77	2022-06-01 00:00:00	2022-06-01 00:00:00
31		Nichols	Jeremy	Angie	1407 Darlington Rd	Beaver Falls	PA	15010	517-303-9351	517-303-9351	50	2022-06-01 00:00:00	2022-06-01 00:00:00
32		Pozzo	Heather	Tim	132 Old Quarry Road	 Clinton	PA	15026	479-685-2575	479-685-2792	78	2022-06-01 00:00:00	2022-06-01 00:00:00
33		Price	Greta	Dave 	409 Cowpath Road	Independence Township	PA	15001	412-316-6086	724-375-6445	79	2022-06-01 00:00:00	2022-06-01 00:00:00
34		Saling	Sarah	Brandon	15804 Longs Church Rd	East Liverpool	OH	43920		330-843-7013	80	2022-06-01 00:00:00	2022-06-01 00:00:00
35		Seese	Donanne	Corey	485 Grandview Rd	Ellwood City	PA	16117		724-601-2760	82	2022-06-01 00:00:00	2022-06-01 00:00:00
36		Shivler	Bree								90	2022-06-01 00:00:00	2022-06-01 00:00:00
37		Stobart	Elyse	Harry	404 Shivler Rd	Hookstown	PA	15050		724-407-0851	83	2022-06-01 00:00:00	2022-06-01 00:00:00
38		Sullivan	Daniel	Rosemaree	104 Darlington Aly	Beaver Falls	PA	15010		724-847-2509	84	2022-06-01 00:00:00	2022-06-01 00:00:00
39		VanderPlaats	Jean	Gary(PRESIDENT)	217 Larchwood Drive	New Galilee	PA	16141		724-436-1704	85	2022-06-01 00:00:00	2022-06-01 00:00:00
40		Zobrak	Mary	John(Pres)	257 Pleasant Drive	Aliquippa	PA	15001		724-650-9389	87	2022-06-01 00:00:00	2022-06-01 00:00:00
43		Ward	Katie	Noah	\N	\N					104	2022-06-01 00:00:00	2022-06-01 00:00:00
42	\N	Ward	Jessica	Issac	3966 Darlington Rd	Darlington	PA	16115	724-580-8241	724-462-81141	102	2022-06-01 00:00:00	2022-06-01 00:00:00
41	\N	Ward	Isaac	Jessica	3966 Darlington Rd	Darlington	PA	16115	724-462-8114	724-580-8241	86	2022-06-01 00:00:00	2022-06-01 00:00:00
44		Ward	Noah	Katie	\N	\N					88	2022-06-01 00:00:00	2022-06-01 00:00:00
47		DeRoza	Mark	Cori	701 Clover Ave	Ellwood City	PA	16117	724-674-7460	\N	108	2022-06-01 00:00:00	2022-06-01 00:00:00
46		DeRoza	Cori	Mark	701 Clover Ave	Ellwood City	PA	16117	724-674-7460	\N	107	2022-06-01 00:00:00	2022-06-01 00:00:00
48		Bondi	Ami	CoriDan	6153 Struthers Road	Lowellville	OH	44436	330-720-6045	\N	54	2022-06-01 00:00:00	2022-06-01 00:00:00
45		Campbell	David	Vanessa	126 Salem Church Rd	Midland	PA	15059	724-508-0226	724-312-5385	106	2022-06-01 00:00:00	2022-06-01 00:00:00
50		Scherer	Cynthia		143 West Grove Road				724-339-5252	724-699-4640	123	2022-06-01 00:00:00	2022-06-01 00:00:00
49		Butler	William	Sara	124 Cheval St	East Liverpool	OH	43920	330-383-1970	\N	122	2022-06-01 00:00:00	2022-06-01 00:00:00
\.


--
-- Data for Name: registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registrations (id, student_id, class_id, inserted_at, updated_at, semester) FROM stdin;
4	4	40	2022-06-15 00:00:00	2022-06-15 00:00:00	1
5	4	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
6	4	42	2022-06-15 00:00:00	2022-06-15 00:00:00	1
7	4	39	2022-06-15 00:00:00	2022-06-15 00:00:00	1
8	68	41	2022-06-15 00:00:00	2022-06-15 00:00:00	1
9	68	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
10	68	4	2022-06-15 00:00:00	2022-06-15 00:00:00	1
11	12	40	2022-06-15 00:00:00	2022-06-15 00:00:00	1
12	12	14	2022-06-15 00:00:00	2022-06-15 00:00:00	1
13	12	36	2022-06-15 00:00:00	2022-06-15 00:00:00	1
14	13	25	2022-06-15 00:00:00	2022-06-15 00:00:00	1
15	13	23	2022-06-15 00:00:00	2022-06-15 00:00:00	1
16	13	15	2022-06-15 00:00:00	2022-06-15 00:00:00	1
17	14	3	2022-06-15 00:00:00	2022-06-15 00:00:00	1
18	14	23	2022-06-15 00:00:00	2022-06-15 00:00:00	1
19	14	25	2022-06-15 00:00:00	2022-06-15 00:00:00	1
20	17	7	2022-06-15 00:00:00	2022-06-15 00:00:00	1
21	17	36	2022-06-15 00:00:00	2022-06-15 00:00:00	1
22	17	47	2022-06-15 00:00:00	2022-06-15 00:00:00	1
23	17	41	2022-06-15 00:00:00	2022-06-15 00:00:00	1
24	16	36	2022-06-15 00:00:00	2022-06-15 00:00:00	1
25	69	28	2022-06-15 00:00:00	2022-06-15 00:00:00	1
26	69	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
27	70	4	2022-06-15 00:00:00	2022-06-15 00:00:00	1
28	25	13	2022-06-15 00:00:00	2022-06-15 00:00:00	1
29	25	20	2022-06-15 00:00:00	2022-06-15 00:00:00	1
30	25	29	2022-06-15 00:00:00	2022-06-15 00:00:00	1
31	25	9	2022-06-15 00:00:00	2022-06-15 00:00:00	1
32	24	11	2022-06-15 00:00:00	2022-06-15 00:00:00	1
33	24	36	2022-06-15 00:00:00	2022-06-15 00:00:00	1
34	6	4	2022-06-15 00:00:00	2022-06-15 00:00:00	1
35	6	28	2022-06-15 00:00:00	2022-06-15 00:00:00	1
36	6	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
37	6	44	2022-06-15 00:00:00	2022-06-15 00:00:00	1
38	70	38	2022-06-15 00:00:00	2022-06-15 00:00:00	1
39	70	44	2022-06-15 00:00:00	2022-06-15 00:00:00	1
40	27	20	2022-06-15 00:00:00	2022-06-15 00:00:00	1
41	26	48	2022-06-15 00:00:00	2022-06-15 00:00:00	1
42	26	14	2022-06-15 00:00:00	2022-06-15 00:00:00	1
43	26	5	2022-06-15 00:00:00	2022-06-15 00:00:00	1
44	71	36	2022-06-15 00:00:00	2022-06-15 00:00:00	1
45	71	14	2022-06-15 00:00:00	2022-06-15 00:00:00	1
46	71	10	2022-06-15 00:00:00	2022-06-15 00:00:00	1
47	27	3	2022-06-15 00:00:00	2022-06-15 00:00:00	1
48	27	29	2022-06-15 00:00:00	2022-06-15 00:00:00	1
49	29	44	2022-06-15 00:00:00	2022-06-15 00:00:00	1
50	30	10	2022-06-15 00:00:00	2022-06-15 00:00:00	1
51	30	5	2022-06-15 00:00:00	2022-06-15 00:00:00	1
52	30	14	2022-06-15 00:00:00	2022-06-15 00:00:00	1
53	30	48	2022-06-15 00:00:00	2022-06-15 00:00:00	1
54	67	28	2022-06-15 00:00:00	2022-06-15 00:00:00	1
55	67	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
56	29	23	2022-06-15 00:00:00	2022-06-15 00:00:00	1
57	34	6	2022-06-15 00:00:00	2022-06-15 00:00:00	1
58	34	29	2022-06-15 00:00:00	2022-06-15 00:00:00	1
59	34	20	2022-06-15 00:00:00	2022-06-15 00:00:00	1
60	33	40	2022-06-15 00:00:00	2022-06-15 00:00:00	1
61	33	4	2022-06-15 00:00:00	2022-06-15 00:00:00	1
62	33	38	2022-06-15 00:00:00	2022-06-15 00:00:00	1
63	73	14	2022-06-15 00:00:00	2022-06-15 00:00:00	1
64	73	11	2022-06-15 00:00:00	2022-06-15 00:00:00	1
65	73	24	2022-06-15 00:00:00	2022-06-15 00:00:00	1
66	74	5	2022-06-15 00:00:00	2022-06-15 00:00:00	1
67	74	10	2022-06-15 00:00:00	2022-06-15 00:00:00	1
68	74	36	2022-06-15 00:00:00	2022-06-15 00:00:00	1
69	36	28	2022-06-15 00:00:00	2022-06-15 00:00:00	1
70	36	42	2022-06-15 00:00:00	2022-06-15 00:00:00	1
71	36	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
72	36	39	2022-06-15 00:00:00	2022-06-15 00:00:00	1
73	75	26	2022-06-15 00:00:00	2022-06-15 00:00:00	1
74	75	40	2022-06-15 00:00:00	2022-06-15 00:00:00	1
75	75	10	2022-06-15 00:00:00	2022-06-15 00:00:00	1
76	76	39	2022-06-15 00:00:00	2022-06-15 00:00:00	1
77	76	38	2022-06-15 00:00:00	2022-06-15 00:00:00	1
78	76	42	2022-06-15 00:00:00	2022-06-15 00:00:00	1
79	38	44	2022-06-15 00:00:00	2022-06-15 00:00:00	1
80	76	40	2022-06-15 00:00:00	2022-06-15 00:00:00	1
81	77	39	2022-06-15 00:00:00	2022-06-15 00:00:00	1
82	77	47	2022-06-15 00:00:00	2022-06-15 00:00:00	1
83	77	44	2022-06-15 00:00:00	2022-06-15 00:00:00	1
84	65	28	2022-06-15 00:00:00	2022-06-15 00:00:00	1
85	65	42	2022-06-15 00:00:00	2022-06-15 00:00:00	1
86	66	4	2022-06-15 00:00:00	2022-06-15 00:00:00	1
87	66	28	2022-06-15 00:00:00	2022-06-15 00:00:00	1
88	66	38	2022-06-15 00:00:00	2022-06-15 00:00:00	1
89	65	4	2022-06-15 00:00:00	2022-06-15 00:00:00	1
90	64	14	2022-06-15 00:00:00	2022-06-15 00:00:00	1
91	64	5	2022-06-15 00:00:00	2022-06-15 00:00:00	1
92	66	44	2022-06-15 00:00:00	2022-06-15 00:00:00	1
93	64	10	2022-06-15 00:00:00	2022-06-15 00:00:00	1
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20220313155409	2022-03-13 15:55:48
20220313174819	2022-03-13 17:49:59
20220314150629	2022-03-14 15:08:07
20220314150833	2022-03-14 15:10:03
20220317135047	2022-03-17 14:07:21
20220330191059	2022-03-30 19:16:08
20220330192441	2022-03-30 19:25:44
20220330193913	2022-03-30 19:40:51
20220330194556	2022-03-30 19:47:21
20220413174535	2022-04-13 17:46:59
20220430183306	2022-04-30 18:53:06
20220430183452	2022-04-30 19:07:49
20220430184600	2022-04-30 19:07:49
20220430192943	2022-04-30 19:31:20
20220505191053	2022-05-05 19:12:05
20220601180105	2022-06-01 18:28:15
20220601180115	2022-06-01 18:28:15
20220601183329	2022-06-01 18:35:55
20220606171645	2022-06-08 15:00:59
20220608150236	2022-06-08 15:13:49
20220610142453	2022-06-10 14:27:47
20220610142502	2022-06-10 14:27:47
20220610143033	2022-06-10 14:31:02
20220627144425	2022-06-27 14:47:04
20220628173557	2022-06-28 17:38:48
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sections (id, description, inserted_at, updated_at) FROM stdin;
1	10-12	2022-06-06 00:00:00	2022-06-06 00:00:00
2	1-2	2022-06-06 00:00:00	2022-06-06 00:00:00
3	3-12	2022-06-06 00:00:00	2022-06-06 00:00:00
4	3-4	2022-06-06 00:00:00	2022-06-06 00:00:00
5	3-6	2022-06-06 00:00:00	2022-06-06 00:00:00
6	5-6	2022-06-06 00:00:00	2022-06-06 00:00:00
7	7-8	2022-06-06 00:00:00	2022-06-06 00:00:00
8	7-9	2022-06-06 00:00:00	2022-06-06 00:00:00
9	9-12	2022-06-06 00:00:00	2022-06-06 00:00:00
10	All	2022-06-06 00:00:00	2022-06-06 00:00:00
11	Grad	2022-06-06 00:00:00	2022-06-06 00:00:00
12	Jr	2022-06-06 00:00:00	2022-06-06 00:00:00
13	K	2022-06-06 00:00:00	2022-06-06 00:00:00
14	N	2022-06-06 00:00:00	2022-06-06 00:00:00
15	NA	2022-06-06 00:00:00	2022-06-06 00:00:00
16	PreK-1	2022-06-06 00:00:00	2022-06-06 00:00:00
17	Prek-2	2022-06-06 00:00:00	2022-06-06 00:00:00
18	Prek-K	2022-06-06 00:00:00	2022-06-06 00:00:00
19	Sr	2022-06-06 00:00:00	2022-06-06 00:00:00
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id, firstname, grade, birthday, user_id, inserted_at, updated_at) FROM stdin;
78	Laura	10		123	2022-06-09 00:00:00	2022-06-09 00:00:00
5	Aidan	12		52	2022-06-09 00:00:00	2022-06-09 00:00:00
7	Laini	12		54	2022-06-09 00:00:00	2022-06-09 00:00:00
8	Matthew	6		122	2022-06-09 00:00:00	2022-06-09 00:00:00
9	Jacob	4		122	2022-06-09 00:00:00	2022-06-09 00:00:00
10	Natalie 	2		122	2022-06-09 00:00:00	2022-06-09 00:00:00
11	Chase	12		58	2022-06-09 00:00:00	2022-06-09 00:00:00
12	Jaelynn	6		58	2022-06-09 00:00:00	2022-06-09 00:00:00
13	Journey	1		58	2022-06-09 00:00:00	2022-06-09 00:00:00
14	Khalil	1		58	2022-06-09 00:00:00	2022-06-09 00:00:00
15	Aleisha	2		58	2022-06-09 00:00:00	2022-06-09 00:00:00
17	Isabel	7		60	2022-06-09 00:00:00	2022-06-09 00:00:00
18	Gloriana 	12		108	2022-06-09 00:00:00	2022-06-09 00:00:00
19	Adeline	7		108	2022-06-09 00:00:00	2022-06-09 00:00:00
20	Caleb	7		62	2022-06-09 00:00:00	2022-06-09 00:00:00
21	KaitlynAlexa	4		62	2022-06-09 00:00:00	2022-06-09 00:00:00
22	Clay	11		63	2022-06-09 00:00:00	2022-06-09 00:00:00
23	Hannah	11		99	2022-06-09 00:00:00	2022-06-09 00:00:00
24	Bethany	6		99	2022-06-09 00:00:00	2022-06-09 00:00:00
25	Benjamin	2		99	2022-06-09 00:00:00	2022-06-09 00:00:00
26	Caleb	7		65	2022-06-09 00:00:00	2022-06-09 00:00:00
27	Savannah	2		65	2022-06-09 00:00:00	2022-06-09 00:00:00
28	Owen M.	11		66	2022-06-09 00:00:00	2022-06-09 00:00:00
29	Owen	10		67	2022-06-09 00:00:00	2022-06-09 00:00:00
30	Jude	5		67	2022-06-09 00:00:00	2022-06-09 00:00:00
31	Haley	4		68	2022-06-09 00:00:00	2022-06-09 00:00:00
32	Braeden 	2		69	2022-06-09 00:00:00	2022-06-09 00:00:00
33	Maddie	8		70	2022-06-09 00:00:00	2022-06-09 00:00:00
34	Dakota	2		70	2022-06-09 00:00:00	2022-06-09 00:00:00
35	Ariel	12		71	2022-06-09 00:00:00	2022-06-09 00:00:00
36	Joseph	8		72	2022-06-09 00:00:00	2022-06-09 00:00:00
37	Elayna 	12		73	2022-06-09 00:00:00	2022-06-09 00:00:00
38	Hannah	10		74	2022-06-09 00:00:00	2022-06-09 00:00:00
39	Laura 	10		75	2022-06-09 00:00:00	2022-06-09 00:00:00
40	Elizabeth	8		76	2022-06-09 00:00:00	2022-06-09 00:00:00
41	Trey	2		76	2022-06-09 00:00:00	2022-06-09 00:00:00
42	Caleb 	10		77	2022-06-09 00:00:00	2022-06-09 00:00:00
43	Joel 	2		77	2022-06-09 00:00:00	2022-06-09 00:00:00
44	Abigail	12		50	2022-06-09 00:00:00	2022-06-09 00:00:00
45	Mackenzie 	5		50	2022-06-09 00:00:00	2022-06-09 00:00:00
46	Jacob 	7		78	2022-06-09 00:00:00	2022-06-09 00:00:00
47	Luke	9		79	2022-06-09 00:00:00	2022-06-09 00:00:00
48	Mark	5		79	2022-06-09 00:00:00	2022-06-09 00:00:00
49	Anna	2		79	2022-06-09 00:00:00	2022-06-09 00:00:00
50	Layla 	3		80	2022-06-09 00:00:00	2022-06-09 00:00:00
51	Hannah	10		123	2022-06-09 00:00:00	2022-06-09 00:00:00
52	Emma	8		123	2022-06-09 00:00:00	2022-06-09 00:00:00
53	Seth	6		123	2022-06-09 00:00:00	2022-06-09 00:00:00
54	Analucia (Lucy)	10		82	2022-06-09 00:00:00	2022-06-09 00:00:00
55	Cliff	8		83	2022-06-09 00:00:00	2022-06-09 00:00:00
56	Cascade	5		83	2022-06-09 00:00:00	2022-06-09 00:00:00
57	Rebekah	10		84	2022-06-09 00:00:00	2022-06-09 00:00:00
4	Ruth	7		49	2022-06-09 00:00:00	2022-06-09 00:00:00
16	Adeline	7		59	2022-06-09 00:00:00	2022-06-09 00:00:00
6	Grace	9		99	2022-06-09 00:00:00	2022-06-09 00:00:00
58	Isaiah	12		85	2022-06-09 00:00:00	2022-06-09 00:00:00
59	Shiyan 	9		85	2022-06-09 00:00:00	2022-06-09 00:00:00
60	Josiah	4		104	2022-06-09 00:00:00	2022-06-09 00:00:00
61	Malachi	PreK/K		104	2022-06-09 00:00:00	2022-06-09 00:00:00
62	Luke	PreK/K		104	2022-06-09 00:00:00	2022-06-09 00:00:00
63	Alyssa	11		87	2022-06-09 00:00:00	2022-06-09 00:00:00
64	David	5		96	2022-06-09 00:00:00	2022-06-09 00:00:00
65	Annamae	7		96	2022-06-09 00:00:00	2022-06-09 00:00:00
66	Emmaline	9		96	2022-06-09 00:00:00	2022-06-09 00:00:00
67	Eve	10		67	2022-06-09 00:00:00	2022-06-09 00:00:00
68	Lauren	12		52	2022-06-09 00:00:00	2022-06-09 00:00:00
79	Emma	10		123	2022-06-09 00:00:00	2022-06-09 00:00:00
69	Mallory	7		63	2022-06-09 00:00:00	2022-06-09 00:00:00
70	Jonathan	11		99	2022-06-09 00:00:00	2022-06-09 00:00:00
71	Andrew	10		65	2022-06-09 00:00:00	2022-06-09 00:00:00
72	Savannah	8		65	2022-06-09 00:00:00	2022-06-09 00:00:00
73	Savannah	8		70	2022-06-09 00:00:00	2022-06-09 00:00:00
74	Acelan	7		71	2022-06-09 00:00:00	2022-06-09 00:00:00
75	Jameson	8		72	2022-06-09 00:00:00	2022-06-09 00:00:00
76	Andrew	10		74	2022-06-09 00:00:00	2022-06-09 00:00:00
77	Laura	10		75	2022-06-09 00:00:00	2022-06-09 00:00:00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email_address, hashed_password, inserted_at, updated_at, current) FROM stdin;
54	Ami_Bondi	amybondi@sbcglobal.net	$pbkdf2-sha512$160000$R0L/NECoGmLMEwgUrKdPIQ$QhIrRV/R6g/Rf8drOlLveFhQtFAhTiruhLqEge/NKyF95GimhE/cYBgYFrklz2RhQ26i5wuahiW0R2Cd.N9acg	2022-05-22 19:12:52	2022-05-22 19:12:52	\N
56	WIlliam_Butler	3lilcrazykids@gmail.com	$pbkdf2-sha512$160000$KrHFCdFiM2nJsNsILTnDjg$L4.Pvq0W/OSQeHwb96qQnkDWdyYOJPN2/S1wHXE6alj1jYS4RBHASnva6VbWxLzLuPRWHwBdM0q0Ir.If21MCg	2022-05-23 15:53:58	2022-05-23 15:53:58	\N
61	Cori_DeRosa	Corideroza@gmail.com	$pbkdf2-sha512$160000$IvxL0NjArWmlKOeS6dQBQA$.X.0D0..AV9kby53AvCNSXue5tFmygOoSY8NGfq1MWqxWc7NiQl7djSuG.XWFcv5jIHYRHkX/fHwL6T7r3QB6w	2022-05-23 15:58:20	2022-05-23 15:58:20	\N
81	Cynthia_Scherre_Sorrell	mamahen.ssk16@gmail.com	$pbkdf2-sha512$160000$eFkoXQgZJnvoykLRurttWg$ugP4siHIKZc2gNMNK/HVBXDHAv2.5w3mr.2N.yjz8Z4XYoHSl6EfYewvF3vpEBg1m8P/IsqNZrFcvXZm/oOwUg	2022-05-23 16:13:30	2022-05-23 16:13:30	\N
86	Isaac_Ward	jes.photo@gmail.com	$pbkdf2-sha512$160000$gv/GlCpXwW3GAeNGT1DznQ$3Q2QXiYdx6jOY/SJw6IKgm0SMH4fUt2XtycPTbRqiglxqleyN8no0hs6I3075/m2L4xhXYibwgN5rWB6s3Lrgw	2022-05-23 16:16:31	2022-05-23 16:16:31	\N
88	Noah_Ward	noahwar@gmail.com	$pbkdf2-sha512$160000$5skFNHs.4tCSq43pmJiynA$PDsRu9KiIl8IzRfO4btQbYGfQE3gVh6JXLPFppPE2HdM2g93Z9I3GJZExBJnzGLKSBhKOR3M2Pf7fGL.8fihYg	2022-05-23 16:18:05	2022-05-23 16:18:05	\N
97	Kimberley_Forton	11rejoicealways@gmail.com	$pbkdf2-sha512$160000$dAvxtiWNiWua4ZZzkpkjWg$6KFiM8BFrvoYOGY9fb0k5MDDXcChex2x4i2KW5..RMFpbyN0a1NMWlm2..aCAuy.nd98bc1rvmytEzNDQZTElg	2022-05-23 16:27:46	2022-05-23 16:27:46	\N
52	Toni_Bezdek	bezdekfamily@gmail.com	$pbkdf2-sha512$160000$du8n6AOBUYHp/RdzvHgfmw$ybbSG7DWMeowUauTN5pOmNv7JssDwkw1NGoU5qekrtYr5MR3PS538jOC/PUN0xlPA2i5qg6e8wAdsGYtCyTqFw	2022-05-22 19:11:29	2022-05-22 19:11:29	T
53	Jodi_Billheimer	Momof4girls@att.net	$pbkdf2-sha512$160000$zJ6tUYKZT2mDqv3mKT3t.A$5rMPokkG.6B13gcaGTJs5cRQ7BFI6pFWw34UPsZEFVzdjTv.QiqNlcZuwj7Q4JYuOnjywGOGCcJ6/sgAWuhQUw	2022-05-22 19:12:13	2022-05-22 19:12:13	T
57	Cindy_Cageao	cageaonotes@gmail.com	$pbkdf2-sha512$160000$0Dwck5MjsjhCnRvm7REd/A$5q7Iv2ViSSPmtM9V39RqsvvOgnm7wWCV39hye7BQ5bMPVHXuJwt4XNB0NIWdAAyfWpvWmT.cVHw5ll4W3rCFaA	2022-05-23 15:54:51	2022-05-23 15:54:51	F
58	Vanessa_Campbell	Earthfriendly3@hotmail.com	$pbkdf2-sha512$160000$pXNh.S3jSOa6m8kmp1wu7Q$QgqKWTabkGH/rU9vskRByXCxfyd6nnOE4leDSw4dm6RHAHS4TGfFPC3lgWzyx.HDHUChTfQ1RBSAAXKVoCjN4A	2022-05-23 15:55:34	2022-05-23 15:55:34	T
59	Tammy_Collins	Belarose0427@yahoo.com	$pbkdf2-sha512$160000$bzim.QPljnEWIgvwoU88ag$a5h6bu3iPRIQevJV8ePH46JXCykOM4pOe7HGcXmd.kWYQnHvZBWqHA62dsaJuX8XQMmqVXqFDedRC5uoQWJhzg	2022-05-23 15:56:52	2022-05-23 15:56:52	F
60	Chuck_Crawford	jen.crawford6@gmail.com	$pbkdf2-sha512$160000$4BkhfboknK50U8s21zA/0g$/ZCXFaHiUgBenmp8gNx9NHzBebMaf9KdZC3Fxl6f2mtEMrkqFZBH0x93u5FJKST9vEntrMT9PGObeZDmwp5M.w	2022-05-23 15:57:34	2022-05-23 15:57:34	T
62	Josh_Devore	tdevore79@yahoo.com	$pbkdf2-sha512$160000$MyKfMy.R6IcmkktMNZTs/A$s9MbUeoVnSKKF/.GtpoQklh5VnJBxdKs/sk.WgSR.XQfSpNpeao8n42UEcw3GLALBCpyThOIC0XDHLLE9Dbd6g	2022-05-23 15:59:00	2022-05-23 15:59:00	F
63	Jennifer_Dotson	cjmrdotson@comcast.net	$pbkdf2-sha512$160000$0jsDduUk5eRPruHvqpBFMQ$WQFk2bfTUBM3sxRmzJulhHmiB68fK1BdJhJkl5fuPUDxuOPqjD4qIWub3qknmf6MI4ee8q5Yz9iBsVlBiZC.Lw	2022-05-23 15:59:29	2022-05-23 15:59:29	T
99	Kimberly_Forton	11rejoicealways@gmail.com	$pbkdf2-sha512$160000$7CNb8OZj6Z/VR37AzZadFg$9GjQG4OhTMSzsZuZ.I3EFm0MTOWC4.mqHVdxIK63tDxUgo4PxXqkaVcqOAnoNVHda2pR5VJkCQlMmAEw/f/ovA	2022-05-23 16:32:43	2022-05-23 16:32:43	T
65	Anne-Marie_Graves	couponannemarie@yahoo.com	$pbkdf2-sha512$160000$6XRuJWzlzQd1an/IbHMgog$yKZabpbhZLfu88sUKEUKJQqqRsORu9BDfcSsGY7.NbsBZeo/c0S/xefmjPOq6M4QZo4ZLt1M1CZznT4zKNmwdA	2022-05-23 16:00:43	2022-05-23 16:00:43	T
66	Lori_Grover	pianomom8@gmail.com	$pbkdf2-sha512$160000$oAbYFBUnCb7UWGx3ZqaUsQ$ovqUtVZ1STaKjK6rNdAju6IRZmm05wwbixuUXc2RYD3vpyLMkkbYeq1EcnHzigScxAopfpA24LsEUAbL8hOXMQ	2022-05-23 16:01:14	2022-05-23 16:01:14	F
67	Holly_Grubbs	grubbhut6@verizon.net	$pbkdf2-sha512$160000$0z7RmGWuMdXkplyBquOUBQ$XCi39Z03AygiT7P8g/ebqL5ApZ1Wn/SVWls090ySByILp7QF0AJCH3FDWcEwlN5qt6WPtcWZRwmihL.ZV2e5Mw	2022-05-23 16:01:53	2022-05-23 16:01:53	T
68	Amy_Harbour	alharbour21@gmail.com	$pbkdf2-sha512$160000$N1aj7n/0DePQLTeWyiLJNQ$F0oGBBCqWHMtSBUE89mHdxgWYlhBFrL3ii1fhfUAoPgusIvJWcYcceDjk34Ns.UJ.mFIBQSBEtmvnEiTzEGSdw	2022-05-23 16:02:32	2022-05-23 16:02:32	F
89	Randi_Horst	rhorst_slp@hotmail.com	$pbkdf2-sha512$160000$L4QQxevfvFIIjz.6qhWIMQ$yBGqTH0eUkh/G2TGVccEwDY.6HlyywhPL/WbOMcphF524Qlycg4rcGXSgdxlB6wHVXPo6motFTPR0jw/cIAXEw	2022-05-23 16:18:35	2022-05-23 16:18:35	T
69	Karen_Horstman	barefooter333@gmail.com	$pbkdf2-sha512$160000$2OkFLuDWF7rYTEHzcYsi0g$ZT6PzWGt4TY9hbgTPAhm7jt/O0qQREd9y8ERV//wCcI.32ex3xeVr9gcSbJMXlZRTorCjMh2Z2zMjJONh9.VKg	2022-05-23 16:03:16	2022-05-23 16:03:16	F
70	Davis_Huang	teresaihuang@gmail.com	$pbkdf2-sha512$160000$fmT20kV42t5JMJ/CUeHmMw$rTkCTvl1r4w4B67cSoPJg6BAaqSay6ti92jROA9rslJSAfZtTXDi7Wj.3BP4A3/BnIOv1V9irPEK7/0aK/MyNQ	2022-05-23 16:03:56	2022-05-23 16:03:56	T
72	Jamie_Kenneally	kenneally_jamie@yahoo.com	$pbkdf2-sha512$160000$e5n.fBjDBeODjm6AXJzAkw$JK8/5GC6hhDCF9uxFbKlKgEeO5yFdzjUXYti3iWIGE754by.fo9Nzt0oirEaBaeQntqAvSQqSKPelnp.9rFIzg	2022-05-23 16:05:05	2022-05-23 16:05:05	T
71	Theresa_Laughlin	Laughlintheresa@yahoo.com	$pbkdf2-sha512$160000$aWWBI8sXz4FCMtIFK6voIw$DYcRMwXJXUY1sfIhzLaeBdDLzjvSfhhKC1W2jduWic.jvoWrlhi0AyPupaUlimKEsKghapiAonTSKSl8lDqPYA	2022-05-23 16:04:32	2022-05-23 16:04:32	T
73	Sara_Lauterbach	Ejlx2@hotmail.com	$pbkdf2-sha512$160000$q7AH1zaObFk5f7KjygjC3A$BbSMre2CwKHW9IpMJQAVHbLgrY/wnnL61exNHBxi/n6NnuG/WLammfXrSgm5yEE5oVooZcwXzm3NVWLcKLHybw	2022-05-23 16:05:37	2022-05-23 16:05:37	F
92	Sara_Lewyn	saraL4jewelry@yahoo.com	$pbkdf2-sha512$160000$I0JGFaLIaVlQG..n20gqIQ$dpI4YLucmxi.wZ7hI24OqrwXzSibXXMHi.wJFHXbLteHHpqo5A/ycBUPi6ypYrL9bFyONf0MbGizxQZZN3TkAA	2022-05-23 16:20:24	2022-05-23 16:20:24	T
74	Helen_Lorah	Helen.in.ohio@gmail.com	$pbkdf2-sha512$160000$.aaCzCEhFdQKBPmkp.r8FQ$002vUEPW0inc5FhZj.ZH3rD.59SbOOl9.4fL2OtlHOXIu9j0e3josqXZl08jizwSK1wfvcEEKll7X0884rkk7Q	2022-05-23 16:06:10	2022-05-23 16:06:10	T
91	April_Martella	aprilmartella@gmail.com	$pbkdf2-sha512$160000$fPAVuiaFw9cSO/cmm57SWQ$trINN09m7sE57.NB6cmyn/6G0gk6FdsMNnbNNgyiXwzVAtVM30nxuYeo7XJoXnUNUSqvGpJClXp4YXwOKwqGJA	2022-05-23 16:19:56	2022-05-23 16:19:56	T
96	Elaine_Anderson	bakermomof7@gmail.com	$pbkdf2-sha512$160000$GyJbgKuhDYAAF.e5ZVXwug$pqo8K0Kkat2jcMCj79nVp.XjNldX0NxHO29UKjHY7dqgyZNARmkPRLqt5XcCxZ7.Cfli6nt9iEpIBp967gP0rA	2022-05-23 16:22:19	2022-05-23 16:22:19	T
49	Carie_Bartley	bartleyfarm@earthlink.net	$pbkdf2-sha512$160000$9T0em6XzA4wB1qTEjC6Umg$Ut6iKFdtE/F0UbmJyfOclJ0PBY4jNkHLQ9nRazEwnrxAPun02WVU7cM6yVXwXaKY/87jcfc2NtsoGpGyUaeCeA	2022-05-22 19:03:58	2022-05-22 19:03:58	T
94	Bethany_Hall	bethany538@gmail.com	$pbkdf2-sha512$160000$opr/R3oUJX7E.H1D7QiIVQ$NBYkZDochbQoonyclat7yJbLsvK2ifklb/UgtzfdyJpcewmPWSeW2M0u3NZ7H4eNFWAYja8bpDs/kInr2.1T7Q	2022-05-23 16:21:20	2022-05-23 16:21:20	T
93	Katie_Hickman	hickmanfamschool@gmail.com	$pbkdf2-sha512$160000$xhvPs7giwjSU4ltIiZZ9qg$x0L9c4wZ1WC4FbY9Q5IRvSrNhnWuAiMJSaPNndRHytB87SSA76VBokre538D9WS8FFkNL1f0Zz19nwcqzWKTTQ	2022-05-23 16:20:51	2022-05-23 16:20:51	T
75	Kristine_Masters	kristinemasters@gmail.com	$pbkdf2-sha512$160000$yImmO27BKeHzlfvxScOsWA$8guzBJEJmaNwhZpt13Nktnt/AVXAV2KLBgk2PyWyJp9JW4AyFhzkWXR9JpqbVwVgu.aurbTTQnubmd3wDHNumg	2022-05-23 16:06:39	2022-05-23 16:06:39	T
95	Andrea_McGee	7McGees@gmail.com	$pbkdf2-sha512$160000$xr7G6qBXuEyj2hBH4jeUbA$ZZfJhbbed4spqm9fWCfhmL6DWvUP.LdHLDdvXvLdOU8twyRl7.U0Gcr/XT1/Mbc0/tWlIyuKo0rr8RQhCG9ADQ	2022-05-23 16:21:50	2022-05-23 16:21:50	T
76	Gary_Meneely	rachel.meneely@gmail.com	$pbkdf2-sha512$160000$CZi.vjH71T3fnaWcXm6YQw$S0lMDSIJFy0PxPwfMziRhdDeLvWNvFWKOFyUVGXSn0dHwGg9wAVx99bY9CyHwVhD2CY3CxXHYCfUdzjdaWmxMQ	2022-05-23 16:07:17	2022-05-23 16:07:17	F
77	Misty_Miller	ryanmistymiller@gmail.com	$pbkdf2-sha512$160000$ZduNpoa8oaGKSJjfGwJUZw$TiqcGGoNnyiV29/LuSNdexcS2/46Tox/ruWCBtzCweqNSVU93oVIsyk6MKcmbw3pBh8NPa36HANV.Q1uVhQwGw	2022-05-23 16:07:38	2022-05-23 16:07:38	T
50	Jeremy_Nichols	nicholsfamily1@hotmail.com	$pbkdf2-sha512$160000$44ryO8X53cDyaYbA8wm8JA$n1Fj2kPPYmS.8QBXZXgb5iFyDgwR.z/17/AsBWkFn27SxFIHPFrO7Ol3.2TYkHD3YCi3WlO7nGd9WaBvKTUlPw	2022-05-22 19:05:37	2022-05-22 19:05:37	T
78	Heather_Pozzo	tpozzo@aol.com	$pbkdf2-sha512$160000$Eh7lyplekVjPfshzLkLHyQ$sM0CRybvRW3HLkXw6BH/eMIDOhL6O8gYRyNwow/i8uhDukmQqdZ/PG.Y5TA0hjbDJdJfPJn8ha1qP7Jab6jAaA	2022-05-23 16:08:20	2022-05-23 16:08:20	T
79	Greta_Price	dglsmprice@gmail.com	$pbkdf2-sha512$160000$wVIn5Q3eK5.AsmKgQi18QQ$glmLpUca2ZoHPwXi37MM2vbie9NT6n88ztvPlj5uS.q4sDFSVkBIbX84SlxII/yTwCR57rn.KCJToM4Vu8g.qg	2022-05-23 16:12:18	2022-05-23 16:12:18	T
80	Sarah_Saling	daydreamer_0422@hotmail.com	$pbkdf2-sha512$160000$15M8KOOsStu4WkoOv3PtHQ$uCLP3IgLJkIaDf/8edgyPt3U8gya/cnZ8hC83YnheqSPIko5qJy5iW1L70NX4gWBCNxChmjCWYvBctWJN4dIfw	2022-05-23 16:12:44	2022-05-23 16:12:44	T
82	Donanne_Seese	annieseese@gmail.com	$pbkdf2-sha512$160000$hGkYf/XISgC8jMXf.l2w8w$vo77ARF38AF76CymIPyXwLL/KMpnxIA7Q8cu/JxdKf8UrSrgeXKTg3Js2Bvsx4q9qtsnFa85K5YW8JHrmwXy7w	2022-05-23 16:14:06	2022-05-23 16:14:06	T
90	Bree_Shivler	breeshivler@gmail.com	$pbkdf2-sha512$160000$MYgaI5ZMjJWaCAoAdGueMg$lI9q9moU78WoiNcQAoVyHbzHrXoQ/nCZPB2AAE97pFdNEM1t2/rZr.YIh205OYGjUbKemWgbVKl6828CTloHdQ	2022-05-23 16:19:03	2022-05-23 16:19:03	T
83	Elyse_Stobart	mydogiskaylee@yahoo.com	$pbkdf2-sha512$160000$rNBHgNulz2/cvOGBjwh6OQ$ztf.xjRmWogkeGw2VkKkgZtzZaGOlTstM73z266WhXDygYL.m1hZPSnXHpzpRof7Rlcvai/qkR97VtzZETTf3Q	2022-05-23 16:14:38	2022-05-23 16:14:38	T
84	Daniel_Sullivan	710sullivan@comcast.net	$pbkdf2-sha512$160000$COI2Q2zF3z6Hni9x95UswQ$1eUdJ/CbtN/I1lyc7o7KKkBRT9rveV14njng3zDc4oTQlFc0ER51nzioe6kAd5V832OwseUzWwz9Jl86kbjnrw	2022-05-23 16:15:10	2022-05-23 16:15:10	T
85	Jean_VanderPlaats	vanderplaatsj@yahoo.com	$pbkdf2-sha512$160000$6OqGGRT7ETCou8StPlkEyg$afzBbpYophHTlRTUs2gJlpQ5K6SBmM3vTm9niCH8y4AdH5G6QRvDmNUOCN5AeV6roFwXKxJY8QRy8/7pO5Wyrw	2022-05-23 16:15:43	2022-05-23 16:15:43	T
87	Mary_Zobrak	jzobrak@comcast.net	$pbkdf2-sha512$160000$QKZosRDMMwt8a374Ay3jdg$5SYY1oCKSHxWtDUI7PWs8NRNA1ofSJdWxleJyiCM6RsJVZhu1tmQQvyaLuKWhNs7CWggADDjsQHnd6Sg8f5YAw	2022-05-23 16:17:01	2022-05-23 16:17:01	T
102	Jessica_Ward	jes.photo@gmail.com	$pbkdf2-sha512$160000$rvZK1.VuU3w1hpEHZW2iKw$rT37y.oPaMfPV4UbzvE9JGmmysgMgwsEaNpdFzpewvrZnN1RKn5cy5wKF41QA5Y76NE3masug4xq46M5KG.Ogg	2022-06-04 19:23:08	2022-06-04 19:23:08	\N
104	Katie_Ward	noahwar@gmail.com	$pbkdf2-sha512$160000$Yldx2xWDJimw3VVx6Qvx6Q$3H25kazuBWkVr3W9Ye61PHmyJOCLDxGX4lY6PMWlvpOf1KqsA9iVqpAeHa6n4M.6VmuV7/ZJDXUo2O9qeGCUeA	2022-06-06 16:34:55	2022-06-06 16:34:55	\N
105	Mike_Dotson	cjmrdotson@comcast.net	$pbkdf2-sha512$160000$w/V6Qijkh4o88BxJcymgnA$N0Hue2T4zBJy7gH9d0lt5Foq6gpmr130o92YGCDEOIyClm2qV7NtPlOAB9srn2bLroRyRuPbb1F9lFGj6Ahqqw	2022-06-07 16:52:21	2022-06-07 16:52:21	\N
106	David_Campbell	Earthfriendly3@hotmail.com	$pbkdf2-sha512$160000$hwIYgsV1DowvJmIqEv1WrA$VH.uvOBD6MG3NZSFRwAEyjmYzBQB9/CijcCZbHtQueOw9jsYYwDj5pVbm9UINS.g1zCRH7UilUoglIZ03Qc50Q	2022-06-07 16:54:53	2022-06-07 16:54:53	\N
107	Cori_DeRoza	Corideroza@gmail.com	$pbkdf2-sha512$160000$8ulsGoq5lC.PrapvUlqSuA$wIwqjgwrpQExQVGB513Wv72tG5R5Q7fXeS68DWse7NmRcplY6CA7/xdnZngdg.tA0Oq0aoTEc70X.oN/g7mBnQ	2022-06-07 17:07:09	2022-06-07 17:07:09	\N
108	Mark_DeRoza	Corideroza@gmail.com	$pbkdf2-sha512$160000$5.IpwhfiRrj.VeOdOEm/AA$B4F5tjxiWGmFyuVBt8itrq4bWa7xlfX.pF28uF15EsnD2iNv8wtWP1KFqW/uWmdcBa6fj9YA9WXm9YFdPH3/BQ	2022-06-07 17:07:41	2022-06-07 17:07:41	\N
122	William_Butler	3lilcrazykids@gmail.com	$pbkdf2-sha512$160000$SZmnvE0Dc1xIBgO2VjDbTA$iqs85qH1BMh/pBMJPYIQTx0bc5gU4dupqX8oGvr5dc2w/DBn/dXI7hdghd/4JvNW0xLJEMUCkcdJlkbm5eO3SQ	2022-06-09 17:29:02	2022-06-09 17:29:02	\N
123	Cynthia_Scherer	mamahen.ssk16@gmail.com	$pbkdf2-sha512$160000$a2fSvNwkBCAycjJRqvGHYQ$f56q3RpMLyDAX8pwNJpW92cODDvItC9EBcuztfil.iCGh5NdT10Axqb.dXFTegpxDU5P3MtYPRvU0PA43ujROA	2022-06-09 17:49:09	2022-06-09 17:49:09	\N
\.


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_id_seq', 1, false);


--
-- Name: classtitles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classtitles_id_seq', 1, false);


--
-- Name: fall_registrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fall_registrations_id_seq', 1, false);


--
-- Name: periods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.periods_id_seq', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 7, true);


--
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sections_id_seq', 1, false);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 107, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 126, true);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: classtitles classtitles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classtitles
    ADD CONSTRAINT classtitles_pkey PRIMARY KEY (id);


--
-- Name: registrations fall_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fall_registrations_pkey PRIMARY KEY (id);


--
-- Name: periods periods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: profiles_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX profiles_user_id_index ON public.profiles USING btree (user_id);


--
-- Name: students_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX students_user_id_index ON public.students USING btree (user_id);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_username_index ON public.users USING btree (username);


--
-- Name: classes classes_helper1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_helper1_id_fkey FOREIGN KEY (helper1_id) REFERENCES public.users(id);


--
-- Name: classes classes_helper2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_helper2_id_fkey FOREIGN KEY (helper2_id) REFERENCES public.users(id);


--
-- Name: classes classes_period_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_period_fkey FOREIGN KEY (period_id) REFERENCES public.periods(id);


--
-- Name: classes classes_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_section_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: classes classes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: classes classes_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_title_id_fkey FOREIGN KEY (classtitle_id) REFERENCES public.classtitles(id);


--
-- Name: registrations fall_registrations_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fall_registrations_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: registrations fall_registrations_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fall_registrations_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

