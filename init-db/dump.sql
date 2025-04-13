--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

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
-- Name: buildings; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.buildings (
    building_id integer NOT NULL,
    building_name character varying(255) NOT NULL
);


ALTER TABLE public.buildings OWNER TO "tgBot";

--
-- Name: buildings_building_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public.buildings_building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.buildings_building_id_seq OWNER TO "tgBot";

--
-- Name: buildings_building_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public.buildings_building_id_seq OWNED BY public.buildings.building_id;


--
-- Name: cargoTypes; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public."cargoTypes" (
    "idCargoType" integer NOT NULL,
    "cargoTypeName" character varying(50) NOT NULL,
    ratio double precision DEFAULT 1.0
);


ALTER TABLE public."cargoTypes" OWNER TO "tgBot";

--
-- Name: cargoTypes_idCargoType_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public."cargoTypes_idCargoType_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."cargoTypes_idCargoType_seq" OWNER TO "tgBot";

--
-- Name: cargoTypes_idCargoType_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public."cargoTypes_idCargoType_seq" OWNED BY public."cargoTypes"."idCargoType";


--
-- Name: department_buildings; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.department_buildings (
    department_building_id integer NOT NULL,
    department_id integer,
    building_id integer,
    description character varying(255)
);


ALTER TABLE public.department_buildings OWNER TO "tgBot";

--
-- Name: department_buildings_department_building_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public.department_buildings_department_building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_buildings_department_building_id_seq OWNER TO "tgBot";

--
-- Name: department_buildings_department_building_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public.department_buildings_department_building_id_seq OWNED BY public.department_buildings.department_building_id;


--
-- Name: department_types; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.department_types (
    department_type_id integer NOT NULL,
    department_type_name character varying(255) NOT NULL
);


ALTER TABLE public.department_types OWNER TO "tgBot";

--
-- Name: department_types_department_type_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public.department_types_department_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_types_department_type_id_seq OWNER TO "tgBot";

--
-- Name: department_types_department_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public.department_types_department_type_id_seq OWNED BY public.department_types.department_type_id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    department_name character varying(255) NOT NULL,
    department_type_id integer
);


ALTER TABLE public.departments OWNER TO "tgBot";

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_department_id_seq OWNER TO "tgBot";

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- Name: orderStatuses; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public."orderStatuses" (
    "idOrderStatus" integer NOT NULL,
    "orderStatusName" character varying(40) NOT NULL
);


ALTER TABLE public."orderStatuses" OWNER TO "tgBot";

--
-- Name: orderStatuses_idOrderStatus_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public."orderStatuses_idOrderStatus_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."orderStatuses_idOrderStatus_seq" OWNER TO "tgBot";

--
-- Name: orderStatuses_idOrderStatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public."orderStatuses_idOrderStatus_seq" OWNED BY public."orderStatuses"."idOrderStatus";


--
-- Name: orders; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.orders (
    "idOrder" integer NOT NULL,
    "cargoName" text NOT NULL,
    "cargoDescription" text NOT NULL,
    "cargoTypeId" integer NOT NULL,
    cargo_weight double precision NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "orderStatusId" integer NOT NULL,
    "dispatcherId" integer NOT NULL,
    "driverId" integer,
    "photoId" character varying,
    pickup_time timestamp with time zone,
    completion_time timestamp with time zone,
    create_order_time timestamp with time zone,
    "isUrgent" boolean DEFAULT false,
    "isPostponed" boolean DEFAULT false,
    "driverRate" integer,
    depart_loc integer,
    goal_loc integer
);


ALTER TABLE public.orders OWNER TO "tgBot";

--
-- Name: orders_idOrder_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public."orders_idOrder_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."orders_idOrder_seq" OWNER TO "tgBot";

--
-- Name: orders_idOrder_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public."orders_idOrder_seq" OWNED BY public.orders."idOrder";


--
-- Name: roles; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.roles (
    "idRole" integer NOT NULL,
    "roleName" character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO "tgBot";

--
-- Name: roles_idRole_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public."roles_idRole_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."roles_idRole_seq" OWNER TO "tgBot";

--
-- Name: roles_idRole_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public."roles_idRole_seq" OWNED BY public.roles."idRole";


--
-- Name: time_coefficent; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.time_coefficent (
    time_coefficent_id integer NOT NULL,
    value integer NOT NULL,
    coefficent double precision NOT NULL
);


ALTER TABLE public.time_coefficent OWNER TO "tgBot";

--
-- Name: time_coefficent_time_coefficent_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public.time_coefficent_time_coefficent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.time_coefficent_time_coefficent_id_seq OWNER TO "tgBot";

--
-- Name: time_coefficent_time_coefficent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public.time_coefficent_time_coefficent_id_seq OWNED BY public.time_coefficent.time_coefficent_id;


--
-- Name: userLocations; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public."userLocations" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."userLocations" OWNER TO "tgBot";

--
-- Name: userLocations_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public."userLocations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."userLocations_id_seq" OWNER TO "tgBot";

--
-- Name: userLocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public."userLocations_id_seq" OWNED BY public."userLocations".id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.users (
    "idUser" integer NOT NULL,
    "tgId" bigint NOT NULL,
    phone character varying(15) NOT NULL,
    fio character varying(100) NOT NULL,
    "roleId" integer NOT NULL
);


ALTER TABLE public.users OWNER TO "tgBot";

--
-- Name: users_idUser_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public."users_idUser_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."users_idUser_seq" OWNER TO "tgBot";

--
-- Name: users_idUser_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public."users_idUser_seq" OWNED BY public.users."idUser";


--
-- Name: weight_coefficent; Type: TABLE; Schema: public; Owner: tgBot
--

CREATE TABLE public.weight_coefficent (
    weight_coefficent_id integer NOT NULL,
    value double precision NOT NULL,
    coefficent double precision NOT NULL
);


ALTER TABLE public.weight_coefficent OWNER TO "tgBot";

--
-- Name: weight_coefficent_weight_coefficent_id_seq; Type: SEQUENCE; Schema: public; Owner: tgBot
--

CREATE SEQUENCE public.weight_coefficent_weight_coefficent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weight_coefficent_weight_coefficent_id_seq OWNER TO "tgBot";

--
-- Name: weight_coefficent_weight_coefficent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tgBot
--

ALTER SEQUENCE public.weight_coefficent_weight_coefficent_id_seq OWNED BY public.weight_coefficent.weight_coefficent_id;


--
-- Name: buildings building_id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.buildings ALTER COLUMN building_id SET DEFAULT nextval('public.buildings_building_id_seq'::regclass);


--
-- Name: cargoTypes idCargoType; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."cargoTypes" ALTER COLUMN "idCargoType" SET DEFAULT nextval('public."cargoTypes_idCargoType_seq"'::regclass);


--
-- Name: department_buildings department_building_id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_buildings ALTER COLUMN department_building_id SET DEFAULT nextval('public.department_buildings_department_building_id_seq'::regclass);


--
-- Name: department_types department_type_id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_types ALTER COLUMN department_type_id SET DEFAULT nextval('public.department_types_department_type_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- Name: orderStatuses idOrderStatus; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."orderStatuses" ALTER COLUMN "idOrderStatus" SET DEFAULT nextval('public."orderStatuses_idOrderStatus_seq"'::regclass);


--
-- Name: orders idOrder; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders ALTER COLUMN "idOrder" SET DEFAULT nextval('public."orders_idOrder_seq"'::regclass);


--
-- Name: roles idRole; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.roles ALTER COLUMN "idRole" SET DEFAULT nextval('public."roles_idRole_seq"'::regclass);


--
-- Name: time_coefficent time_coefficent_id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.time_coefficent ALTER COLUMN time_coefficent_id SET DEFAULT nextval('public.time_coefficent_time_coefficent_id_seq'::regclass);


--
-- Name: userLocations id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."userLocations" ALTER COLUMN id SET DEFAULT nextval('public."userLocations_id_seq"'::regclass);


--
-- Name: users idUser; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.users ALTER COLUMN "idUser" SET DEFAULT nextval('public."users_idUser_seq"'::regclass);


--
-- Name: weight_coefficent weight_coefficent_id; Type: DEFAULT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.weight_coefficent ALTER COLUMN weight_coefficent_id SET DEFAULT nextval('public.weight_coefficent_weight_coefficent_id_seq'::regclass);


--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.buildings (building_id, building_name) FROM stdin;
1	5
2	11-1
3	11-3
4	1-2
5	3-2
6	21А
7	55-1
8	70
9	14
10	91
11	73
12	11-4
13	68-2
14	4
15	6-7-4
16	60-2-1
17	21
18	50-7
19	16
20	9
21	10-1
22	10-2
23	6-7-1
24	6-7-2
25	6-7-3
26	50-8
27	60-4-1
28	60-4-3
29	3-1
30	50-1
31	50-2
32	62А
33	68-1
34	50-3
35	50-4
36	50-6
37	60-4-2
38	47-1
39	47-2
40	47-3
41	47-4
42	1-1
43	59-1
44	60-2-2
45	71
46	81
47	23
48	59-2
49	55-2
50	94
51	11-2
52	50-5
53	50
\.


--
-- Data for Name: cargoTypes; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public."cargoTypes" ("idCargoType", "cargoTypeName", ratio) FROM stdin;
1	Детали	1
2	Сборочные единицы	1
3	Окончательные сборки	1
4	Материалы, комплектующие, ПКИ	1
5	Вода	1
6	Производственные отходы	1
7	Бытовые отходы	1
8	Инструменты, оснастка	1
10	Готовая продукция	1
9	Прочее	1
11	Стружка	2
\.


--
-- Data for Name: department_buildings; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.department_buildings (department_building_id, department_id, building_id, description) FROM stdin;
1	1	1	СУП №6, корпус 5
2	1	2	Склад ПДО, корпус 11
3	16	1	СГТ, корпус 5
4	16	3	ТИО СГТ, корпус 11
5	2	4	СКО №9, 1 корпус, с торца здания
6	17	5	Прачечная, корпус 3
7	17	6	Молоко, корпус 21А
8	18	7	Снабжение, склад канцелярии и ПКИ, корпус 55
9	18	8	Склад цветных металлов, ангар70
10	18	9	Склад цветного профиля, ангар 14
11	18	10	Склад черных металлов, ангар 91
12	18	11	Склад химии, ангар 73
13	19	12	21 отдел, макетный участок, корпус 11
14	19	13	21 отдел, основной, корпус 68, 21 отдел, сборочно-монтажный участок, корпус 68
15	20	14	25 отдел (ИНО), 4 корпус
16	21	15	30 отдел, лаборатория, корпус 6-7
17	21	3	30 отдел, лаборатория, корпус 11
18	22	16	31 отдел, корпус 60-2-1
19	22	17	Аутсорсинг - "Севзапроибор", корпус 21
20	22	18	Аутсорсинг - "ТП ИС", корпус 50
21	23	3	Метрология, корпус 11
22	24	19	АСУП, корпус 16
23	25	20	40 участок, в здании испытательной станции, корпус 9
24	3	16	41 цех, механика, корпус 60-2
25	3	21	41 цех, ЧПУ, ворота, корпус 10
26	3	22	41 цех, заготовка, корпус 10
27	3	23	41 цех, литейный участок, корпус 6-7
28	3	24	41 цех, шлифовка и пескоструйка, корпус 6-7
29	3	25	41 цех, литье магнитов, корпус 6-7
30	3	26	41 цех, новый участок ЧПУ, корпус 50 (со стороны КБ)
31	4	27	43 цех, у грузового лифта, корпус 60-4
32	4	28	43 цех, у пассажирского лифта, корпус 60-4
33	4	29	43 цех, участок датчиков, КСУ, корпус 3
34	5	30	44 цех, гальванический участок, корпус 50
35	5	31	44 цех, кладовая, корпус 50
36	5	32	станция нейтрализации, корпус 62А
37	6	18	45 цех, корпус 50, заезд через ворота и направо
38	7	33	46 цех, заготовка, корпус 68
39	7	34	46 цех, термический участок №12, корпус 50
40	7	35	46 цех, вакуумный участок №8, корпус 50
41	7	36	46 цех, трубный участок, корпус 50
42	7	26	46 цех, лазерный участок, корпус 50 (со стороны КБ)
43	7	37	46 цех, штамповка, корпус 60-4 (в ворота по коридору)
44	7	27	46 цех, у грузового лифта, корпус 60-4
45	8	16	51 цех, корпус 60-2
46	9	38	52 цех, станочный участок, корпус 47
47	9	39	52 цех, тарный участок, корпус 47
48	9	40	52 цех, основной, корпус 47
49	9	41	52 цех, картонажный участок, корпус 47
50	26	1	53 проектный центр, корпус 5
51	10	42	58 цех, основной корпус, корпус 1
52	10	43	58 цех, участок датчиков, корпус 59
53	11	43	59 станция, корпус 59
54	12	16	61 цех, у грузового лифта, корпус 60-2
55	12	44	61 цех, механический участок, по коридору, корпус 60-2
56	13	41	Строительный цех, корпус 47
57	27	45	Площадка утильбаза, за ангарами
58	14	46	Сантехнический цех, корпус 81
59	28	47	Котельная, корпус 16
60	29	48	Участок отдела сбыта, корпус 59
61	29	49	Отдел сбыта, склад, корпус 55
62	30	50	Вода питьевая, ангар 94
63	15	51	945 цех, запалный вход, корпус 11
64	15	12	945 цех, северный вход, корпус 11
65	15	20	945 цех, участок трубных датчиков, корпус 9
66	31	20	Испытательный отдел, корпус 9
67	7	52	Лазер
68	32	53	Рекламационный отдел
\.


--
-- Data for Name: department_types; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.department_types (department_type_id, department_type_name) FROM stdin;
1	Цех
2	Отдел
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.departments (department_id, department_name, department_type_id) FROM stdin;
1	6	1
2	9	1
3	41	1
4	43	1
5	44	1
6	45	1
7	46	1
8	51	1
9	52	1
10	58	1
11	59	1
12	61	1
13	64	1
14	72	1
15	945	1
16	8	2
17	13	2
18	14	2
19	21	2
20	25	2
21	30	2
22	31	2
23	35	2
24	39	2
25	40	2
26	53	2
27	71	2
28	77	2
29	79	2
30	80	2
31	946	2
32	28	2
\.


--
-- Data for Name: orderStatuses; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public."orderStatuses" ("idOrderStatus", "orderStatusName") FROM stdin;
1	Доступен
2	В работе
3	Завершен
4	Отменен
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.orders ("idOrder", "cargoName", "cargoDescription", "cargoTypeId", cargo_weight, "time", "orderStatusId", "dispatcherId", "driverId", "photoId", pickup_time, completion_time, create_order_time, "isUrgent", "isPostponed", "driverRate", depart_loc, goal_loc) FROM stdin;
172	41-2 цех. Детали	Из 41-2 в 46/8	1	0.6	2025-03-19 09:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
175	Шкалы на мачение	Нет	1	1	2025-03-19 08:45:00	3	47	40	AgACAgIAAxkBAAIsdWfaVCXSAo5ldE3-e1ohp52uCz6wAAJl7TEb9YnRSujEvg7MhoMAAQEAAwIAA3kAAzYE	\N	\N	\N	f	f	\N	\N	\N
187	Халаты, спец. одежда	С прачечной в 43 цех	9	15	2025-03-19 08:30:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
178	Планка	Нет	1	0.5	2025-03-19 09:00:00	3	45	40	\N	\N	\N	\N	f	f	\N	\N	\N
183	Цех 45	Забрать из ПРБ цеха 61 кондуктор на ручку 17.964.64.	8	1	2025-03-19 09:15:00	3	11	17	\N	\N	\N	\N	f	f	\N	\N	\N
182	Цех 45	Отвезти в ремонт принтер	9	5	2025-03-19 09:00:00	3	11	17	\N	\N	\N	\N	f	f	\N	\N	\N
165	Заготовки с заготовительного участка	Нужно забрать заготовки 46 цеха, корпус 68, где гильотины	1	7	2025-03-19 08:30:00	3	19	8	\N	\N	\N	\N	f	f	\N	\N	\N
174	цех 45	Привезти спецодежду из стирки	9	10	2025-03-19 08:30:00	3	22	17	\N	\N	\N	\N	f	f	\N	\N	\N
164	Лазерные детали	Нужно забрать готовые детали с лазерного участка цеха 46. 50 корпус, бывшая заготовка 61ц.\nОтвезти в основной корпус 60/4 на первый этаж	1	5	2025-03-19 08:30:00	3	19	8	\N	\N	\N	\N	f	f	\N	\N	\N
166	Заготовки	Заготовки в цех и лазерный участок	4	40	2025-03-19 08:00:00	3	57	8	\N	\N	\N	\N	f	f	\N	\N	\N
171	41-2 цех. Детали	Из 41-2 в 58ц, колодка	1	0.5	2025-03-19 09:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
170	41	Отправка деталей \n0411012\n6л8130422-01 \n6т8306337	1	3	2025-03-19 09:00:00	3	30	8	\N	\N	\N	\N	f	f	\N	\N	\N
184	41-2 цех. Панель	Из 41-2 на 3уч 10 корп	1	1.5	2025-03-19 09:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
200	Тест для Франца Алексея	Тестирование отображения новых заказов диспетчерам	9	2	2025-03-19 12:00:00	1	10	\N	\N	\N	\N	\N	f	f	\N	\N	\N
194	Отборка 6т6236003*	Трубки	1	10	2025-03-19 10:15:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
177	46	46	10	5	2025-03-19 10:00:00	3	56	8	\N	\N	\N	\N	f	f	\N	\N	\N
203	Полуфабрикаты	Отвезти в термичку	1	2	2025-03-19 13:00:00	3	20	8	\N	\N	\N	\N	f	f	\N	\N	\N
181	Трубы	Нет	1	20	2025-03-19 09:00:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
176	Детали	Детали штампа	1	2	2025-03-19 08:30:00	3	15	62	\N	\N	\N	\N	f	f	\N	\N	\N
179	Детали	Детали штампа	1	1	2025-03-19 08:30:00	3	15	62	\N	\N	\N	\N	f	f	\N	\N	\N
173	Транпортировочная деревянная обрешетка	Цех 41 корпус 10 ( западные ворота) вывоз деревянной палеты на утиль базу.	6	20	2025-03-19 08:45:00	3	18	40	AgACAgIAAxkBAAIsTmfaUw272E31mJNTtypCqSL-wxFyAAJr7DEbNZ3QSmgYtUfUFRz2AQADAgADeQADNgQ	\N	\N	\N	f	f	\N	\N	\N
190	41-2 цех. Спирт	Из склада #3 в 10.00 забрать спирт привезти в 41-2	9	40	2025-03-19 10:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
167	41-2 цех. Детали	Из 41 в 44 с возвратом в 41	1	1.5	2025-03-19 09:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
168	41-2 цех. Детали	Из 41-2 на 3 участок в 10 корпус, планка и пружина	1	2.5	2025-03-19 09:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
169	41-2 цех. Детали	Из 41-2 на 06, каркас, прокладка	1	0.7	2025-03-19 09:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
188	Забрать бумажные паспорта	Нужно забрать бумажные паспорта в 34 отделе (типография) и привезти в 46ц, 60/4	4	1	2025-03-19 10:00:00	3	19	40	\N	\N	\N	\N	f	f	\N	\N	\N
189	Бутылки с питьевой водой	Обменять пустые бутылки на новые	5	50	2025-03-19 09:30:00	3	37	62	\N	\N	\N	\N	f	f	\N	\N	\N
186	ПКИ	С 14 отд. В 43 цех	4	10	2025-03-19 08:30:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
199	Готовые детали	Панели	1	1	2025-03-19 10:30:00	3	66	61	\N	\N	\N	\N	f	f	\N	\N	\N
196	Спирт	Нет	4	10	2025-03-19 10:15:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
193	Отборки	Нет	1	10	2025-03-19 10:15:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
192	41-2 цех. Получение материала	Со склада #2 забрать материал для заготовок	4	500	2025-03-19 11:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
198	Приспособление	Нет	10	1	2025-03-19 10:15:00	3	36	62	\N	\N	\N	\N	f	f	\N	\N	\N
180	Материал листы	Получить с общего склада 2.0200 листы и ленту и привести на заготовку	4	78	2025-03-19 10:15:00	3	57	62	\N	\N	\N	\N	f	f	\N	\N	\N
191	Цех 45	Забрать резину с центрального склада	4	5	2025-03-19 10:00:00	3	67	17	\N	\N	\N	\N	f	f	\N	\N	\N
195	Коробка с паспортами	Забрать 3 коробки с 60/4 1 этаж, отвезти в 50 корпус 46/12	9	0.5	2025-03-19 10:30:00	3	19	8	AgACAgIAAxkBAAIwLWfaacS-CJ3OQ0aPaSsweLCc6s7rAAJj8TEbjc3RSgt6NnWpus1HAQADAgADeQADNgQ	\N	\N	\N	f	f	\N	\N	\N
197	Забрать трубы (надставки)	Забрать трубы с трубного участка 46 цеха (напротив 44 цеха) и отвезти в 41ц	1	5	2025-03-19 10:45:00	3	19	40	\N	\N	\N	\N	f	f	\N	\N	\N
185	Цех 45	Отвезти детали на склад ПДО	1	3	2025-03-19 14:00:00	3	67	40	\N	\N	\N	\N	f	f	\N	\N	\N
202	Кожух	После травления на сварку	1	2	2025-03-19 13:00:00	3	66	61	\N	\N	\N	\N	f	f	\N	\N	\N
204	Детали	Детали штампа	1	2	2025-03-19 13:00:00	3	54	8	\N	\N	\N	\N	f	f	\N	\N	\N
1413	Лепесток	Нет	10	1	2025-04-10 12:00:00	3	20	58	\N	2025-04-10 10:23:28.479688+03	2025-04-10 12:58:45.440708+03	2025-04-10 10:23:15.297649+03	t	f	5	44	35
201	41/10-3уч. Стружка	Вывести стружку из 41 цеха 10 корпуса в утиль бызу.	6	400	2025-03-19 13:00:00	3	46	8	\N	\N	\N	\N	f	f	\N	\N	\N
205	ДСМК21-6,11 40 шт	Нет	2	10	2025-03-19 13:00:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
245	Баллоны с аргоном	Нужно забрать 4 полных баллона с газового склада и привезти в 46ц в корпус 60/4	9	280	2025-03-20 10:30:00	3	19	62	\N	2025-03-20 09:39:45.193647+03	2025-03-20 13:46:01.870141+03	2025-03-20 08:47:36.294424+03	f	f	\N	\N	\N
223	Картон	Нет	6	1	2025-03-19 14:45:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
212	/my_orders	Детали на ПДО склад	1	50	2025-03-19 13:30:00	3	66	61	\N	\N	\N	\N	f	f	\N	\N	\N
207	Тест	Нет	7	40	2025-03-20 14:15:00	3	68	8	\N	2025-03-20 14:20:57.191428+03	2025-03-20 14:21:03.891027+03	\N	f	f	\N	\N	\N
243	41-2 цех. Детали	Из 41-2 в 10 корпус	1	5	2025-03-20 09:00:00	3	39	8	\N	2025-03-20 08:40:21.393133+03	2025-03-20 10:14:07.85447+03	2025-03-20 08:32:35.868046+03	f	f	\N	\N	\N
206	Изделия	отвезти изделия с 43ц в 59отд	10	30	2025-03-19 12:45:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
1414	Готовые детали	Нет	1	10	2025-04-10 10:30:00	3	16	61	\N	2025-04-10 10:25:06.552611+03	2025-04-10 12:23:44.623025+03	2025-04-10 10:25:03.278647+03	t	f	5	34	2
242	Детали	Детали штампа	1	5	2025-03-20 08:45:00	3	54	62	\N	2025-03-20 12:48:13.389387+03	2025-03-20 13:47:25.827226+03	2025-03-20 08:28:56.380554+03	f	f	\N	\N	\N
217	Стрелка	1794685-7 5шт	10	0.5	2025-03-19 13:45:00	3	16	40	\N	\N	\N	\N	f	f	\N	\N	\N
221	Бак Д вариант 3 5 шт	Нет	10	1	2025-03-19 14:15:00	3	47	40	\N	\N	\N	\N	f	f	\N	\N	\N
213	41-2 цех. Детали	Из 41 в 44, 06, 10 корп, 58, 46/12	1	70	2025-03-19 14:00:00	3	39	8	\N	\N	\N	\N	f	f	\N	\N	\N
208	41	Перемещение\n6т8410220   в 44ц  \n6т8130421  в 44ц\n917490        в 44ц	1	3	2025-03-19 14:00:00	3	30	8	\N	\N	\N	\N	f	f	\N	\N	\N
209	Детали	Детали штама	1	3	2025-03-19 13:30:00	3	36	8	\N	\N	\N	\N	f	f	\N	\N	\N
211	Детали	Детали приспособления	1	0.5	2025-03-19 13:30:00	3	54	8	\N	\N	\N	\N	f	f	\N	\N	\N
214	Токоподвод	1 этаж	10	1	2025-03-19 13:30:00	3	20	8	\N	\N	\N	\N	f	f	\N	\N	\N
215	46	46	10	5	2025-03-19 14:00:00	3	56	8	\N	\N	\N	\N	f	f	\N	\N	\N
216	46	46	10	1	2025-03-19 14:00:00	3	56	8	\N	\N	\N	\N	f	f	\N	\N	\N
222	41 крышки 000416	Из мойки корпуса 10 в ТП ИС	1	46	2025-03-19 14:00:00	3	9	8	\N	\N	\N	\N	f	f	\N	\N	\N
219	46	46	10	2	2025-03-19 14:00:00	3	56	8	\N	\N	\N	\N	f	f	\N	\N	\N
220	Мусор	С 43 цеха на утиль базу	7	100	2025-03-19 13:45:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
224	макулатура	с 43 цеха в 77 ангар	7	40	2025-03-19 13:45:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
244	Пустые баллоны аргона	Нужно забрать 4 пустых баллона аргона с корпуса 60/4, отвезти на газовый склад (за 50 корпусом)	9	280	2025-03-20 10:15:00	3	19	62	\N	2025-03-20 09:03:06.907341+03	2025-03-20 13:47:11.89017+03	2025-03-20 08:45:58.466279+03	f	f	\N	\N	\N
231	ПДО	оборки со склада ПДО 6 отд в 43 цех	4	30	2025-03-19 14:45:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
232	Система	С 43 цеха в 59 отд	10	30	2025-03-19 15:15:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
233	Сбыт	Сбыт с 43 цеха в 79 отд	10	50	2025-03-19 15:15:00	3	33	60	\N	\N	\N	\N	f	f	\N	\N	\N
228	Корпуса 073-ьи	Нет	1	5	2025-03-19 15:15:00	3	66	40	\N	\N	\N	\N	f	f	\N	\N	\N
229	0140627 корпус	Нет	1	50	2025-03-19 15:15:00	3	66	40	\N	\N	\N	\N	f	f	\N	\N	\N
230	Детали	Нет	1	3	2025-03-19 15:30:00	3	66	61	\N	\N	\N	\N	f	f	\N	\N	\N
247	Спирт	Нет	4	1	2025-03-20 10:00:00	3	47	40	\N	2025-03-20 09:11:51.241409+03	2025-03-20 10:25:36.744901+03	2025-03-20 08:49:41.650826+03	f	f	\N	\N	\N
225	Заготовки	От заготовки 46цеха в корпус 3	4	8	2025-03-19 15:00:00	3	57	62	\N	\N	2025-03-20 13:47:39.901955+03	\N	f	f	\N	\N	\N
226	Панели	Нет	1	2	2025-03-19 15:15:00	4	66	\N	\N	\N	\N	\N	f	f	\N	\N	\N
240	41цех спирт	Забрать канистры из корпуса 10 , получить спирт со склада, отвезти в корпус 10	9	45	2025-03-20 10:00:00	3	70	62	\N	2025-03-20 08:52:28.666453+03	2025-03-20 13:45:23.307035+03	2025-03-20 08:12:28.164942+03	f	f	\N	\N	\N
239	41-2 цех. Детали	Из 41-2 на 06	1	1.7	2025-03-20 09:00:00	3	39	8	\N	2025-03-20 08:39:58.096168+03	2025-03-20 10:14:23.334174+03	2025-03-20 08:09:34.343005+03	f	f	\N	\N	\N
210	Тест	Нет	7	200	2025-03-19 13:30:00	3	69	62	AgACAgIAAxkBAAI0rGfamfF_YdPJshhMDDcfZNmu6MieAAKb7zEb3RXRShkESCl-9OLgAQADAgADeQADNgQ	\N	2025-03-20 13:48:30.666735+03	\N	f	f	\N	\N	\N
238	41-2 цех. Детали	Из 41-2 на 44	1	17	2025-03-20 09:00:00	3	39	8	\N	2025-03-20 08:39:19.901887+03	2025-03-20 10:14:36.696222+03	2025-03-20 08:08:40.67902+03	f	f	\N	\N	\N
241	Заготовки	Из заготовительного 46 отвезти на лазерный участок и в цех	4	8	2025-03-20 08:30:00	3	57	8	\N	2025-03-20 08:41:22.688458+03	2025-03-20 10:12:06.108755+03	2025-03-20 08:17:47.242654+03	f	f	\N	\N	\N
246	41	41/10-8уч\nОтправка\n6л847380  в 44ц\n6т8236024-20  на 2уч в кладоыую	1	1	2025-03-20 09:00:00	3	30	8	\N	2025-03-20 09:00:39.568549+03	2025-03-20 10:12:52.910899+03	2025-03-20 08:48:46.438742+03	f	f	\N	\N	\N
237	41-2 цех. Спирт	Со склада 3 в 41 Корп. 50	9	40	2025-03-20 10:00:00	3	39	8	\N	2025-03-20 10:11:18.010864+03	2025-03-20 10:13:09.279889+03	2025-03-20 08:05:34.141116+03	f	f	\N	\N	\N
218	Вода	К9 -> склад воды -> К9	5	220	2025-03-20 09:30:00	3	14	40	\N	2025-03-20 09:50:25.976824+03	2025-03-20 10:21:33.865483+03	\N	f	f	\N	\N	\N
227	Кожух	Нет	1	15	2025-03-19 15:15:00	4	66	\N	\N	\N	\N	\N	f	f	\N	\N	\N
1412	Шайба	На склад	10	1	2025-04-10 12:00:00	3	20	58	\N	2025-04-10 10:23:42.947749+03	2025-04-10 12:58:12.244381+03	2025-04-10 10:22:20.734801+03	t	f	5	44	2
1547	Принтер МФУ	Забрать принтер из ремонта 39 отдел (16 корп, 106 каб) и привезти в 58 цех (1 корп, 110 каб)	9	6	2025-04-11 14:30:00	2	50	40	\N	2025-04-11 15:33:13.535189+03	\N	2025-04-11 14:16:17.146132+03	f	f	\N	22	51
270	цех45	Получить инструмент	8	5	2025-03-20 13:30:00	3	22	17	\N	2025-03-20 13:03:35.057182+03	2025-03-20 13:47:31.183805+03	2025-03-20 13:03:04.262241+03	f	f	\N	\N	\N
259	Детали	Детали для приспособления	1	5	2025-03-20 10:45:00	3	54	62	\N	2025-03-20 11:12:54.046492+03	2025-03-20 13:46:56.167882+03	2025-03-20 10:34:04.16126+03	f	f	\N	\N	\N
248	Натрий сернистый	Мешок	4	50	2025-03-20 09:30:00	3	34	61	\N	2025-03-20 08:53:15.521811+03	2025-03-20 09:55:29.866567+03	2025-03-20 08:50:34.223246+03	f	f	\N	\N	\N
266	41-2 цех. Детали промывка	От 41-2 в 10 корп	1	5	2025-03-20 13:00:00	3	39	8	\N	2025-03-20 12:53:00.881545+03	2025-03-20 12:59:18.063787+03	2025-03-20 12:36:36.997341+03	f	f	\N	\N	\N
249	41-2 цех Детали	От 41-2 в 58	1	1.5	2025-03-20 09:00:00	3	39	8	\N	2025-03-20 09:01:41.223032+03	2025-03-20 10:13:26.716497+03	2025-03-20 08:56:48.447229+03	f	f	\N	\N	\N
251	Лазерные детали	Забрать детали с лазерного участка 46ц 50 корпус\nПривести в 46ц 60/4	1	5	2025-03-20 10:45:00	3	19	8	\N	2025-03-20 09:54:12.53263+03	2025-03-20 10:13:46.171493+03	2025-03-20 09:42:10.735004+03	f	f	\N	\N	\N
254	Ремонтный датчик	ПКУЗ16-1	9	3	2025-03-20 13:00:00	3	50	40	\N	2025-03-20 09:50:49.185161+03	2025-03-20 10:25:10.89029+03	2025-03-20 09:46:05.195823+03	f	f	\N	\N	\N
256	Корпус	Нет	1	10	2025-03-20 10:15:00	3	47	40	\N	2025-03-20 10:06:40.137084+03	2025-03-20 10:29:33.340902+03	2025-03-20 09:59:14.650647+03	f	f	\N	\N	\N
260	Установка для оправки штырей	Нет	8	15	2025-03-20 10:45:00	3	47	40	\N	2025-03-20 10:36:58.417115+03	2025-03-20 10:45:08.313093+03	2025-03-20 10:36:25.618972+03	f	f	\N	\N	\N
250	ПКИ	с 14 отд в 43 цех	4	10	2025-03-20 08:30:00	3	33	60	\N	2025-03-20 09:39:40.858298+03	2025-03-20 10:49:38.351947+03	2025-03-20 09:39:10.544522+03	f	f	\N	\N	\N
252	Принтер в ремонт	МФУ в 39 отд с 43 цеха	9	25	2025-03-20 09:00:00	3	33	60	\N	2025-03-20 09:44:04.979073+03	2025-03-20 10:49:53.043083+03	2025-03-20 09:43:36.085349+03	f	f	\N	\N	\N
255	СПИРТ	Со склада в 43 цех	4	55	2025-03-20 10:00:00	3	33	60	\N	2025-03-20 09:49:06.853287+03	2025-03-20 10:50:05.681671+03	2025-03-20 09:48:47.762125+03	f	f	\N	\N	\N
258	41 цех получение материала	Получение материала со склада цветных металлов и чёрных металлов. Привезти в 10 корпус 41 цех заготовительный участок	4	500	2025-03-20 10:30:00	3	70	8	\N	2025-03-20 10:10:56.923626+03	2025-03-20 11:00:11.22822+03	2025-03-20 10:03:10.508481+03	f	f	\N	\N	\N
257	Калибры и пробки ( средства контроля деталей)	Цех 41 забрать 3 коробки с калибрами, переместить их в корпус 10 на склад калибров 25 отдела. Одну коробку переместить в корпус 10 на участок промывки. ( все коробки подписаны)	8	20	2025-03-20 10:30:00	3	18	8	AgACAgIAAxkBAAI_a2fbvQmW5tdhv31R-WB7f8WQkTZwAALh7zEbNZ3YSkrTkd7faafkAQADAgADeQADNgQ	2025-03-20 12:32:42.99921+03	2025-03-20 12:59:27.784194+03	2025-03-20 10:01:00.801966+03	f	f	\N	\N	\N
261	Заготовки	С заготовительного 46 на лазерный участок	4	2	2025-03-20 12:00:00	3	57	40	\N	2025-03-20 12:22:14.315694+03	2025-03-20 12:41:12.952127+03	2025-03-20 11:07:14.539498+03	f	f	\N	\N	\N
262	Калибры, пробки	Заказ \nНазвание груза: Калибры и пробки ( средства контроля деталей) \nОписание груза: Цех 41 корпус 60/2 (3 этаж, кладовая калибров) забрать 2 коробки с калибрами, переместить их в корпус 10 на склад калибров 25 отдела.	8	10	2025-03-20 13:30:00	3	18	8	\N	2025-03-20 12:33:27.646639+03	2025-03-20 12:59:06.549074+03	2025-03-20 11:09:51.938447+03	f	f	\N	\N	\N
253	Вывести металл на утильбазу	Забрать с лазерного участка 46ц 50 корпус ящики со стрижкой и металлом на утильбазу	6	20	2025-03-20 12:30:00	3	19	40	\N	2025-03-20 10:36:45.691065+03	2025-03-20 13:02:31.113755+03	2025-03-20 09:44:20.926439+03	f	f	\N	\N	\N
269	41-2 цех. Детали	Из 41-2 в 58. Трубка	1	0.5	2025-03-20 14:00:00	3	39	8	\N	2025-03-20 13:27:00.233745+03	2025-03-20 14:19:49.479594+03	2025-03-20 13:02:58.370111+03	f	f	\N	\N	\N
264	Цех 45	Отвезти детали на склад ПДО	1	1	2025-03-20 14:00:00	3	67	17	\N	2025-03-20 12:20:47.793881+03	2025-03-20 13:47:53.946621+03	2025-03-20 12:20:08.549158+03	f	f	\N	\N	\N
268	Забрать заготовки	Забрать заготовки с 46ц 68 корпус заготовка, отвезти на лазерный участок 50 корпус	1	2	2025-03-20 13:00:00	3	19	8	\N	2025-03-20 13:02:04.397149+03	2025-03-20 13:07:49.626836+03	2025-03-20 12:56:54.262334+03	f	f	\N	\N	\N
273	41-2 цех. Детали	Из 41-2 в 10 корп трубки	1	20	2025-03-20 14:00:00	3	39	8	\N	2025-03-20 13:27:14.471822+03	2025-03-20 14:20:17.055047+03	2025-03-20 13:07:41.94096+03	f	f	\N	\N	\N
275	Вывоз мусора	Нет	7	20	2025-03-20 13:00:00	3	16	61	\N	2025-03-20 13:11:17.977481+03	2025-03-20 13:11:25.419269+03	2025-03-20 13:10:50.360753+03	f	f	\N	\N	\N
263	Цех 45	Получить из метрологии инструмент	8	5	2025-03-20 13:00:00	3	22	17	\N	2025-03-20 12:16:04.37204+03	2025-03-20 13:46:45.780699+03	2025-03-20 12:15:26.69527+03	f	f	\N	\N	\N
272	41-2 цех. Детали	Из 41-2 в 44	1	3.6	2025-03-20 14:00:00	3	39	8	\N	2025-03-20 13:27:41.682742+03	2025-03-20 14:20:25.656266+03	2025-03-20 13:06:07.259537+03	f	f	\N	\N	\N
278	41	Отправка\n6т8130096-4  в 44ц\n936320            в 44ц\n931867            в 44ц	1	3	2025-03-20 14:00:00	3	30	8	\N	2025-03-20 13:27:56.483252+03	2025-03-20 14:20:33.022105+03	2025-03-20 13:19:53.641024+03	f	f	\N	\N	\N
271	41-2 цех. Детали	Из 41-2 в 46 и 46/12	1	10	2025-03-20 14:00:00	3	39	8	\N	2025-03-20 13:28:10.600945+03	2025-03-20 14:20:49.145089+03	2025-03-20 13:04:45.239377+03	f	f	\N	\N	\N
265	41	Ящик с деталями	1	10	2025-03-20 14:30:00	3	55	8	\N	2025-03-20 13:29:35.779893+03	2025-03-20 14:21:11.456308+03	2025-03-20 12:27:36.948683+03	f	f	\N	\N	\N
283	Пустые баллоны аргона	Забрать два пустых баллона	9	50	2025-03-20 14:00:00	3	37	62	\N	2025-03-20 13:50:18.043827+03	2025-03-20 14:26:46.637037+03	2025-03-20 13:49:28.154901+03	f	f	\N	\N	\N
282	Корпус	Нет	1	1	2025-03-20 14:00:00	3	47	40	\N	2025-03-20 14:14:45.245083+03	2025-03-20 14:30:13.842495+03	2025-03-20 13:48:55.390681+03	f	f	\N	\N	\N
276	Детали	Нет	1	5	2025-03-20 13:15:00	3	66	61	\N	2025-03-20 13:17:47.565179+03	2025-03-20 13:45:59.209587+03	2025-03-20 13:17:34.155181+03	f	f	\N	\N	\N
277	Нормали	Винты,шайбы	1	1	2025-03-20 13:45:00	3	47	40	\N	2025-03-20 13:20:21.271047+03	2025-03-20 13:38:14.19391+03	2025-03-20 13:19:16.364855+03	f	f	\N	\N	\N
280	Вывоз мусор и стружки	Нет	6	50	2025-03-20 14:00:00	3	63	62	\N	2025-03-20 13:37:28.102699+03	2025-03-20 13:44:34.610904+03	2025-03-20 13:35:32.570845+03	f	f	\N	\N	\N
281	Пружина	Нет	1	1	2025-03-20 13:45:00	3	47	40	\N	2025-03-20 13:41:27.224544+03	2025-03-20 14:30:28.215469+03	2025-03-20 13:40:36.969722+03	f	f	\N	\N	\N
267	46	46	10	10	2025-03-20 14:00:00	3	56	8	\N	2025-03-20 13:02:40.655976+03	2025-03-20 14:19:36.370626+03	2025-03-20 12:48:40.674584+03	f	f	\N	\N	\N
363	детали	с 44 цеха в 43 цех	1	10	2025-03-21 13:15:00	3	33	60	\N	2025-03-21 14:30:32.445387+03	2025-03-21 14:33:48.915317+03	2025-03-21 14:30:13.374764+03	f	f	\N	\N	\N
483	46	46	10	5	2025-03-25 12:00:00	3	56	8	\N	2025-03-25 12:03:59.066188+03	2025-03-25 15:01:16.103725+03	2025-03-25 11:19:17.497069+03	f	f	\N	\N	\N
274	41-2 цех. Детали	Из 41-2 в 06	1	2	2025-03-20 14:00:00	3	39	8	\N	2025-03-20 13:26:45.689448+03	2025-03-20 14:19:42.660487+03	2025-03-20 13:08:30.300503+03	f	f	\N	\N	\N
285	Колодка	Нет	1	1	2025-03-20 14:15:00	3	47	60	\N	2025-03-20 14:09:57.21914+03	2025-03-20 14:30:02.79246+03	2025-03-20 13:59:50.315924+03	f	f	\N	\N	\N
296	Надставки (трубы)	Забрать с трубного участка 46ц, отвезти в 41ц в 10ку	1	7	2025-03-21 10:00:00	3	19	8	\N	2025-03-21 08:08:21.525195+03	2025-03-21 08:27:34.796246+03	2025-03-21 08:05:08.017491+03	f	f	\N	\N	\N
298	Струе выпрямитель	Нет	1	0.5	2025-03-21 09:00:00	3	47	8	AgACAgIAAxkBAAJI5Wfc9hjgow3LJP84Yn7inoYv8R9tAALJ5DEbaD3oSq4sPM7OBmSOAQADAgADeQADNgQ	2025-03-21 08:18:26.319424+03	2025-03-21 08:28:07.896295+03	2025-03-21 08:16:14.701151+03	f	f	\N	\N	\N
295	Заготовки	Их заготовительного 46/68 на лазер 46/50 и в цех 46 к. 60/4	4	10	2025-03-21 08:00:00	3	57	8	\N	2025-03-21 07:48:34.535563+03	2025-03-21 08:28:52.022382+03	2025-03-21 07:43:57.883721+03	f	f	\N	\N	\N
286	Забрать штангельциркуль из метрологии 1.5 метра	Забрать из 11 корпуса, отдел метрологии 2 этаж и привезти в 46ц в корпус 60/4	8	5	2025-03-20 14:45:00	3	19	62	\N	2025-03-20 14:37:05.570297+03	2025-03-20 14:53:24.754308+03	2025-03-20 14:23:39.574111+03	f	f	\N	\N	\N
288	АПК, КПУ	С Метрологии МС35 в 43 цех	8	40	2025-03-20 13:00:00	3	33	60	\N	2025-03-20 14:44:31.896736+03	2025-03-20 15:11:56.65789+03	2025-03-20 14:44:11.576285+03	f	f	\N	\N	\N
289	ПДО	оборки со склада ПДО 6 отд в 43 цех	4	20	2025-03-20 13:15:00	3	33	60	\N	2025-03-20 14:52:05.190442+03	2025-03-20 15:12:07.258745+03	2025-03-20 14:51:43.119558+03	f	f	\N	\N	\N
287	Шкалы	Нет	1	1	2025-03-20 15:00:00	3	47	40	\N	2025-03-20 14:42:55.991798+03	2025-03-20 15:16:15.272398+03	2025-03-20 14:41:06.823371+03	f	f	\N	\N	\N
279	Вывоз мусора	Цех 41 корпус 10 вывоз производственного мусора на утиль базу 71 цеха	6	100	2025-03-20 14:00:00	3	18	40	\N	2025-03-20 13:38:01.404166+03	2025-03-20 15:16:26.75579+03	2025-03-20 13:34:10.358761+03	f	f	\N	\N	\N
317	Цех 45	Вывезти мусор и др.отходы	7	150	2025-03-21 13:00:00	3	11	17	\N	2025-03-21 09:54:04.557446+03	2025-03-21 13:31:09.240494+03	2025-03-21 09:53:14.245958+03	f	f	\N	\N	\N
307	Заготовки	Ящики с заготовками	4	30	2025-03-21 09:00:00	3	32	8	\N	2025-03-21 08:58:28.524791+03	2025-03-21 10:01:13.679856+03	2025-03-21 08:53:24.494611+03	f	f	\N	\N	\N
284	41 цех перевести плиту#45 из 61 цеха	Забрать в 61 цехе плиту Д16 #45  доставить в 10 корпус, заготовительный участок	4	150	2025-03-20 14:30:00	3	70	40	\N	2025-03-20 15:19:38.854956+03	2025-03-20 15:32:31.016645+03	2025-03-20 13:50:11.264608+03	f	f	\N	\N	\N
291	Изделия	Изделия из 43 цеха в 59 станцию	10	15	2025-03-20 15:15:00	3	33	60	\N	2025-03-20 15:25:45.484832+03	2025-03-20 15:42:46.243404+03	2025-03-20 15:25:25.724908+03	f	f	\N	\N	\N
293	Детали	Нет	1	2	2025-03-20 15:45:00	3	66	61	\N	2025-03-20 15:49:31.30493+03	2025-03-20 16:06:16.624131+03	2025-03-20 15:47:32.373928+03	f	f	\N	\N	\N
306	41/10-3 Развозка	Развозка от 41/10-3 согласно сдаточным накладным.	1	400	2025-03-21 09:00:00	3	46	8	\N	2025-03-21 08:59:18.766886+03	2025-03-21 10:03:28.709248+03	2025-03-21 08:52:20.07313+03	f	f	\N	\N	\N
314	Фланец	Нет	1	1	2025-03-21 10:15:00	3	47	40	\N	2025-03-21 09:58:13.56238+03	2025-03-21 10:22:42.443941+03	2025-03-21 09:38:05.234946+03	f	f	\N	\N	\N
300	Детали	В термичку	1	2	2025-03-21 09:00:00	3	54	62	\N	2025-03-21 08:32:46.253231+03	2025-03-21 08:41:47.375858+03	2025-03-21 08:30:58.243239+03	f	f	\N	\N	\N
316	6т6236003*	Нет	1	1	2025-03-21 10:30:00	3	47	40	\N	2025-03-21 09:59:33.002183+03	2025-03-21 10:49:51.551247+03	2025-03-21 09:47:59.903689+03	f	f	\N	\N	\N
308	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	8	2025-03-21 08:30:00	3	33	60	\N	2025-03-21 08:58:55.210837+03	2025-03-21 09:42:42.549961+03	2025-03-21 08:58:31.940717+03	f	f	\N	\N	\N
312	Быт отходы	5 ящиков	7	200	2025-03-21 13:30:00	3	69	40	\N	2025-03-21 10:50:43.904796+03	2025-03-21 13:48:13.153247+03	2025-03-21 09:34:13.365179+03	f	f	\N	\N	\N
299	41-2 цех. Детали	Из 41-2 в 06, корпус 6/7, 46/12, 46/8, 44	1	15	2025-03-21 09:00:00	3	39	8	\N	2025-03-21 08:29:40.123517+03	2025-03-21 10:01:06.874778+03	2025-03-21 08:24:41.417167+03	f	f	\N	\N	\N
309	46	46	10	5	2025-03-21 09:00:00	3	56	8	\N	2025-03-21 08:59:51.725892+03	2025-03-21 10:03:44.00939+03	2025-03-21 08:58:38.185291+03	f	f	\N	\N	\N
301	Материал ,лист 3000х1200х1,5 d16	Нет	4	30	2025-03-21 09:00:00	3	32	8	\N	2025-03-21 10:21:40.31304+03	2025-03-21 10:21:54.359956+03	2025-03-21 08:39:10.847719+03	f	f	\N	\N	\N
304	Забрать плиту со скоростной фрезеровки, 61ц. корпус 50	Нет	1	120	2025-03-21 09:00:00	3	63	62	\N	2025-03-21 08:43:04.183105+03	2025-03-21 09:32:37.362412+03	2025-03-21 08:41:52.718903+03	f	f	\N	\N	\N
297	Вода	Забрать пустые бутылки с трубного участка 46ц и привезти полные	5	50	2025-03-21 10:30:00	3	19	8	\N	2025-03-21 08:48:57.95313+03	2025-03-21 10:00:59.80353+03	2025-03-21 08:06:38.742264+03	f	f	\N	\N	\N
302	Мусор	Нет	6	50	2025-03-21 09:00:00	3	47	40	\N	2025-03-21 08:42:40.481225+03	2025-03-21 09:36:05.078133+03	2025-03-21 08:41:04.637002+03	f	f	\N	\N	\N
310	Забрать детали с лазерного участка	Забрать с лазерного участка 46ц, привести в цех 60/4	1	5	2025-03-21 09:45:00	3	19	62	\N	2025-03-21 09:34:21.2861+03	2025-03-21 09:47:32.685557+03	2025-03-21 09:20:11.618303+03	f	f	\N	\N	\N
311	45 цех	Привезти стабилизатор с цеха 41, 8 участок, корпус 10	9	50	2025-03-21 09:30:00	3	11	17	\N	2025-03-21 09:30:07.884063+03	2025-03-21 09:51:27.563498+03	2025-03-21 09:29:36.515613+03	f	f	\N	\N	\N
305	Мусор, картон	Нет	6	30	2025-03-21 12:00:00	3	47	40	\N	2025-03-21 08:43:02.958295+03	2025-03-21 13:36:58.955416+03	2025-03-21 08:42:44.760487+03	f	f	\N	\N	\N
303	Мусор	Нет	6	30	2025-03-21 10:00:00	3	47	40	\N	2025-03-21 08:42:20.236341+03	2025-03-21 09:57:07.302071+03	2025-03-21 08:41:45.887168+03	f	f	\N	\N	\N
290	Химия	Нет	4	1	2025-03-21 13:00:00	3	47	40	\N	2025-03-20 15:17:26.324737+03	2025-03-21 13:11:06.789009+03	2025-03-20 15:16:22.276009+03	f	f	\N	\N	\N
318	41 цех детали	На складе 06, получить колпачки 6т8634759 , 36шт. Привезти в 41 цех 10 корпус. На складе всё подготовят.	1	1	2025-03-21 14:00:00	3	41	8	\N	2025-03-21 10:34:58.446317+03	2025-03-21 14:41:30.086115+03	2025-03-21 09:53:23.62273+03	f	f	\N	\N	\N
292	Кислота	В канистрах	4	28	2025-03-21 10:00:00	3	34	61	\N	2025-03-21 10:26:39.121519+03	2025-03-21 10:27:04.011642+03	2025-03-20 15:39:21.02169+03	f	f	\N	\N	\N
319	41 цех	Из 52 цеха, картонная тара, в 50 корпус	9	1	2025-03-21 12:00:00	3	42	40	\N	2025-03-21 09:59:09.363361+03	2025-03-21 12:55:19.631734+03	2025-03-21 09:55:44.542799+03	f	f	\N	\N	\N
313	Фланец	Нет	1	1	2025-03-21 10:00:00	3	47	40	\N	2025-03-21 09:58:04.11972+03	2025-03-21 10:37:06.70563+03	2025-03-21 09:37:13.396704+03	f	f	\N	\N	\N
294	41 цех	Из 52 в 50 корп картонная тара	9	2	2025-03-21 12:00:00	3	42	8	\N	2025-03-21 10:35:16.637043+03	2025-03-21 12:52:57.132222+03	2025-03-21 07:40:57.412338+03	f	f	\N	\N	\N
1415	Лист ст 20 0,5	1250х2500	4	10	2025-04-10 12:00:00	3	32	61	\N	2025-04-10 10:42:02.339333+03	2025-04-10 12:21:56.254932+03	2025-04-10 10:41:55.814791+03	t	f	5	34	38
315	Картонная тара	Забрать картонную тару с 46ц 60/4 1 этаж ( у комнаты мастеров), отвезти на трубный участок 46ц 50 корпус	9	4	2025-03-21 10:00:00	3	19	62	\N	2025-03-21 09:48:37.855567+03	2025-03-21 10:00:11.089754+03	2025-03-21 09:38:45.832057+03	f	f	\N	\N	\N
344	Детали	Покраска	1	10	2025-03-21 13:00:00	3	54	62	\N	2025-03-21 12:47:21.23377+03	2025-03-21 14:02:55.354894+03	2025-03-21 12:46:34.40205+03	f	f	\N	\N	\N
335	Шкалы	Нет	1	1	2025-03-21 12:45:00	3	47	40	\N	2025-03-21 12:22:50.512205+03	2025-03-21 12:39:41.696137+03	2025-03-21 12:21:21.519837+03	f	f	\N	\N	\N
336	Фланцы	Нет	1	15	2025-03-21 12:30:00	3	66	40	\N	2025-03-21 12:31:50.461924+03	2025-03-21 12:39:59.117581+03	2025-03-21 12:31:39.026306+03	f	f	\N	\N	\N
323	Вывоз мусора	Нет	7	50	2025-03-21 10:30:00	3	63	62	\N	2025-03-21 10:30:39.347883+03	2025-03-21 10:38:29.460449+03	2025-03-21 10:30:14.481604+03	f	f	\N	\N	\N
322	Умг3*2	Нет	10	1	2025-03-21 10:45:00	3	47	40	\N	2025-03-21 10:29:00.793381+03	2025-03-21 10:50:07.662413+03	2025-03-21 10:28:00.392394+03	f	f	\N	\N	\N
320	Фланцы на лужение.Корпуса 176-ые.	Нет	1	15	2025-03-21 10:15:00	3	66	40	\N	2025-03-21 10:23:06.445919+03	2025-03-21 10:50:23.574684+03	2025-03-21 10:16:08.703065+03	f	f	\N	\N	\N
324	41. Футорки	40 футорок (коммерческий заказ от ТП ИС), покрыты олово-висмутом. Из гальваники в 10 корпус	1	20	2025-03-21 12:00:00	3	9	40	\N	2025-03-21 12:23:46.232558+03	2025-03-21 12:40:28.020314+03	2025-03-21 10:51:54.576446+03	f	f	\N	\N	\N
325	Вода	Пустые Бутыли для воды с 43 цеха в 94 ангар	5	200	2025-03-21 09:30:00	3	33	60	\N	2025-03-21 11:18:27.015136+03	2025-03-21 11:18:50.834445+03	2025-03-21 11:18:07.361933+03	f	f	\N	\N	\N
326	Вода	С 94 ангара в 43 цех бутыли с водой	5	200	2025-03-21 09:30:00	3	33	60	\N	2025-03-21 11:20:53.822608+03	2025-03-21 11:21:11.660235+03	2025-03-21 11:20:34.552355+03	f	f	\N	\N	\N
327	Изделия	С 43 цеха в 59 станцию	10	6	2025-03-21 10:15:00	3	33	60	\N	2025-03-21 11:23:44.499305+03	2025-03-21 11:23:56.674096+03	2025-03-21 11:23:24.634336+03	f	f	\N	\N	\N
350	Картон	Нет	9	1	2025-03-21 15:00:00	3	47	40	\N	2025-03-21 13:00:34.166952+03	2025-03-21 15:12:22.428383+03	2025-03-21 13:00:11.290856+03	f	f	\N	\N	\N
328	Принтер	МФУ с 39 отд в 43 цех	9	25	2025-03-21 10:30:00	3	33	60	\N	2025-03-21 11:26:59.81473+03	2025-03-21 11:27:45.691806+03	2025-03-21 11:26:45.271643+03	f	f	\N	\N	\N
352	Детали	С 8 термич участка  в цех 46	4	2	2025-03-21 13:15:00	3	57	8	\N	2025-03-21 13:03:02.652828+03	2025-03-21 13:22:31.286847+03	2025-03-21 13:02:44.911517+03	f	f	\N	\N	\N
338	Прокладка	1 этаж	10	1	2025-03-21 12:30:00	3	20	8	\N	2025-03-21 12:50:47.240784+03	2025-03-21 13:22:55.139271+03	2025-03-21 12:34:53.844105+03	f	f	\N	\N	\N
358	Корпуса 709-01	Нет	1	30	2025-03-21 13:45:00	3	66	61	\N	2025-03-21 13:46:35.397326+03	2025-03-21 14:13:56.805854+03	2025-03-21 13:44:52.363556+03	f	f	\N	\N	\N
329	46	46	10	5	2025-03-21 12:30:00	3	56	8	\N	2025-03-21 12:49:42.076329+03	2025-03-21 13:23:09.817534+03	2025-03-21 11:52:29.52269+03	f	f	\N	\N	\N
321	Забрать детали с гальваники, 44 цех	🫸	1	3	2025-03-21 13:00:00	3	63	62	\N	2025-03-21 10:27:54.628251+03	2025-03-21 14:01:50.431246+03	2025-03-21 10:26:36.845398+03	f	f	\N	\N	\N
339	Заготовки	Из заготовительного на лазерный участок	4	3	2025-03-21 14:00:00	3	57	8	\N	2025-03-21 12:50:22.340557+03	2025-03-21 13:24:35.83293+03	2025-03-21 12:35:33.973697+03	f	f	\N	\N	\N
353	41	Отправка \n6т8310073   в 44ц\n6л8220185 в 44ц\n6т8225083  на склад	1	3	2025-03-21 14:00:00	3	30	8	\N	2025-03-21 13:25:49.367661+03	2025-03-21 14:41:14.127065+03	2025-03-21 13:11:30.56422+03	f	f	\N	\N	\N
1416	Ярлык	На заготовку	9	1	2025-04-10 12:00:00	3	20	58	\N	2025-04-10 11:13:27.134708+03	2025-04-10 13:00:10.50911+03	2025-04-10 10:59:45.357133+03	t	f	5	44	38
342	41/10-3 промывка	Привести из 60 корпуса 3 этажа детали "Корпуса - 6т8034170" из промывки -> в 10 корпус БТК	1	30	2025-03-21 13:30:00	3	46	8	\N	2025-03-21 13:27:35.148701+03	2025-03-21 14:41:52.69293+03	2025-03-21 12:38:19.475152+03	f	f	\N	\N	\N
343	41/10-3 Развозка	Развозка от 41/10-3 согласно сдаточным накладным.	1	25	2025-03-21 14:00:00	3	46	8	\N	2025-03-21 12:51:44.262548+03	2025-03-21 14:41:40.696078+03	2025-03-21 12:42:27.136187+03	f	f	\N	\N	\N
1417	Вода	Отвезти пустые бутылки, привезти новые	5	200	2025-04-10 12:00:00	3	19	58	\N	2025-04-10 11:20:14.271663+03	2025-04-10 13:01:21.26947+03	2025-04-10 11:19:40.984646+03	f	f	5	41	12
333	45 цех	Отвезти детали на склад ПДО	1	2	2025-03-21 14:00:00	3	67	17	\N	2025-03-21 12:12:09.084115+03	2025-03-21 14:11:30.376982+03	2025-03-21 12:11:49.245374+03	f	f	\N	\N	\N
348	Вывоз мусора	Нет	7	30	2025-03-21 13:00:00	3	63	62	\N	2025-03-21 14:09:17.035583+03	2025-03-21 15:02:29.124423+03	2025-03-21 12:57:36.873283+03	f	f	\N	\N	\N
355	41-2 цех. Детали	Из 41-2 в 44	1	16	2025-03-21 14:00:00	3	39	8	\N	2025-03-21 13:26:37.890524+03	2025-03-21 14:40:39.125131+03	2025-03-21 13:24:25.810891+03	f	f	\N	\N	\N
334	Эл.двигатель	Нет	9	25	2025-03-21 13:15:00	3	32	61	\N	2025-03-21 12:14:59.603489+03	2025-03-21 13:15:09.838467+03	2025-03-21 12:14:44.655235+03	f	f	\N	\N	\N
330	Лист 3000х1200х1,5 d16	Нет	4	30	2025-03-21 13:00:00	3	32	61	\N	2025-03-21 12:08:55.955885+03	2025-03-21 13:15:44.768277+03	2025-03-21 12:08:05.305007+03	f	f	\N	\N	\N
332	Быт отходы	Нет	6	100	2025-03-21 13:00:00	3	32	61	\N	2025-03-21 12:11:25.8325+03	2025-03-21 13:16:08.079158+03	2025-03-21 12:10:48.725256+03	f	f	\N	\N	\N
337	Шайба	1 этаж	10	1	2025-03-21 12:30:00	3	20	8	\N	2025-03-21 12:49:58.19391+03	2025-03-21 13:23:27.36222+03	2025-03-21 12:34:10.895924+03	f	f	\N	\N	\N
340	Ярлык	1 этаж	9	1	2025-03-21 12:30:00	3	20	8	\N	2025-03-21 12:51:05.819689+03	2025-03-21 13:23:47.339233+03	2025-03-21 12:36:12.629253+03	f	f	\N	\N	\N
341	Заготовки	Из заготовительного в цех	4	3	2025-03-21 14:00:00	3	57	8	\N	2025-03-21 12:52:13.979548+03	2025-03-21 13:24:19.425562+03	2025-03-21 12:37:07.182422+03	f	f	\N	\N	\N
354	41-2 цех. Детали	Из 41-2 в 06	1	2	2025-03-21 14:00:00	3	39	8	\N	2025-03-21 13:25:59.684364+03	2025-03-21 14:40:55.406419+03	2025-03-21 13:23:34.133373+03	f	f	\N	\N	\N
351	Картон	Нет	9	1	2025-03-21 15:00:00	3	47	40	\N	2025-03-21 13:01:25.88385+03	2025-03-21 14:50:57.930195+03	2025-03-21 13:00:51.524572+03	f	f	\N	\N	\N
331	Цех 45	Забрать принтер	9	5	2025-03-21 13:30:00	3	67	17	\N	2025-03-21 12:10:39.386431+03	2025-03-21 13:31:30.182231+03	2025-03-21 12:10:09.083506+03	f	f	\N	\N	\N
349	Отвезти детали в термичку	Нет	1	5	2025-03-21 13:15:00	3	63	62	\N	2025-03-21 12:59:48.461935+03	2025-03-21 13:47:40.450473+03	2025-03-21 12:59:26.892632+03	f	f	\N	\N	\N
361	Детали	с 43 цеха в 44 цех	1	10	2025-03-21 12:30:00	3	33	60	\N	2025-03-21 14:23:59.506209+03	2025-03-21 14:33:28.887678+03	2025-03-21 14:23:40.576712+03	f	f	\N	\N	\N
360	41/60-2 Вывоз мусора	Вынести мусор из 41/60 \n3 этажа мусор в утиль-базу	7	150	2025-03-21 14:30:00	3	46	8	\N	2025-03-21 14:30:09.877768+03	2025-03-21 14:40:00.703283+03	2025-03-21 14:23:09.012931+03	f	f	\N	\N	\N
357	41-2 цех. Детали	Из 41-2 в 10корп и 43ц	1	1.1	2025-03-21 14:00:00	3	39	8	\N	2025-03-21 13:26:22.191556+03	2025-03-21 14:40:22.973712+03	2025-03-21 13:25:33.386021+03	f	f	\N	\N	\N
359	Детали в термичку	Детали в термичку 46 с 43 цеха	1	8	2025-03-21 12:30:00	3	33	60	\N	2025-03-21 14:21:04.870276+03	2025-03-21 14:33:15.470684+03	2025-03-21 14:20:43.075231+03	f	f	\N	\N	\N
362	ТАРА в ПДО	с 43 цеха на склад ПДО 6 отд	9	30	2025-03-21 12:30:00	3	33	60	\N	2025-03-21 14:27:36.502317+03	2025-03-21 14:33:37.898256+03	2025-03-21 14:27:17.829932+03	f	f	\N	\N	\N
364	отборки	Со склда ПДО 6 отд в 43 цех	4	10	2025-03-21 13:30:00	3	33	60	\N	2025-03-21 14:32:43.645324+03	2025-03-21 14:33:58.57145+03	2025-03-21 14:32:23.774945+03	f	f	\N	\N	\N
385	Заготовки	Из заготовительного 46 на лазер	4	6	2025-03-24 08:30:00	3	57	8	\N	2025-03-24 08:24:21.365301+03	2025-03-24 10:01:24.941543+03	2025-03-24 08:13:35.053299+03	f	f	\N	\N	\N
380	41/3-10к. Развозка деталей.	Забрать детали из БТК 10 корпуса и отвезти детали согласно сдаточным накладным.	1	25	2025-03-24 09:00:00	3	46	8	\N	2025-03-24 08:23:01.346415+03	2025-03-24 09:50:38.969698+03	2025-03-24 07:58:06.206898+03	f	f	\N	\N	\N
356	41/10-3 Стружка	Вывести стружку в 41 цеху в 10 корпусе на утиль бызу	6	400	2025-03-21 13:30:00	3	46	8	\N	2025-03-21 14:30:31.825754+03	2025-03-21 15:03:14.784138+03	2025-03-21 13:25:24.834404+03	f	f	\N	\N	\N
381	46	46	10	10	2025-03-24 09:00:00	3	56	8	\N	2025-03-24 08:23:55.352128+03	2025-03-24 09:50:48.383635+03	2025-03-24 07:59:24.423752+03	f	f	\N	\N	\N
383	41-2 цех. Детали	Из 41-2 в 06, 46/8,10	1	8.5	2025-03-24 09:00:00	3	39	8	\N	2025-03-24 08:22:29.926555+03	2025-03-24 09:50:27.774578+03	2025-03-24 08:08:02.069033+03	f	f	\N	\N	\N
369	Фланцы	Аварийные	1	10	2025-03-21 15:15:00	3	66	40	\N	2025-03-21 15:20:23.579851+03	2025-03-21 15:28:17.932148+03	2025-03-21 15:13:18.454737+03	f	f	\N	\N	\N
368	Дно	6т8614172-01	1	10	2025-03-21 15:15:00	3	66	40	\N	2025-03-21 15:11:53.215407+03	2025-03-21 15:29:56.206476+03	2025-03-21 15:06:13.42134+03	f	f	\N	\N	\N
367	Трубы	Нет	1	1	2025-03-21 15:15:00	3	47	40	\N	2025-03-21 15:11:39.477439+03	2025-03-21 15:31:18.463312+03	2025-03-21 14:52:10.337694+03	f	f	\N	\N	\N
366	Фланец	Нет	1	1	2025-03-21 15:15:00	3	47	40	\N	2025-03-21 14:53:19.224954+03	2025-03-21 15:31:29.508121+03	2025-03-21 14:51:25.95518+03	f	f	\N	\N	\N
371	Сбыт	С 43 цеха в 79 отд	10	12	2025-03-21 15:15:00	3	33	60	\N	2025-03-21 15:22:56.471248+03	2025-03-21 15:39:44.009356+03	2025-03-21 15:22:38.632415+03	f	f	\N	\N	\N
372	Изделия	С 43 цеха на 59 станцию	10	6	2025-03-21 15:15:00	3	33	60	\N	2025-03-21 15:24:42.699471+03	2025-03-21 15:39:58.143167+03	2025-03-21 15:24:26.195991+03	f	f	\N	\N	\N
365	Отборки	Нет	1	1	2025-03-21 15:00:00	3	47	40	\N	2025-03-21 14:45:24.509231+03	2025-03-21 15:41:04.930578+03	2025-03-21 14:43:51.528711+03	f	f	\N	\N	\N
373	Детали	Нет	1	30	2025-03-21 15:30:00	3	66	61	\N	2025-03-21 15:40:18.0328+03	2025-03-21 15:59:58.550204+03	2025-03-21 15:39:40.722602+03	f	f	\N	\N	\N
1421	Туалетная бумага	Нет	4	20	2025-04-10 08:30:00	3	33	60	\N	2025-04-10 11:30:44.606365+03	2025-04-10 11:38:41.336296+03	2025-04-10 11:30:37.355885+03	f	f	\N	8	31
384	Заготовки	Из заготовительного 46 в цех	4	5	2025-03-24 08:30:00	3	57	8	\N	2025-03-24 08:14:35.86986+03	2025-03-24 10:01:16.666443+03	2025-03-24 08:12:19.102411+03	t	f	\N	\N	\N
390	цех 45	Сдать спец.одежду в стирку	9	15	2025-03-24 09:00:00	3	22	17	\N	2025-03-24 08:34:16.036679+03	2025-03-24 09:11:46.585817+03	2025-03-24 08:33:57.580628+03	t	f	\N	\N	\N
387	Детали	Термичка	1	2	2025-03-24 09:00:00	3	54	62	\N	2025-03-24 08:27:27.428871+03	2025-03-24 08:32:44.903027+03	2025-03-24 08:26:22.427537+03	t	f	\N	\N	\N
386	Спецодежда в стирку	Нет	9	2	2025-03-24 08:30:00	3	63	62	\N	2025-03-24 08:28:03.953961+03	2025-03-24 08:33:10.017173+03	2025-03-24 08:24:37.440449+03	t	f	\N	\N	\N
388	41 цех	10 корпус, стирка, прачечная	9	2	2025-03-24 09:00:00	3	42	8	\N	2025-03-24 08:32:42.220198+03	2025-03-24 08:55:14.978306+03	2025-03-24 08:32:35.20003+03	f	f	\N	\N	\N
378	41 цех	Стирка из 60/2 3 этаж\nИз 10 корп> прачечная	9	3	2025-03-24 09:00:00	3	42	8	\N	2025-03-24 07:12:49.123466+03	2025-03-24 08:55:41.574372+03	2025-03-24 07:10:54.742292+03	f	f	\N	\N	\N
389	Форма	Т6571-920	8	10	2025-03-24 09:00:00	3	36	62	\N	2025-03-24 08:48:12.491312+03	2025-03-24 08:56:36.917988+03	2025-03-24 08:32:49.544136+03	t	f	\N	\N	\N
395	Халаты, спец одежда	В прачечную с 43 цеха	9	8	2025-03-24 08:45:00	3	33	60	\N	2025-03-24 09:12:03.010366+03	2025-03-24 09:26:32.789199+03	2025-03-24 09:11:44.983794+03	f	f	\N	\N	\N
391	цех45	Отправить весы и гири в метрологию	9	4	2025-03-24 09:30:00	3	22	17	\N	2025-03-24 08:38:11.542083+03	2025-03-24 09:11:13.925344+03	2025-03-24 08:38:07.982257+03	t	f	\N	\N	\N
379	41	Отправка \n6т7756001-11    46/12\n6т7756001-17    46/12\n919381                44	1	3	2025-03-24 09:00:00	3	30	8	\N	2025-03-24 07:22:52.349357+03	2025-03-24 10:01:06.608843+03	2025-03-24 07:22:14.2212+03	f	f	\N	\N	\N
396	Одежда	Нет	9	5	2025-03-24 09:00:00	3	16	61	\N	2025-03-24 09:13:28.491983+03	2025-03-24 09:13:40.605781+03	2025-03-24 09:13:18.157457+03	f	f	\N	\N	\N
402	Фланец	Нет	1	5	2025-03-24 10:15:00	3	47	62	\N	2025-03-24 10:17:13.086472+03	2025-03-24 10:46:34.560221+03	2025-03-24 10:08:00.933049+03	t	f	\N	\N	\N
398	цех45	получение инструмента с метрологии	9	5	2025-03-24 10:00:00	3	22	17	\N	2025-03-24 09:18:33.609499+03	2025-03-24 09:59:46.169658+03	2025-03-24 09:18:27.952234+03	t	f	\N	\N	\N
394	ПКИ	Комплектующие с 14 отд в 43 цех	4	15	2025-03-24 08:30:00	3	33	60	\N	2025-03-24 09:07:10.378142+03	2025-03-24 09:26:19.17065+03	2025-03-24 09:06:50.103011+03	f	f	\N	\N	\N
399	Матрица	Нет	1	2	2025-03-24 09:45:00	3	54	62	\N	2025-03-24 09:29:43.52233+03	2025-03-24 10:14:16.42201+03	2025-03-24 09:29:12.572008+03	t	f	\N	\N	\N
382	46	46	10	5	2025-03-24 09:00:00	3	56	8	\N	2025-03-24 08:23:27.700715+03	2025-03-24 09:50:20.053422+03	2025-03-24 08:01:10.701888+03	f	f	\N	\N	\N
370	Корпуса.Панели	Нет	1	10	2025-03-21 15:15:00	3	66	61	\N	2025-03-24 09:18:57.657407+03	2025-03-24 09:53:03.747279+03	2025-03-21 15:14:58.441192+03	f	f	\N	\N	\N
401	Заготовки d16	Два ящика	4	10	2025-03-24 10:00:00	3	32	61	\N	2025-03-24 09:51:31.52511+03	2025-03-24 09:52:05.038274+03	2025-03-24 09:51:13.676967+03	f	f	\N	\N	\N
400	Получить воду	Нет	5	100	2025-03-24 09:45:00	3	63	62	\N	2025-03-24 09:37:19.744244+03	2025-03-24 10:14:01.18132+03	2025-03-24 09:37:01.747729+03	t	f	\N	\N	\N
393	Вода	Вода	5	19	2025-03-24 09:30:00	3	47	40	\N	2025-03-24 08:53:52.931128+03	2025-03-24 10:19:09.391584+03	2025-03-24 08:53:49.432095+03	t	f	\N	\N	\N
407	Шасси	Нет	1	1	2025-03-24 12:15:00	3	47	40	\N	2025-03-24 12:02:51.012064+03	2025-03-24 12:46:26.293413+03	2025-03-24 11:57:54.409988+03	t	f	\N	\N	\N
397	Хим. отходы	Нет	9	500	2025-03-24 09:15:00	3	16	61	\N	2025-03-24 09:14:51.033853+03	2025-03-24 10:45:28.300516+03	2025-03-24 09:14:40.22116+03	f	f	\N	\N	\N
1420	ПКИ	Нет	4	15	2025-04-10 08:30:00	3	33	60	\N	2025-04-10 11:28:57.000106+03	2025-04-10 11:38:29.303319+03	2025-04-10 11:28:43.304715+03	f	f	\N	8	31
1418	Стружка с лазерного станка	Вывезти стружку с участка лазерной резки	6	80	2025-04-10 12:15:00	3	19	58	\N	2025-04-10 11:22:52.275723+03	2025-04-10 12:58:18.788345+03	2025-04-10 11:21:27.91771+03	f	f	5	67	57
404	Приборы	43	8	15	2025-03-24 12:15:00	3	27	60	\N	2025-03-24 10:47:42.972601+03	2025-03-24 13:13:42.634952+03	2025-03-24 10:47:13.765539+03	f	f	\N	\N	\N
403	КЗ, крышки 000416	Крышки, 92 шт, 4 ящика	1	46	2025-03-24 12:00:00	3	9	8	\N	2025-03-24 10:24:52.413989+03	2025-03-24 12:11:37.988575+03	2025-03-24 10:24:19.78815+03	f	f	\N	\N	\N
392	Мусор	Цех 41 корп 50 вывоз деревянных ящиков и палет на утильбазу цеха 71	6	40	2025-03-24 09:45:00	3	18	8	AgACAgIAAxkBAAJZvWfg790NY45wQsrspdKWiyj3t45mAAKo8zEbEpEISy6bxcbilqb5AQADAgADeQADNgQ	2025-03-24 10:08:39.942881+03	2025-03-24 10:47:11.97286+03	2025-03-24 08:39:00.666257+03	f	f	\N	\N	\N
1422	Платы	Нет	4	15	2025-04-10 08:45:00	3	33	60	\N	2025-04-10 11:34:00.5606+03	2025-04-10 11:38:48.614587+03	2025-04-10 11:33:54.150049+03	f	f	\N	18	31
1423	Вода	9 бутылей	5	180	2025-04-10 10:00:00	3	33	60	\N	2025-04-10 11:36:46.179733+03	2025-04-10 11:38:56.12894+03	2025-04-10 11:36:38.849752+03	f	f	\N	31	62
1424	Вода	9 бутылей полные	5	180	2025-04-10 10:15:00	3	33	60	\N	2025-04-10 11:38:19.832573+03	2025-04-10 11:39:09.543351+03	2025-04-10 11:38:10.497864+03	f	f	\N	62	31
1525	Футор 002289, К/З ТП ИС\n40 штук от мойки корпуса 10 в отк цеха41 (3 этаж)	Нет	1	20	2025-04-11 13:30:00	3	9	8	\N	2025-04-11 13:28:26.053438+03	2025-04-11 14:29:56.873335+03	2025-04-11 13:19:59.594641+03	t	f	5	25	24
1419	41/10 детали	С загот.уч. 41/10 отвезти детали 6т8057020 в 46/12	1	70	2025-04-10 12:00:00	3	74	8	\N	2025-04-10 11:44:15.134514+03	2025-04-10 12:14:52.346695+03	2025-04-10 11:26:07.741658+03	f	f	5	26	39
1425	Корпуса и Крышки	После травления!!!	1	30	2025-04-10 11:45:00	3	16	8	AgACAgIAAxkBAAEBJzdn94XL_DyTh2_6B7A3c-wbwiDUegACiewxGycawUv5mJNKxv8ZZAEAAwIAA3kAAzYE	2025-04-10 11:49:21.698372+03	2025-04-10 12:17:05.08522+03	2025-04-10 11:48:48.702933+03	t	f	5	34	44
1427	46	46	10	2	2025-04-10 12:00:00	3	56	58	\N	2025-04-10 12:00:15.437629+03	2025-04-10 12:58:38.726838+03	2025-04-10 11:51:47.409039+03	f	f	\N	43	24
1426	46	46	10	2	2025-04-10 12:00:00	3	56	58	\N	2025-04-10 12:00:02.855237+03	2025-04-10 12:59:58.632715+03	2025-04-10 11:50:37.111905+03	f	f	\N	43	35
1428	46	46	10	3	2025-04-10 12:00:00	3	56	58	\N	2025-04-10 12:00:25.463292+03	2025-04-10 13:01:14.919323+03	2025-04-10 11:52:47.996858+03	f	f	\N	43	63
1429	Трубы на трубный участок	Трубы на трубный участок	1	12	2025-04-10 12:15:00	3	19	58	\N	2025-04-10 11:59:39.613662+03	2025-04-10 12:58:55.051721+03	2025-04-10 11:59:28.893767+03	f	f	5	43	41
1552	Готовые детали	Нет	1	15	2025-04-11 15:30:00	4	16	\N	\N	\N	\N	2025-04-11 15:37:07.512978+03	t	f	\N	34	31
1555	Сбыт	2ка	10	15	2025-04-11 15:15:00	3	33	60	\N	2025-04-11 15:55:19.539934+03	2025-04-11 15:57:03.505572+03	2025-04-11 15:55:06.20031+03	f	f	\N	31	61
1556	Изделия	Нет	10	20	2025-04-11 15:15:00	3	33	60	\N	2025-04-11 15:56:48.623128+03	2025-04-11 15:57:10.781733+03	2025-04-11 15:56:34.981264+03	f	f	\N	31	53
1548	Заготовки	В в цех	4	4	2025-04-11 14:45:00	3	57	58	\N	2025-04-11 14:40:44.54827+03	2025-04-11 15:04:15.186074+03	2025-04-11 14:40:09.518513+03	f	f	\N	38	43
1549	Заготовки	В цех	4	3	2025-04-11 14:45:00	3	57	58	\N	2025-04-11 14:45:40.171312+03	2025-04-11 15:04:22.655784+03	2025-04-11 14:41:40.366243+03	f	f	\N	40	43
1557	Детали из пескоструйку на промывку, цех 41.	Нет	1	20	2025-04-11 16:00:00	1	9	\N	\N	\N	\N	2025-04-11 16:00:58.715083+03	t	f	\N	27	25
1551	Шкалы	Матить	1	1	2025-04-11 15:30:00	3	47	40	\N	2025-04-11 15:25:13.244998+03	2025-04-11 15:32:24.243458+03	2025-04-11 15:17:40.867901+03	t	f	5	51	34
1550	Колодка	Забрать из 117 кабинета,отвезти в прб 41 цеха	1	15	2025-04-11 15:15:00	3	47	40	\N	2025-04-11 15:01:19.37061+03	2025-04-11 15:32:32.37238+03	2025-04-11 15:00:58.683204+03	t	f	5	51	24
1554	Готовые детали	Нет	1	10	2025-04-11 15:30:00	3	16	61	\N	2025-04-11 15:39:15.029284+03	2025-04-11 16:23:36.833998+03	2025-04-11 15:39:10.613274+03	t	f	5	34	2
1553	Готовые детали	Нет	1	1	2025-04-11 15:30:00	3	16	61	\N	2025-04-11 15:40:55.645537+03	2025-04-11 16:23:52.563987+03	2025-04-11 15:38:08.95102+03	t	f	5	34	51
405	Мусор производственный	Цех 41 корп 50 вывоз деревянных ящиков и палет на утильбазу цеха 71\n\n━━━━━━━━━━━━━━━━━━	6	40	2025-03-24 11:15:00	3	18	8	\N	2025-03-24 10:49:51.479444+03	2025-03-24 12:49:42.524629+03	2025-03-24 10:49:29.34333+03	f	f	\N	\N	\N
1431	Детали	В 41 цех	4	3	2025-04-10 12:15:00	3	57	8	\N	2025-04-10 12:07:20.200654+03	2025-04-10 12:17:20.592351+03	2025-04-10 12:07:15.092276+03	f	f	\N	39	24
1430	Детали	В 41 цех	4	40	2025-04-10 12:15:00	3	57	8	\N	2025-04-10 12:05:54.461166+03	2025-04-10 12:17:54.787466+03	2025-04-10 12:05:48.712476+03	f	f	5	39	25
418	41	Отправка \n6л8220071 на 2уч\n0666001   в 44ц\n0250308    в 44ц\n916830     в 44ц\n916877     в 44ц\n944617  в 46/12ц	1	3	2025-03-24 14:00:00	3	30	8	\N	2025-03-24 12:54:07.7374+03	2025-03-24 14:13:29.240919+03	2025-03-24 12:52:11.977675+03	f	f	\N	\N	\N
419	Заготовки	Из заготовки 46 на лазер	4	3	2025-03-24 13:00:00	3	57	8	\N	2025-03-24 12:53:53.285267+03	2025-03-24 13:14:52.605267+03	2025-03-24 12:53:29.102151+03	f	f	\N	\N	\N
428	Изделие 2ка	2ка с 43 цех на 40 станцию	10	15	2025-03-24 12:15:00	3	33	60	\N	2025-03-24 14:06:34.074855+03	2025-03-24 14:46:19.631204+03	2025-03-24 14:06:14.155812+03	f	f	\N	\N	\N
421	41-2 цех. Детали	Из 41-2 в 06, 44	1	10	2025-03-24 14:00:00	3	39	8	\N	2025-03-24 12:59:51.050732+03	2025-03-24 14:13:45.429001+03	2025-03-24 12:55:31.580068+03	f	f	\N	\N	\N
414	Шкалы	Нет	1	1	2025-03-24 12:45:00	3	47	40	\N	2025-03-24 12:43:58.455508+03	2025-03-24 13:24:32.295791+03	2025-03-24 12:41:22.023304+03	t	f	\N	\N	\N
422	41цех	Забрать заготовки из  корпуса 10  отвезти  в 41 цех участок 2	4	50	2025-03-24 14:00:00	3	70	8	\N	2025-03-24 13:16:12.977152+03	2025-03-24 14:13:58.134796+03	2025-03-24 13:13:27.399773+03	t	f	\N	\N	\N
417	Ярлыки	На заготовку	9	1	2025-03-24 13:00:00	3	20	8	\N	2025-03-24 12:45:28.000639+03	2025-03-24 14:14:08.059394+03	2025-03-24 12:44:56.546996+03	f	f	\N	\N	\N
431	платы	платы с 31 цеха в 43 цех	4	10	2025-03-24 12:30:00	3	33	60	\N	2025-03-24 14:14:10.905687+03	2025-03-24 14:47:07.092174+03	2025-03-24 14:13:41.314825+03	f	f	\N	\N	\N
412	Трубы после травления	Травление!	1	3	2025-03-24 12:15:00	3	16	62	\N	2025-03-24 12:24:19.554097+03	2025-03-24 12:51:19.680815+03	2025-03-24 12:17:31.310428+03	t	f	\N	\N	\N
436	Колодка	Нет	1	1	2025-03-24 15:00:00	3	47	40	\N	2025-03-24 14:55:31.644863+03	2025-03-24 15:11:42.036704+03	2025-03-24 14:55:22.534317+03	t	f	\N	\N	\N
433	ПДО	Комплектующие со склада ПДО 6 отд в 43 цех	4	10	2025-03-24 12:30:00	3	33	60	\N	2025-03-24 14:17:15.833939+03	2025-03-24 14:47:29.015544+03	2025-03-24 14:16:55.949575+03	f	f	\N	\N	\N
434	Детали	С 43 в 44	1	2	2025-03-24 12:15:00	3	33	60	\N	2025-03-24 14:18:50.331293+03	2025-03-24 14:47:50.687973+03	2025-03-24 14:18:33.411586+03	f	f	\N	\N	\N
409	Бутыли воды	Забрать пустые бутылки с водой, привезти полные	5	100	2025-03-24 12:45:00	3	19	62	\N	2025-03-24 12:28:16.942908+03	2025-03-24 13:04:26.923903+03	2025-03-24 12:09:57.655988+03	f	f	\N	\N	\N
406	Производственный мусор	Цех 41 корп 50 вывоз деревянных ящиков и палет на утильбазу цеха 71	6	30	2025-03-24 11:30:00	3	18	40	\N	2025-03-24 12:23:57.844715+03	2025-03-24 13:05:23.984143+03	2025-03-24 10:51:17.648823+03	f	f	\N	\N	\N
416	Прокладка	В 52 цех	10	1	2025-03-24 13:00:00	3	20	8	\N	2025-03-24 12:44:14.065461+03	2025-03-24 13:07:19.020922+03	2025-03-24 12:43:31.27011+03	f	f	\N	\N	\N
420	Материалы	Из заготовки в цех	4	1	2025-03-24 13:00:00	3	57	8	\N	2025-03-24 12:55:26.885788+03	2025-03-24 13:08:40.109212+03	2025-03-24 12:55:15.593882+03	f	f	\N	\N	\N
415	Колпачок	В 945	10	1	2025-03-24 13:00:00	3	20	8	\N	2025-03-24 12:44:28.108355+03	2025-03-24 13:09:06.896271+03	2025-03-24 12:41:45.076515+03	f	f	\N	\N	\N
413	Гайка	В 44 цех	10	1	2025-03-24 13:00:00	3	20	8	\N	2025-03-24 12:44:43.375884+03	2025-03-24 13:14:36.64399+03	2025-03-24 12:40:55.481571+03	f	f	\N	\N	\N
425	Одежда	В прачечную	9	5	2025-03-24 13:30:00	3	54	62	\N	2025-03-24 13:32:39.645074+03	2025-03-24 13:34:08.309515+03	2025-03-24 13:32:14.517515+03	t	f	\N	\N	\N
411	Цех 45	Отвезти детали на склад ПДО	1	1	2025-03-24 13:15:00	3	67	17	\N	2025-03-24 12:17:57.716641+03	2025-03-24 13:34:52.705919+03	2025-03-24 12:17:24.262927+03	f	f	\N	\N	\N
410	Цех 45	Отвезти детали в 41 цех	1	2	2025-03-24 13:00:00	3	67	17	\N	2025-03-24 12:16:27.348792+03	2025-03-24 13:35:14.135926+03	2025-03-24 12:16:04.620985+03	f	f	\N	\N	\N
427	Готовые детали	Нет	1	5	2025-03-24 13:45:00	3	16	61	\N	2025-03-24 13:45:32.799888+03	2025-03-24 13:58:51.104583+03	2025-03-24 13:45:13.202014+03	f	f	\N	\N	\N
426	Цех 45	Отвезти п/форму на 110 втулку в цех 61	8	5	2025-03-24 13:45:00	3	11	17	\N	2025-03-24 13:36:23.970864+03	2025-03-24 14:06:51.389672+03	2025-03-24 13:36:13.341127+03	t	f	\N	\N	\N
408	Готовые детали	3 ящика и пару пакетов с деталями	1	30	2025-03-24 12:15:00	3	16	60	\N	2025-03-24 13:02:03.440653+03	2025-03-24 14:48:19.120811+03	2025-03-24 12:03:32.955418+03	f	f	\N	\N	\N
424	46	46	10	1	2025-03-24 14:00:00	3	56	8	\N	2025-03-24 13:32:11.842751+03	2025-03-24 14:12:44.662378+03	2025-03-24 13:19:54.209598+03	f	f	\N	\N	\N
423	46	46	10	5	2025-03-24 14:00:00	3	56	8	\N	2025-03-24 13:32:03.040916+03	2025-03-24 14:13:01.678383+03	2025-03-24 13:18:16.520962+03	f	f	\N	\N	\N
435	Датчики	с 43 в 43	10	20	2025-03-24 13:00:00	3	33	60	\N	2025-03-24 14:20:27.350769+03	2025-03-24 14:48:37.466344+03	2025-03-24 14:20:05.277017+03	f	f	\N	\N	\N
438	Детали	С хим.окс	1	5	2025-03-24 15:30:00	3	54	62	\N	2025-03-24 15:18:04.202985+03	2025-03-24 15:30:31.155316+03	2025-03-24 15:17:28.597138+03	t	f	\N	\N	\N
430	Системный блок	Отвезти в 39 отдел (Алена)	9	2	2025-03-24 14:00:00	3	20	62	\N	2025-03-24 14:13:16.293699+03	2025-03-24 14:20:21.562375+03	2025-03-24 14:12:48.941025+03	t	f	\N	\N	\N
439	Детали	Срочно!! Травление и знаки заводские	1	1	2025-03-24 15:30:00	4	16	\N	\N	\N	\N	2025-03-24 15:26:40.975535+03	t	f	\N	\N	\N
429	принтер	МФУ с 43 цеха в 39 отд	9	15	2025-03-24 12:15:00	3	33	60	\N	2025-03-24 14:10:45.179284+03	2025-03-24 14:45:44.6923+03	2025-03-24 14:10:27.520789+03	f	f	\N	\N	\N
432	Трубы	Нет	1	5	2025-03-24 14:45:00	3	72	40	\N	2025-03-24 14:16:40.120958+03	2025-03-24 15:02:15.333162+03	2025-03-24 14:16:19.610544+03	t	f	\N	\N	\N
440	Изделия	С 43 цеха на 59 станцию	10	1	2025-03-24 15:15:00	3	33	60	\N	2025-03-24 15:40:40.40535+03	2025-03-24 15:45:55.108448+03	2025-03-24 15:40:16.488973+03	f	f	\N	\N	\N
441	Детали	Нет	1	5	2025-03-24 15:45:00	3	16	61	\N	2025-03-24 15:41:25.624781+03	2025-03-24 15:41:42.213541+03	2025-03-24 15:41:18.8734+03	t	f	\N	\N	\N
442	Сбыт	С 43 цеха 79 отд	10	25	2025-03-24 15:15:00	3	33	60	\N	2025-03-24 15:44:44.776077+03	2025-03-24 15:46:07.471133+03	2025-03-24 15:44:20.954022+03	f	f	\N	\N	\N
437	Готовя продукция	С 43 цеха в 28 отд	10	10	2025-03-24 15:00:00	3	33	60	\N	2025-03-24 14:56:45.410836+03	2025-03-24 15:46:17.186623+03	2025-03-24 14:56:21.829945+03	f	f	\N	\N	\N
446	41	Межоперационка\n6т8236024-20   в 41/60	1	1	2025-03-25 08:00:00	3	30	8	\N	2025-03-25 07:31:51.373701+03	2025-03-25 09:33:27.92137+03	2025-03-25 07:28:40.614967+03	f	f	\N	\N	\N
449	Заготовки с термического участка	Забрать болванки с 46/12, отвезти в 10ку	1	70	2025-03-25 10:45:00	3	19	8	\N	2025-03-25 08:05:07.955707+03	2025-03-25 09:31:42.023203+03	2025-03-25 07:53:18.923282+03	f	f	\N	\N	\N
444	41/3-10 Стружка	Срочно вывести стружку с 10 корпуса в утиль базу.	6	500	2025-03-25 08:30:00	3	46	8	\N	2025-03-25 07:03:51.754769+03	2025-03-25 09:31:58.102714+03	2025-03-25 07:03:08.539146+03	t	f	\N	\N	\N
447	Заготовки	Из заготовительного 46 в цех	4	5	2025-03-25 08:00:00	3	57	8	\N	2025-03-25 07:48:38.548781+03	2025-03-25 08:03:17.763681+03	2025-03-25 07:48:32.149752+03	f	f	\N	\N	\N
445	41	Отправка \n923426   в46/12	1	1	2025-03-25 09:00:00	3	30	8	\N	2025-03-25 07:32:04.69453+03	2025-03-25 09:30:06.255397+03	2025-03-25 07:27:21.844562+03	f	f	\N	\N	\N
448	Детали с лазера	Забрать детали с лазерного участка 46ц, привезти в основной корпус	1	7	2025-03-25 08:15:00	3	19	8	\N	2025-03-25 07:49:01.167845+03	2025-03-25 08:02:41.239985+03	2025-03-25 07:48:41.884884+03	t	f	\N	\N	\N
456	46	46	10	2	2025-03-25 09:00:00	3	56	8	\N	2025-03-25 08:36:17.384931+03	2025-03-25 09:32:32.418822+03	2025-03-25 08:31:12.767039+03	f	f	\N	\N	\N
455	41 цех ящики с деталями	Забрать из 41цеха 10 корпуса, с промывки 4 ящика и отвезти в 41 цех корпус 60/2 на 3 этаж	1	20	2025-03-25 08:45:00	3	41	8	\N	2025-03-25 08:36:36.361191+03	2025-03-25 09:32:46.695331+03	2025-03-25 08:30:14.892324+03	t	f	\N	\N	\N
452	Детали	Из термички 46/12 в 41 (10 корпус, ЧПУ). \nЗаготовки после отжига\n6т8034334-01 (22 шт)	1	5	2025-03-25 08:00:00	3	9	8	AgACAgIAAxkBAAJnh2fiOHp70eLE7NPtMHaBxtoy7yPvAAK59TEb2xoRS-JjB3GeYRZPAQADAgADeQADNgQ	2025-03-25 08:05:26.411765+03	2025-03-25 09:33:12.235093+03	2025-03-25 08:00:55.305468+03	t	f	\N	\N	\N
470	Производственный мусор	Вывоз мусора из 41 цеха корп.10 на утильбазу цеха 71	6	50	2025-03-25 10:45:00	3	18	40	\N	2025-03-25 10:07:29.762362+03	2025-03-25 10:24:32.603705+03	2025-03-25 09:49:14.767579+03	f	f	\N	\N	\N
451	Забрать материал 9ХС, 2 листа	Нет	4	100	2025-03-25 09:30:00	3	63	62	\N	2025-03-25 08:18:36.014703+03	2025-03-25 08:41:05.214757+03	2025-03-25 07:55:28.199615+03	t	f	\N	\N	\N
460	Вода питьевая и вода дисцилированая	Нет	5	50	2025-03-25 09:15:00	3	34	61	\N	2025-03-25 08:47:38.257691+03	2025-03-25 09:34:39.053809+03	2025-03-25 08:47:29.948764+03	f	f	\N	\N	\N
464	Вода	7 бутылок	5	100	2025-03-25 13:30:00	3	69	40	\N	2025-03-25 09:09:17.940554+03	2025-03-25 13:46:29.468335+03	2025-03-25 09:03:24.16605+03	f	f	\N	\N	\N
473	45цех	Забрать спец.одежду из стирки	9	10	2025-03-25 09:45:00	3	22	17	\N	2025-03-25 09:51:50.942559+03	2025-03-25 09:52:27.944552+03	2025-03-25 09:51:46.951891+03	t	f	\N	\N	\N
450	Получить молоко	Нет	9	30	2025-03-25 09:00:00	3	63	40	\N	2025-03-25 08:17:50.004424+03	2025-03-25 09:08:21.918341+03	2025-03-25 07:53:56.450402+03	t	f	\N	\N	\N
458	Детали	Термичка	1	1	2025-03-25 09:00:00	3	54	40	\N	2025-03-25 08:42:46.702033+03	2025-03-25 09:08:46.778628+03	2025-03-25 08:42:18.29806+03	t	f	\N	\N	\N
497	Дсмк21-11	Нет	1	1	2025-03-25 13:30:00	3	47	40	\N	2025-03-25 12:59:42.372873+03	2025-03-25 13:53:29.229447+03	2025-03-25 12:57:50.360974+03	t	f	\N	\N	\N
476	Прокладки	Отвезти на масло а хим.лабораторию	1	1	2025-03-25 10:45:00	3	20	8	\N	2025-03-25 10:30:27.903465+03	2025-03-25 10:49:30.250862+03	2025-03-25 10:28:41.262041+03	t	f	\N	\N	\N
463	Вода	11 пустых бутылок забрать из 945(11-2) и привезти в 945ц наполненные 11 штук	5	220	2025-03-25 10:30:00	3	35	8	\N	2025-03-25 09:35:04.741179+03	2025-03-25 09:52:45.32576+03	2025-03-25 09:00:42.471259+03	t	f	\N	\N	\N
454	41	Ящик с деталями и коробка	1	25	2025-03-25 14:15:00	3	55	8	\N	2025-03-25 08:22:08.906131+03	2025-03-25 09:29:18.433863+03	2025-03-25 08:17:16.824537+03	f	f	\N	\N	\N
469	Умг3-2	Нет	10	1	2025-03-25 10:15:00	3	47	40	\N	2025-03-25 09:48:51.978044+03	2025-03-25 09:57:21.03799+03	2025-03-25 09:48:45.43028+03	t	f	\N	\N	\N
453	41-2 цех. Детали	Из 41-2 в 06, 44, 46/12	1	20	2025-03-25 09:00:00	3	39	8	\N	2025-03-25 08:19:36.92917+03	2025-03-25 09:31:30.853509+03	2025-03-25 08:13:25.444725+03	f	f	\N	\N	\N
457	46	46	10	5	2025-03-25 09:00:00	3	56	8	\N	2025-03-25 08:36:08.24691+03	2025-03-25 09:32:17.108429+03	2025-03-25 08:34:01.810333+03	f	f	\N	\N	\N
462	6т7021152-01 циферблат	Срочно!	1	1	2025-03-25 09:15:00	3	16	40	\N	2025-03-25 09:29:39.697678+03	2025-03-25 09:43:20.0458+03	2025-03-25 08:57:19.253191+03	t	f	\N	\N	\N
477	41 цех. Ящик с заготовками	Забрать ящик с заготовками с загот.уч-ка 41/10 Прижим для тисков 41ВС-4671 25шт. с документами и отвезти в 41/50 на Pinnacle бригадиру Лейбину Кириллу	1	40	2025-03-25 13:00:00	3	74	8	\N	2025-03-25 10:35:04.929784+03	2025-03-25 10:38:02.491428+03	2025-03-25 10:34:09.675165+03	f	f	\N	\N	\N
466	Цех 45	Забрать весы	9	4	2025-03-25 09:30:00	3	11	17	\N	2025-03-25 09:28:56.089555+03	2025-03-25 09:49:37.311435+03	2025-03-25 09:28:53.010702+03	t	f	\N	\N	\N
461	Стружка и мусор	Вывезти из 945ц стружку и мусор в 6 ящиках и вернуть обратно ящики!	6	86	2025-03-25 10:00:00	3	35	61	\N	2025-03-25 09:42:17.758202+03	2025-03-25 10:05:34.676967+03	2025-03-25 08:53:41.953185+03	f	f	\N	\N	\N
467	Производственный мусор	Вывоз мусора из 41 цеха корп.60/2 на утильбазу цеха 71	6	50	2025-03-25 10:15:00	3	18	40	\N	2025-03-25 09:49:30.962837+03	2025-03-25 10:34:03.364622+03	2025-03-25 09:47:15.149998+03	f	f	\N	\N	\N
474	Детали	Форма	1	1	2025-03-25 10:15:00	3	54	62	\N	2025-03-25 10:13:06.295802+03	2025-03-25 10:17:34.221868+03	2025-03-25 10:11:38.836539+03	t	f	\N	\N	\N
471	Вывоз стружки	Вывоз стружки из 41 цеха корп. 10(заготовитеоьный участок) на утильбазу цеха 71	6	40	2025-03-25 11:15:00	3	18	40	\N	2025-03-25 10:11:54.522108+03	2025-03-25 10:23:21.070397+03	2025-03-25 09:50:33.322868+03	f	f	\N	\N	\N
468	Вывоз производственного мусора	Вывоз мусора из 41 цеха корп.50 на утильбазу цеха 71	6	70	2025-03-25 10:30:00	3	18	40	\N	2025-03-25 10:07:58.317174+03	2025-03-25 10:23:39.607445+03	2025-03-25 09:48:15.29566+03	f	f	\N	\N	\N
475	Форма	На использование	8	5	2025-03-25 10:45:00	3	54	62	\N	2025-03-25 10:40:33.826284+03	2025-03-25 10:41:03.997932+03	2025-03-25 10:16:49.65482+03	t	f	\N	\N	\N
465	Круг д38 металл	Забрать со склада черных металлов и привезти в 945ц\nПеред заказом позвонить по номеру 89516819140.	4	25	2025-03-25 10:30:00	3	35	8	\N	2025-03-25 09:25:32.354815+03	2025-03-25 10:44:01.050448+03	2025-03-25 09:07:50.301018+03	t	f	\N	\N	\N
479	Отвезти детали в термичку	Нет	1	3	2025-03-25 11:15:00	3	63	62	\N	2025-03-25 11:06:10.026456+03	2025-03-25 11:06:42.462583+03	2025-03-25 11:05:48.701306+03	t	f	\N	\N	\N
481	РЕКЛАМАЦИОННЫЕ ИЗДЕЛИЯ	с 28 отд в 43 цех	10	12	2025-03-25 08:30:00	3	33	60	\N	2025-03-25 11:10:30.384743+03	2025-03-25 11:14:13.128764+03	2025-03-25 11:10:11.182884+03	f	f	\N	\N	\N
482	Мусор	Мусор на утиль базу с 43 цеха	7	80	2025-03-25 09:15:00	3	33	60	\N	2025-03-25 11:13:41.679949+03	2025-03-25 11:14:23.069033+03	2025-03-25 11:13:22.128586+03	f	f	\N	\N	\N
480	ПКИ	со склада 14 отд ПКИ в 43 цех	4	20	2025-03-25 08:30:00	3	33	60	\N	2025-03-25 11:07:41.844883+03	2025-03-25 11:14:05.01345+03	2025-03-25 11:07:23.441284+03	f	f	\N	\N	\N
484	46	46	10	5	2025-03-25 12:00:00	3	56	8	\N	2025-03-25 12:03:45.742388+03	2025-03-25 15:01:26.04397+03	2025-03-25 11:48:12.179854+03	f	f	\N	\N	\N
459	Детали	Нет	1	15	2025-03-25 08:45:00	3	16	61	\N	2025-03-25 08:43:34.389666+03	2025-03-25 13:24:08.048296+03	2025-03-25 08:43:30.06693+03	t	f	\N	\N	\N
472	6т5068090/089/092	Нет	1	1	2025-03-25 10:30:00	3	47	60	\N	2025-03-25 09:52:36.811965+03	2025-03-25 12:46:32.245209+03	2025-03-25 09:51:44.35358+03	t	f	\N	\N	\N
487	Тара	Нет	9	1	2025-03-25 12:15:00	3	47	40	\N	2025-03-25 12:11:33.118444+03	2025-03-25 14:57:48.098872+03	2025-03-25 12:03:45.985295+03	t	f	\N	\N	\N
493	Трубы	*062	1	15	2025-03-25 12:45:00	3	72	62	\N	2025-03-25 12:43:33.601982+03	2025-03-25 13:14:45.877855+03	2025-03-25 12:43:24.220872+03	t	f	\N	\N	\N
500	41-2 цех. Детали	Из 41-2 в 44, 06	1	17	2025-03-25 14:00:00	3	39	8	\N	2025-03-25 13:41:15.564172+03	2025-03-25 15:00:52.202598+03	2025-03-25 13:37:11.121411+03	f	f	\N	\N	\N
491	Заготовки	Из заготовки в цех	4	6	2025-03-25 12:30:00	3	57	8	\N	2025-03-25 12:25:10.822771+03	2025-03-25 15:01:06.893401+03	2025-03-25 12:24:39.401342+03	f	f	\N	\N	\N
478	41	Получить материал на складе , перемещение в 10 корпус 41 цех	4	300	2025-03-25 12:45:00	3	70	8	\N	2025-03-25 10:51:20.909656+03	2025-03-25 12:18:33.972526+03	2025-03-25 10:50:46.702073+03	f	f	\N	\N	\N
502	ТРУБЫ	*62	1	15	2025-03-25 13:45:00	3	72	61	\N	2025-03-25 14:13:31.463311+03	2025-03-25 16:08:39.05902+03	2025-03-25 13:49:45.598099+03	t	f	\N	\N	\N
488	Бытовые отходы	Мешки, доски	7	30	2025-03-25 13:00:00	3	31	61	\N	2025-03-25 12:13:51.438407+03	2025-03-25 12:35:44.626864+03	2025-03-25 12:13:42.696579+03	t	f	\N	\N	\N
489	Циферблат	Нет	1	1	2025-03-25 12:30:00	3	47	40	\N	2025-03-25 12:16:25.071024+03	2025-03-25 12:37:08.810555+03	2025-03-25 12:16:13.488939+03	t	f	\N	\N	\N
492	Забрать детали с термички	Нет	1	10	2025-03-25 13:00:00	3	63	62	\N	2025-03-25 12:42:26.063476+03	2025-03-25 12:44:36.782069+03	2025-03-25 12:41:53.160749+03	t	f	\N	\N	\N
1434	Лист дюрали	Материал - лист дюраль отвезти из 945 (11-2) в 46 (68)	4	10	2025-04-10 12:30:00	3	64	8	\N	2025-04-10 12:22:19.319086+03	2025-04-10 12:40:14.379111+03	2025-04-10 12:22:04.859169+03	t	f	\N	63	38
494	Отвезти детали на пескоструй	Нет	1	5	2025-03-25 12:45:00	3	63	62	\N	2025-03-25 12:50:25.166651+03	2025-03-25 13:07:19.023152+03	2025-03-25 12:50:04.527574+03	t	f	\N	\N	\N
485	Вывоз стружки	Вывоз металлической стружки из цеха 41 корп.50 на утильбазу цеха 71	6	250	2025-03-25 12:30:00	3	18	8	\N	2025-03-25 13:01:01.758358+03	2025-03-25 13:12:10.5809+03	2025-03-25 11:56:26.177288+03	f	f	\N	\N	\N
495	ПКУЗ16-1	Нет	10	1	2025-03-25 13:00:00	3	47	40	\N	2025-03-25 12:54:52.922412+03	2025-03-25 13:26:24.221292+03	2025-03-25 12:53:38.976952+03	t	f	\N	\N	\N
490	Цех 45	Отвезти детали на склад ПДО	1	1	2025-03-25 13:00:00	3	67	17	\N	2025-03-25 12:20:39.092562+03	2025-03-25 13:42:12.741104+03	2025-03-25 12:19:55.976505+03	f	f	\N	\N	\N
496	ПКУЗ16-1	Нет	10	1	2025-03-25 13:00:00	3	47	40	\N	2025-03-25 12:54:16.120209+03	2025-03-25 13:46:49.302576+03	2025-03-25 12:53:43.060236+03	t	f	\N	\N	\N
503	Бутылки с водой	Забрать пустые бутыли, привезти полные.\n Трубный участок 46ц 50 корпус	5	50	2025-03-25 14:30:00	3	19	40	\N	2025-03-25 14:01:01.390829+03	2025-03-25 14:23:36.468606+03	2025-03-25 13:56:34.160697+03	f	f	\N	\N	\N
505	41 цех	Ангар >10 корп, 60/2	9	600	2025-03-25 14:30:00	3	42	8	\N	2025-03-25 14:37:43.423906+03	2025-03-25 15:00:27.811315+03	2025-03-25 14:08:32.144952+03	f	f	\N	\N	\N
499	41/3-10 корпус. Развозка деталей	Забрать детали из БТК 10 корпуса и отвезти согласно сдаточным накладным. Детали:6т8.321.032, 6т7.830.216, 6т8.054.678-04	1	10	2025-03-25 14:00:00	3	74	8	\N	2025-03-25 13:36:01.309391+03	2025-03-25 15:00:42.831886+03	2025-03-25 13:35:46.39981+03	t	f	\N	\N	\N
486	Тара	Нет	9	1	2025-03-25 12:15:00	3	47	40	\N	2025-03-25 13:04:08.447712+03	2025-03-25 13:15:04.066887+03	2025-03-25 12:03:02.437555+03	t	f	\N	\N	\N
498	Стружка	Вывоз металлической стружки  из 41 цеха корп 60/2 на утильбазу цеха 71	6	100	2025-03-25 13:45:00	3	18	62	\N	2025-03-25 13:19:23.643885+03	2025-03-25 13:29:48.08391+03	2025-03-25 13:18:23.37531+03	f	f	\N	\N	\N
1432	Пкуз16-1	Нет	10	6	2025-04-10 12:30:00	3	47	40	\N	2025-04-10 12:17:45.669059+03	2025-04-10 12:29:53.52875+03	2025-04-10 12:17:36.072078+03	t	f	5	51	53
1437	Тест	Тест	9	34	2025-04-10 18:45:00	3	71	2	\N	2025-04-10 12:42:08.055173+03	2025-04-10 12:42:17.918258+03	2025-04-10 12:41:26.458168+03	f	f	\N	5	22
1436	Заготовки	945 цех	4	50	2025-04-10 12:30:00	3	57	8	\N	2025-04-10 12:29:57.453944+03	2025-04-10 12:36:09.178597+03	2025-04-10 12:29:45.896831+03	f	f	5	38	63
1433	41/10 стружка	Вывоз стружки	11	500	2025-04-10 12:45:00	3	74	62	\N	2025-04-10 12:38:16.18107+03	2025-04-10 13:20:26.171214+03	2025-04-10 12:21:53.274239+03	t	f	5	25	57
1441	Мусор	Нет	7	30	2025-04-10 13:00:00	3	20	58	\N	2025-04-10 12:52:30.953598+03	2025-04-10 13:33:08.151709+03	2025-04-10 12:52:24.861673+03	t	f	5	44	57
1435	Отходы растворителя	Нет	9	100	2025-04-10 12:30:00	3	16	61	\N	2025-04-10 12:24:22.188767+03	2025-04-10 13:46:18.145857+03	2025-04-10 12:24:18.408907+03	t	f	5	34	57
1439	41/10  детали	Детали из бтк 10корп.в 41/60	1	30	2025-04-10 13:00:00	3	74	8	\N	2025-04-10 13:14:10.621172+03	2025-04-10 14:45:20.088687+03	2025-04-10 12:44:43.421279+03	f	f	5	25	24
1438	41	Отправка\n2 коробки  44ц	1	1	2025-04-10 13:30:00	3	30	8	\N	2025-04-10 13:13:25.630037+03	2025-04-10 14:45:04.694201+03	2025-04-10 12:42:14.521957+03	f	f	5	26	34
536	Датчики ДСМК8А-47 (2шт)	Забрать из 28 отдела корп.50, 3 этаж и привезти в корп. 1, этаж 1, 116 кабинет.	10	5	2025-03-26 10:00:00	3	50	40	\N	2025-03-26 08:58:21.986663+03	2025-03-26 10:51:24.183655+03	2025-03-26 08:31:57.516858+03	f	f	\N	\N	\N
516	Отборки	Со склада 6 отд ПДО в 43 цех	4	10	2025-03-25 13:00:00	3	33	60	\N	2025-03-25 15:45:08.715645+03	2025-03-25 15:57:51.057879+03	2025-03-25 15:44:51.991184+03	f	f	\N	\N	\N
517	Детали	С 44 цеха в ПРБ 43 цеха	1	2	2025-03-25 13:00:00	3	33	60	\N	2025-03-25 15:47:41.801096+03	2025-03-25 15:58:03.538319+03	2025-03-25 15:47:25.214633+03	f	f	\N	\N	\N
518	Детали	С Диспетчерской 58 цеха в ПРБ 43 цеха	1	8	2025-03-25 13:00:00	3	33	60	\N	2025-03-25 15:51:09.149918+03	2025-03-25 15:58:15.355013+03	2025-03-25 15:50:53.285523+03	f	f	\N	\N	\N
506	Шкалы	Нет	1	1	2025-03-25 14:45:00	3	47	40	\N	2025-03-25 14:24:02.738875+03	2025-03-25 14:42:04.184679+03	2025-03-25 14:22:38.655209+03	t	f	\N	\N	\N
508	Хомуты после травления	Срочно!	1	5	2025-03-25 14:30:00	3	16	8	\N	2025-03-25 14:38:12.888573+03	2025-03-25 15:00:04.603726+03	2025-03-25 14:37:47.783433+03	t	f	\N	\N	\N
507	Детали	Из 46/12 в 41цех	4	4	2025-03-25 14:30:00	3	57	8	\N	2025-03-25 14:28:12.676024+03	2025-03-25 15:00:12.164888+03	2025-03-25 14:27:10.1263+03	f	f	\N	\N	\N
504	Материалы	С заготовки в цех	4	3	2025-03-25 14:15:00	3	57	8	\N	2025-03-25 14:08:30.109546+03	2025-03-25 15:00:35.789893+03	2025-03-25 14:08:16.385509+03	f	f	\N	\N	\N
501	41	Отправка \n6л8130422-01      44ц\n6т8130349       44ц\n945034    44ц\n919697   44ц\n6т8236041-10   06\n6т8236041-31  06\n6т8236041-11  06	1	5	2025-03-25 14:00:00	3	30	8	\N	2025-03-25 13:46:23.071275+03	2025-03-25 15:00:59.300739+03	2025-03-25 13:46:06.599718+03	f	f	\N	\N	\N
520	Картонные коробки	Коробки с 52 цеха в Упаковку 43 цеха	9	100	2025-03-25 14:00:00	3	33	60	\N	2025-03-25 15:54:44.339371+03	2025-03-25 15:58:26.097468+03	2025-03-25 15:54:26.89697+03	f	f	\N	\N	\N
521	Изделия	С 43 цеха на 59 станцию	10	12	2025-03-25 15:15:00	3	33	60	\N	2025-03-25 15:56:25.718376+03	2025-03-25 15:58:38.194479+03	2025-03-25 15:56:10.139524+03	f	f	\N	\N	\N
519	Детали	Нет	1	10	2025-03-25 15:45:00	3	16	61	\N	2025-03-25 15:52:21.255019+03	2025-03-25 16:08:46.14193+03	2025-03-25 15:52:14.865515+03	f	f	\N	\N	\N
541	Готовая продукция	Нет	10	15	2025-03-26 09:15:00	3	47	40	\N	2025-03-26 09:06:46.3523+03	2025-03-26 10:09:00.627904+03	2025-03-26 08:59:52.890256+03	t	f	\N	\N	\N
512	Заготовки	На лазер	4	2	2025-03-25 15:15:00	3	57	8	\N	2025-03-25 15:05:48.702723+03	2025-03-25 15:21:13.106935+03	2025-03-25 15:05:43.634537+03	t	f	\N	\N	\N
514	Заготовки	В цех	4	2	2025-03-25 15:15:00	3	57	8	\N	2025-03-25 15:07:29.372827+03	2025-03-25 15:21:21.144076+03	2025-03-25 15:07:24.182851+03	t	f	\N	\N	\N
509	Хомутик	Нет	1	5	2025-03-25 14:45:00	3	16	8	\N	2025-03-25 15:08:22.990124+03	2025-03-25 15:21:35.922709+03	2025-03-25 14:39:42.00909+03	f	f	\N	\N	\N
513	*062	Попытка 3ья	1	15	2025-03-25 15:15:00	3	72	40	\N	2025-03-25 15:06:10.340364+03	2025-03-25 15:25:59.061301+03	2025-03-25 15:05:56.001902+03	t	f	\N	\N	\N
515	Детали	Хим.окс	1	2	2025-03-25 15:30:00	3	54	62	\N	2025-03-25 15:20:33.363231+03	2025-03-25 15:28:45.069192+03	2025-03-25 15:20:15.772414+03	t	f	\N	\N	\N
511	Отборки	Нет	1	1	2025-03-25 15:15:00	3	47	40	\N	2025-03-25 14:41:42.953085+03	2025-03-25 15:34:39.274623+03	2025-03-25 14:41:08.387656+03	t	f	\N	\N	\N
510	Отборки	Нет	1	1	2025-03-25 15:15:00	3	47	40	\N	2025-03-25 14:40:48.299638+03	2025-03-25 15:34:48.276243+03	2025-03-25 14:40:17.328435+03	t	f	\N	\N	\N
522	Заготовки	Из заготовительного в цех 46	4	3	2025-03-26 08:00:00	3	57	8	\N	2025-03-26 07:38:54.849578+03	2025-03-26 09:29:33.451463+03	2025-03-26 07:37:13.231188+03	f	f	\N	\N	\N
535	41-2 цех. Детали	Из 41-2 в 44, 06	1	20	2025-03-26 09:00:00	3	39	8	\N	2025-03-26 08:33:50.153248+03	2025-03-26 09:27:47.747929+03	2025-03-26 08:30:44.957608+03	f	f	\N	\N	\N
524	46	46	10	5	2025-03-26 09:00:00	3	56	8	\N	2025-03-26 07:53:23.609601+03	2025-03-26 09:28:06.702837+03	2025-03-26 07:52:50.855587+03	f	f	\N	\N	\N
545	Халаты, спец одежда	С прачечной в 43 цех	9	12	2025-03-26 08:30:00	3	33	60	\N	2025-03-26 09:28:44.080637+03	2025-03-26 09:28:59.440654+03	2025-03-26 09:28:22.099142+03	f	f	\N	\N	\N
530	Детали с лазера	Забрать с лазерного участка 46ц детали, привезти в основной корпус	1	10	2025-03-26 08:45:00	3	19	8	\N	2025-03-26 08:23:55.18335+03	2025-03-26 09:29:06.658757+03	2025-03-26 08:23:25.597439+03	t	f	\N	\N	\N
528	41-4 цех. Вода	Из 41 в 41	5	130	2025-03-26 09:30:00	3	39	8	\N	2025-03-26 09:30:08.186868+03	2025-03-26 10:52:41.238616+03	2025-03-26 08:21:56.308919+03	f	f	\N	\N	\N
525	46	46	10	2	2025-03-26 09:00:00	3	56	8	\N	2025-03-26 07:55:44.739862+03	2025-03-26 09:27:56.080839+03	2025-03-26 07:55:21.016907+03	f	f	\N	\N	\N
531	Детали	Термичка	1	3	2025-03-26 08:30:00	3	54	62	\N	2025-03-26 08:24:39.796761+03	2025-03-26 09:06:16.991314+03	2025-03-26 08:23:35.268638+03	t	f	\N	\N	\N
537	Цех 45	Отвезти детали в 41 цех	1	2	2025-03-26 08:45:00	3	67	17	\N	2025-03-26 08:34:24.080697+03	2025-03-26 08:55:06.20857+03	2025-03-26 08:33:04.619031+03	f	f	\N	\N	\N
544	41-2. Вода Срочно!!	41 в 41	5	130	2025-03-26 09:30:00	3	39	8	\N	2025-03-26 09:29:58.155675+03	2025-03-26 10:52:31.131205+03	2025-03-26 09:10:58.651041+03	t	f	\N	\N	\N
540	Отвезти спецодежду в прачечную	Нет	9	2	2025-03-26 09:15:00	3	63	62	\N	2025-03-26 08:44:48.369863+03	2025-03-26 09:04:38.208275+03	2025-03-26 08:44:13.487064+03	t	f	\N	\N	\N
534	Детали	Покраска	1	0.5	2025-03-26 08:45:00	3	54	62	\N	2025-03-26 08:30:44.39213+03	2025-03-26 09:05:30.666592+03	2025-03-26 08:30:02.72429+03	t	f	\N	\N	\N
542	Пгк1	Нет	10	1	2025-03-26 10:00:00	3	47	40	\N	2025-03-26 09:06:39.657719+03	2025-03-26 10:51:13.029444+03	2025-03-26 09:05:13.49706+03	t	f	\N	\N	\N
533	41-2 цех. Тара	Из 41-2 в 43	9	5	2025-03-26 09:30:00	3	39	8	\N	2025-03-26 09:05:53.280373+03	2025-03-26 09:18:11.321709+03	2025-03-26 08:25:22.814063+03	f	f	\N	\N	\N
543	Комплектующие	Со склада ПКИ 14 отд в 43 цех	4	30	2025-03-26 08:30:00	3	33	60	\N	2025-03-26 09:11:15.018035+03	2025-03-26 09:11:46.642703+03	2025-03-26 09:10:54.21885+03	f	f	\N	\N	\N
538	41 цех. Стружка	С 10корп на утильбазу	7	25	2025-03-26 10:00:00	3	39	40	\N	2025-03-26 15:34:32.009056+03	2025-03-26 15:34:44.354644+03	2025-03-26 08:41:42.468787+03	f	f	\N	\N	\N
529	41	Вода	5	38	2025-03-26 09:30:00	3	55	8	\N	2025-03-26 09:30:16.553256+03	2025-03-26 10:52:50.574631+03	2025-03-26 08:22:02.113484+03	f	f	\N	\N	\N
527	41	Отправка\n945032    44ц\n6с8935036    44ц  \n6с8935036   44ц  две партии \n6т8411242   в 44ц	1	3	2025-03-26 09:00:00	3	30	8	\N	2025-03-26 08:19:28.147053+03	2025-03-26 09:29:00.084148+03	2025-03-26 08:15:21.619358+03	f	f	\N	\N	\N
526	46 60-4-2	46	10	1	2025-03-26 09:00:00	3	56	8	\N	2025-03-26 07:58:48.907345+03	2025-03-26 09:28:53.586802+03	2025-03-26 07:58:35.234359+03	f	f	\N	\N	\N
539	41 цех. Мусор	С 6/8 на утильбазу	7	25	2025-03-26 10:00:00	3	39	40	\N	2025-03-26 13:48:11.508604+03	2025-03-26 14:08:24.60658+03	2025-03-26 08:42:36.762996+03	f	f	\N	\N	\N
523	41 цех	Вода >50 корп + лит уч-к	9	110	2025-03-26 09:00:00	3	42	62	\N	2025-03-26 09:29:48.213451+03	2025-03-26 09:50:31.431668+03	2025-03-26 07:39:49.097108+03	f	f	\N	\N	\N
1442	Наконечник	Нет	10	1	2025-04-10 13:45:00	3	20	58	\N	2025-04-10 12:54:24.564494+03	2025-04-10 15:10:33.875767+03	2025-04-10 12:53:33.556076+03	f	f	5	44	35
1443	Детали	Для 945	4	3	2025-04-10 12:45:00	3	57	58	\N	2025-04-10 13:23:16.199227+03	2025-04-10 14:00:20.327233+03	2025-04-10 12:58:12.68037+03	f	f	5	39	63
532	41/3-10 корпус. Развозка деталей	Забрать детали из БТК 10корпуса и отвезти согласно сдаточным накладным	1	15	2025-03-26 08:30:00	3	74	8	\N	2025-03-26 08:29:03.265491+03	2025-03-26 09:29:26.60144+03	2025-03-26 08:24:53.969172+03	f	f	\N	\N	\N
547	Бытовые отходы	Нет	7	50	2025-03-26 10:15:00	3	31	61	\N	2025-03-26 10:07:01.842326+03	2025-03-26 11:51:01.136415+03	2025-03-26 10:06:52.366003+03	t	f	\N	\N	\N
564	Трубы сварка	Нет	1	8	2025-03-26 12:30:00	3	72	8	\N	2025-03-26 13:20:16.232312+03	2025-03-26 13:31:31.222864+03	2025-03-26 12:13:23.146237+03	t	f	\N	\N	\N
548	Комплект фильтров кама-500	Забрать со склада (ангар) 75 отдела 3 коробки фильтров для лазерного станка и привезти в 58 цех (1 корп) в кабинет 105.	9	10	2025-03-26 13:00:00	3	50	40	\N	2025-03-26 12:18:01.595121+03	2025-03-26 13:11:52.927479+03	2025-03-26 10:07:58.863413+03	f	f	\N	\N	\N
551	Катушки,реостаты	Нет	1	1	2025-03-26 10:30:00	3	47	62	\N	2025-03-26 10:22:52.358902+03	2025-03-26 10:46:44.724324+03	2025-03-26 10:10:08.423235+03	t	f	\N	\N	\N
546	Фланец 6т8230320	На лужение	1	20	2025-03-26 09:30:00	3	16	40	\N	2025-03-26 09:30:49.262992+03	2025-03-26 10:50:16.176937+03	2025-03-26 09:30:36.999018+03	t	f	\N	\N	\N
553	Тара для фланцев	Забрать со второго этажа 46ц тару, отвезти в кладовую 41ц	9	10	2025-03-26 10:45:00	3	19	62	AgACAgIAAxkBAAJ-2mfjqV922GDAyrqjkMp38JLJl2uAAAJi6DEbQdQgS-u7g4UWSZ5QAQADAgADeQADNgQ	2025-03-26 10:50:03.029047+03	2025-03-26 11:14:07.626218+03	2025-03-26 10:15:35.345226+03	t	f	\N	\N	\N
554	Тара для фланцев	Забрать со второго этажа 46ц тару, отвезти в кладовую 41ц	9	10	2025-03-26 10:45:00	3	19	8	AgACAgIAAxkBAAJ-2mfjqV922GDAyrqjkMp38JLJl2uAAAJi6DEbQdQgS-u7g4UWSZ5QAQADAgADeQADNgQ	2025-03-26 11:15:46.564939+03	2025-03-26 11:20:21.582209+03	2025-03-26 10:15:35.526945+03	t	f	\N	\N	\N
561	Заготовки от ТП ИС	Круг Д16, круг Л63, нужны грузчики	4	500	2025-03-26 12:00:00	3	9	8	\N	2025-03-26 11:49:25.27211+03	2025-03-26 13:11:53.119843+03	2025-03-26 11:49:17.867799+03	t	f	\N	\N	\N
555	41	Ангар 75 отд>41 лит уч\n1.фильтры 16шт\n2.автотрансформатор 1шт	9	5	2025-03-26 12:30:00	3	42	40	\N	2025-03-26 13:02:16.125527+03	2025-03-26 13:18:02.545615+03	2025-03-26 10:20:33.951901+03	f	f	\N	\N	\N
1445	Детали	Для 41	4	3	2025-04-10 13:15:00	3	57	58	\N	2025-04-10 13:04:18.863623+03	2025-04-10 14:00:11.057493+03	2025-04-10 13:01:18.483043+03	f	f	5	39	24
563	Заготовки	Из цеха 46 на лазер	4	1	2025-03-26 12:15:00	3	57	8	\N	2025-03-26 12:07:18.446912+03	2025-03-26 13:31:45.374723+03	2025-03-26 12:03:38.870695+03	f	f	\N	\N	\N
570	6т8034172 , корпуса, 18 штук	Корпуса из ОТК, 10 корпус в корпус 60-2, 41 цех	1	180	2025-03-26 13:15:00	3	9	8	\N	2025-03-26 13:33:24.991813+03	2025-03-26 14:51:01.601551+03	2025-03-26 12:42:58.373145+03	t	f	\N	\N	\N
572	Отвезти плиту на скоростную фрезеровку	Нет	1	100	2025-03-26 13:00:00	3	63	62	\N	2025-03-26 12:45:04.734695+03	2025-03-26 13:21:59.17433+03	2025-03-26 12:44:34.815274+03	t	f	\N	\N	\N
584	41-2 цех. Стружка СРОЧНО!!!	Из 10 корп на утиль базу	6	550	2025-03-26 14:30:00	3	39	40	\N	2025-03-26 14:26:33.510546+03	2025-03-26 15:16:20.898691+03	2025-03-26 14:18:44.149129+03	t	f	\N	\N	\N
567	Забрать с 46/12, отвезти в основной цех 60/4	Забрать с 46/12, отвезти в основной цех 60/4	1	0.5	2025-03-26 12:30:00	3	19	8	\N	2025-03-26 12:39:20.761319+03	2025-03-26 13:31:20.092654+03	2025-03-26 12:25:26.998509+03	t	f	\N	\N	\N
550	Катушки,реостаты	Нет	1	1	2025-03-26 10:30:00	3	47	61	\N	2025-03-26 12:03:23.318761+03	2025-03-26 12:41:49.172149+03	2025-03-26 10:10:08.420843+03	t	f	\N	\N	\N
558	Материал	Из цеха 945(11-2) забрать материал и отвезти в 46 цех(60-4-2)	4	15	2025-03-26 14:30:00	3	64	8	\N	2025-03-26 11:29:35.329248+03	2025-03-26 13:03:19.803756+03	2025-03-26 10:59:10.646673+03	f	f	\N	\N	\N
571	Забрать детали с гальваники	Нет	1	2	2025-03-26 12:45:00	3	63	62	\N	2025-03-26 12:44:07.137023+03	2025-03-26 13:22:43.600957+03	2025-03-26 12:43:34.220674+03	t	f	\N	\N	\N
573	Готовые детали	Нет	1	5	2025-03-26 12:45:00	3	16	62	\N	2025-03-26 12:45:12.278361+03	2025-03-26 13:24:34.898357+03	2025-03-26 12:45:01.501102+03	t	f	\N	\N	\N
578	Вода	Привезти воду на термический участок 46/12	5	20	2025-03-26 14:00:00	3	57	62	\N	2025-03-26 13:51:15.790393+03	2025-03-26 14:12:30.508457+03	2025-03-26 13:30:11.846853+03	f	f	\N	\N	\N
565	1762011 кольцо с колонкой	Срочно! После травления	1	5	2025-03-26 12:15:00	3	16	61	\N	2025-03-26 12:42:55.029864+03	2025-03-26 12:58:42.178051+03	2025-03-26 12:18:32.049428+03	t	f	\N	\N	\N
569	Забрать делали с термички	Нет	1	3	2025-03-26 13:00:00	3	63	62	\N	2025-03-26 12:43:04.484067+03	2025-03-26 13:22:23.441276+03	2025-03-26 12:42:35.344958+03	t	f	\N	\N	\N
557	Плита(д16)	Из 945 (11-2) забрать материал и отвезти в 41 цех(10-2)	4	100	2025-03-26 13:00:00	3	64	8	\N	2025-03-26 11:29:06.034721+03	2025-03-26 13:03:38.384232+03	2025-03-26 10:53:32.222126+03	f	f	\N	\N	\N
559	Детали	Готовые детали + срочный циферблат 152-01	1	5	2025-03-26 11:45:00	3	16	60	\N	2025-03-26 12:00:04.363722+03	2025-03-26 13:08:29.244715+03	2025-03-26 11:03:54.007278+03	t	f	\N	\N	\N
562	Заготовки	Из заготовки в цех 46	4	5	2025-03-26 12:15:00	3	57	8	\N	2025-03-26 12:07:42.600348+03	2025-03-26 13:08:57.470354+03	2025-03-26 12:01:42.192521+03	f	f	\N	\N	\N
575	Цех 45	Отвезти детали в 58 цех	1	1	2025-03-26 14:00:00	3	67	17	\N	2025-03-26 13:26:24.539531+03	2025-03-26 14:01:58.063062+03	2025-03-26 13:25:24.358733+03	f	f	\N	\N	\N
552	Катушки,реостаты	Нет	1	1	2025-03-26 10:30:00	3	47	40	\N	2025-03-26 13:29:21.27243+03	2025-03-26 13:29:29.366429+03	2025-03-26 10:10:08.886807+03	t	f	\N	\N	\N
566	Детали	Из термического участка 46/12 в цех 46	4	3	2025-03-26 13:00:00	3	57	8	\N	2025-03-26 12:20:04.871251+03	2025-03-26 13:31:07.865221+03	2025-03-26 12:18:38.336865+03	f	f	\N	\N	\N
585	Вода	Нет	5	200	2025-03-27 09:30:00	3	14	40	\N	2025-03-27 10:11:30.946197+03	2025-03-27 10:26:16.884696+03	2025-03-26 14:19:33.638711+03	f	t	\N	\N	\N
556	41	55 корп центр склад>41 лит уч \n1.нагреватели 24шт	9	15	2025-03-26 13:30:00	1	42	\N	\N	\N	\N	2025-03-26 10:22:56.405482+03	f	f	\N	\N	\N
568	41	Ящик с деталями	1	20	2025-03-26 13:00:00	1	55	\N	\N	\N	\N	2025-03-26 12:29:28.066505+03	f	f	\N	\N	\N
576	Цех 45	Отвезти детали на склад ПДО	1	1	2025-03-26 14:15:00	3	67	17	\N	2025-03-26 13:28:39.083677+03	2025-03-26 14:01:38.568046+03	2025-03-26 13:27:17.720937+03	f	f	\N	\N	\N
577	41-2 цех. Детали	Из 41-2 в 46/12,44,06, 10корп	1	30	2025-03-26 14:00:00	3	39	8	\N	2025-03-26 13:32:58.374918+03	2025-03-26 14:50:50.272842+03	2025-03-26 13:28:31.871085+03	f	f	\N	\N	\N
582	Детали	С 43 цеха в 41 цех	1	8	2025-03-26 12:15:00	3	33	60	\N	2025-03-26 14:13:07.065165+03	2025-03-26 14:36:50.192587+03	2025-03-26 14:12:53.229578+03	f	f	\N	\N	\N
583	Стаканчики	С 45 цеха в 43 цех	9	40	2025-03-26 12:30:00	3	33	60	\N	2025-03-26 14:16:04.470155+03	2025-03-26 14:36:38.797006+03	2025-03-26 14:15:43.552857+03	f	f	\N	\N	\N
560	Забрать с лазерного участка 46ц детали, привезти в основной корпус	Забрать с лазерного участка 46ц детали, привезти в основной корпус	1	3	2025-03-26 12:00:00	3	19	8	\N	2025-03-26 12:19:38.069768+03	2025-03-26 13:31:55.353957+03	2025-03-26 11:49:09.691751+03	t	f	\N	\N	\N
587	41-2 цех. Фланец СРОЧНО	Из 41-2 в 10 корп	1	15	2025-03-26 14:45:00	1	39	\N	\N	\N	\N	2025-03-26 14:26:37.911777+03	t	f	\N	\N	\N
581	Сбыт	С 43 цеха на склад 79 отд	10	25	2025-03-26 12:00:00	3	33	60	\N	2025-03-26 14:10:53.042229+03	2025-03-26 14:37:00.448657+03	2025-03-26 14:10:38.8229+03	f	f	\N	\N	\N
588	Детали	С 43 цеха в 44 цех	1	1	2025-03-26 12:15:00	3	33	60	\N	2025-03-26 14:27:16.529683+03	2025-03-26 14:37:17.636816+03	2025-03-26 14:26:56.100584+03	f	f	\N	\N	\N
590	Мебель	С 43 цеха в 51 цех	9	100	2025-03-26 13:15:00	3	33	60	\N	2025-03-26 14:33:04.742081+03	2025-03-26 14:37:42.656916+03	2025-03-26 14:32:44.377026+03	f	f	\N	\N	\N
579	Готовые детали	Нет	1	5	2025-03-26 13:45:00	3	16	61	\N	2025-03-26 13:47:37.940078+03	2025-03-26 14:51:44.279083+03	2025-03-26 13:47:35.981135+03	t	f	\N	\N	\N
580	Трубы	Нет	1	15	2025-03-26 15:00:00	3	47	40	\N	2025-03-26 13:58:54.874737+03	2025-03-26 15:50:57.92333+03	2025-03-26 13:57:58.644467+03	t	f	\N	\N	\N
1458	46	46	10	2	2025-04-10 14:00:00	3	56	58	\N	2025-04-10 13:49:23.425538+03	2025-04-10 15:10:58.357129+03	2025-04-10 13:47:37.713457+03	f	f	\N	43	63
1450	Заготовки	В 945	4	15	2025-04-10 14:00:00	3	57	58	\N	2025-04-10 13:25:22.929971+03	2025-04-10 15:06:25.799616+03	2025-04-10 13:24:59.336405+03	f	f	5	38	63
1444	Шайба	Нет	10	1	2025-04-10 13:45:00	3	20	58	\N	2025-04-10 13:05:12.132496+03	2025-04-10 14:27:20.171386+03	2025-04-10 12:58:27.049309+03	f	f	5	44	25
1464	Готовые детали	Нет	1	20	2025-04-10 14:45:00	3	16	40	\N	2025-04-10 14:39:10.913502+03	2025-04-10 15:07:37.214201+03	2025-04-10 14:39:03.346188+03	t	f	5	34	51
1452	Забрать детали с термички	Нет	1	10	2025-04-10 13:45:00	3	63	62	\N	2025-04-10 13:27:24.423755+03	2025-04-10 14:39:47.000767+03	2025-04-10 13:26:51.159207+03	t	f	\N	39	55
1455	Вывезти стружку на утильбазу	Нет	6	50	2025-04-10 14:15:00	3	63	62	\N	2025-04-10 13:30:13.463824+03	2025-04-10 14:40:09.388869+03	2025-04-10 13:29:23.46931+03	t	f	\N	55	55
1465	Детали	Нет	1	2	2025-04-10 12:45:00	3	33	60	\N	2025-04-10 14:39:38.237865+03	2025-04-10 14:45:02.455338+03	2025-04-10 14:39:32.367602+03	f	f	\N	31	35
1468	Отборки	Со склада 6 отд ПДО в 43 цех	1	1	2025-04-10 13:30:00	3	33	60	\N	2025-04-10 14:44:14.509234+03	2025-04-10 14:45:21.404371+03	2025-04-10 14:44:06.95838+03	f	f	\N	2	31
1448	Тара	Нет	9	10	2025-04-10 13:30:00	3	47	40	\N	2025-04-10 13:12:09.228272+03	2025-04-10 14:48:59.250576+03	2025-04-10 13:12:01.072171+03	t	f	5	52	51
1471	Изделия	Система на 59 станцию	10	20	2025-04-10 15:15:00	3	33	60	\N	2025-04-10 15:42:12.219712+03	2025-04-10 15:42:27.754216+03	2025-04-10 15:42:04.299324+03	f	f	\N	31	53
1466	Готовые детали	Нет	1	5	2025-04-10 14:45:00	3	16	62	\N	2025-04-10 14:40:48.481661+03	2025-04-10 14:56:50.015003+03	2025-04-10 14:40:18.902807+03	t	f	5	34	24
1447	709 Корпуса	Нет	1	50	2025-04-10 13:15:00	3	16	40	AgACAgIAAxkBAAEBKvxn95ecyQ-2aIYirUxN5veclO-8UAACIu0xGycawUuUury8kSdS7gEAAwIAA3kAAzYE	2025-04-10 13:48:17.859649+03	2025-04-10 14:49:17.617917+03	2025-04-10 13:04:21.558092+03	t	f	5	34	53
1446	Детали	После травления!!	1	5	2025-04-10 13:00:00	3	16	8	\N	2025-04-10 13:40:49.340932+03	2025-04-10 14:45:32.717288+03	2025-04-10 13:03:10.598575+03	t	f	5	34	24
1469	Шкалы	Поматили	1	1	2025-04-10 15:15:00	3	16	40	\N	2025-04-10 15:07:07.042638+03	2025-04-10 15:40:08.65752+03	2025-04-10 15:06:52.925828+03	t	f	5	34	51
1470	Готовые детали	Нет	1	20	2025-04-10 15:30:00	3	16	61	\N	2025-04-10 15:35:21.823963+03	2025-04-10 15:59:33.20587+03	2025-04-10 15:35:16.482363+03	t	f	5	34	2
1440	41	Отправка \n4ящика \n1 коробка	1	10	2025-04-10 13:30:00	3	30	8	\N	2025-04-10 13:13:43.879591+03	2025-04-10 14:44:50.212085+03	2025-04-10 12:46:47.251417+03	f	f	5	26	35
589	Отборки	Со склада 6 отд ПДО в 43 цех	4	30	2025-03-26 12:45:00	3	33	60	\N	2025-03-26 14:30:31.04851+03	2025-03-26 14:37:33.474405+03	2025-03-26 14:30:12.689292+03	f	f	\N	\N	\N
574	41 цех	8уч .Прутки, нужно отвезти из 41 цеха 10 корп (револьверный участок)  в корпус 6-7 на шлифовку 8уч	1	1	2025-03-26 13:45:00	4	53	\N	\N	\N	\N	2025-03-26 13:21:26.186026+03	t	f	\N	\N	\N
1454	Мусор	На свалку	7	15	2025-04-10 14:00:00	3	57	58	\N	2025-04-10 13:29:19.546513+03	2025-04-10 13:59:14.242413+03	2025-04-10 13:28:43.493765+03	f	f	5	40	57
1453	Отвезти детали на скоростную фрезеровку	Нет	1	15	2025-04-10 14:00:00	3	63	62	\N	2025-04-10 13:28:40.06344+03	2025-04-10 14:39:58.696201+03	2025-04-10 13:28:05.04393+03	t	f	\N	55	55
1461	Форма	Спецостнастка	8	5	2025-04-10 14:30:00	3	54	62	\N	2025-04-10 14:16:35.947426+03	2025-04-10 14:40:19.666368+03	2025-04-10 14:16:27.765166+03	t	f	\N	54	37
1460	41-2 цех. Детали	Развозка деталей	1	20	2025-04-10 14:30:00	3	39	8	\N	2025-04-10 14:22:49.698212+03	2025-04-10 14:43:56.762568+03	2025-04-10 14:13:06.298207+03	f	f	\N	24	34
1463	Мусор	Баки с отходами	7	100	2025-04-10 12:30:00	3	33	60	\N	2025-04-10 14:37:49.496656+03	2025-04-10 14:44:51.174408+03	2025-04-10 14:37:42.544981+03	f	f	\N	31	57
1467	Детали	Ящики с корпусами	1	40	2025-04-10 13:30:00	3	33	60	\N	2025-04-10 14:42:28.196341+03	2025-04-10 14:45:11.895732+03	2025-04-10 14:42:22.087299+03	f	f	\N	34	31
1459	41/10 детали	Забрать детали с у.промывки 41/10 и отвезти в 41/60 2уч.	1	1	2025-04-10 14:15:00	3	74	8	\N	2025-04-10 14:06:52.886658+03	2025-04-10 14:44:17.966258+03	2025-04-10 13:58:07.361182+03	f	f	5	26	24
1456	Цех 45	Отвезти детали на склад ПДО	1	2	2025-04-10 14:00:00	3	67	17	\N	2025-04-10 13:31:20.354464+03	2025-04-10 14:17:08.109634+03	2025-04-10 13:31:04.833372+03	f	f	5	37	2
1457	46	46	10	1	2025-04-10 14:00:00	3	56	58	\N	2025-04-10 13:49:31.365713+03	2025-04-10 15:11:09.042269+03	2025-04-10 13:46:38.034931+03	f	f	\N	43	35
1462	Заготовки	На лазер	4	5	2025-04-10 14:30:00	3	57	58	\N	2025-04-10 14:30:36.738471+03	2025-04-10 15:10:52.666824+03	2025-04-10 14:27:09.91467+03	f	f	5	38	67
1451	В цех 46	Материалы	4	7	2025-04-10 14:00:00	3	57	58	\N	2025-04-10 13:28:03.403013+03	2025-04-10 15:11:03.728765+03	2025-04-10 13:26:28.254746+03	f	f	5	38	43
1449	Забрать 2 трубы с трубного участка	Забрать 2 трубы с трубного участка	1	2	2025-04-10 13:30:00	3	19	8	\N	2025-04-10 13:19:41.151814+03	2025-04-10 14:44:32.215942+03	2025-04-10 13:17:20.160734+03	t	f	5	41	26
549	Детали	Приспособление	1	2	2025-03-26 10:30:00	3	54	62	\N	2025-03-26 14:19:30.603274+03	2025-03-26 14:34:32.006214+03	2025-03-26 10:08:33.644568+03	t	f	\N	\N	\N
591	Мебель	С 43 цеха в 51 цех	9	150	2025-03-26 13:45:00	3	33	60	\N	2025-03-26 14:34:55.446542+03	2025-03-26 14:38:06.436302+03	2025-03-26 14:34:38.717974+03	f	f	\N	\N	\N
593	Вода	Нет	5	260	2025-03-26 14:45:00	3	16	61	\N	2025-03-26 14:50:50.072828+03	2025-03-26 14:51:21.268224+03	2025-03-26 14:50:47.163477+03	t	f	\N	\N	\N
592	Детали	Термичка	1	0.5	2025-03-26 15:00:00	3	54	62	\N	2025-03-26 14:42:22.66164+03	2025-03-26 15:00:28.600845+03	2025-03-26 14:41:37.899656+03	t	f	\N	\N	\N
613	10 коробок	Нет	9	1	2025-03-27 09:00:00	3	47	40	\N	2025-03-27 08:27:37.228934+03	2025-03-27 09:32:07.243124+03	2025-03-27 08:21:30.873313+03	t	f	\N	\N	\N
586	41/3-10корпус. Отправка деталей с промывки	Отвезти детали с промывки с 41 корп 10 в 41ц корп.60/2	1	10	2025-03-26 14:30:00	3	74	62	\N	2025-03-26 15:35:33.472885+03	2025-03-26 15:38:10.099261+03	2025-03-26 14:22:16.189383+03	f	f	\N	\N	\N
594	Детали	Хим.окс	1	3	2025-03-26 15:15:00	3	54	62	\N	2025-03-26 15:02:51.818515+03	2025-03-26 15:38:34.356437+03	2025-03-26 15:01:39.392873+03	t	f	\N	\N	\N
622	Эмаль, лак	Емкость металлическая	10	200	2025-03-27 10:00:00	3	34	61	\N	2025-03-27 08:59:05.9258+03	2025-03-27 10:22:41.018218+03	2025-03-27 08:54:45.242276+03	t	f	\N	\N	\N
595	41	Прачечная, чистая стирка>10корп+60/2	9	5	2025-03-27 09:30:00	3	42	8	\N	2025-03-27 07:57:28.388794+03	2025-03-27 08:15:57.993448+03	2025-03-26 15:08:49.264206+03	f	f	\N	\N	\N
598	Сбыт	С 43 цеха в 79 отд	10	20	2025-03-26 15:15:00	3	33	60	\N	2025-03-26 15:40:40.638181+03	2025-03-26 15:47:47.824529+03	2025-03-26 15:40:17.258833+03	f	f	\N	\N	\N
599	Изделия	С 43 цеха на 59 станцию	10	8	2025-03-26 15:15:00	3	33	60	\N	2025-03-26 15:47:03.084843+03	2025-03-26 15:47:56.811842+03	2025-03-26 15:46:39.527305+03	f	f	\N	\N	\N
604	Пластина	1 этаж(Алена)	10	1	2025-03-27 08:15:00	3	20	8	\N	2025-03-27 07:57:43.42523+03	2025-03-27 08:16:33.229815+03	2025-03-27 07:54:54.824915+03	f	f	\N	\N	\N
600	Детали	Нет	1	10	2025-03-26 15:30:00	3	16	61	\N	2025-03-26 15:56:15.324686+03	2025-03-26 15:56:22.941562+03	2025-03-26 15:56:13.210853+03	t	f	\N	\N	\N
612	41	Детали	1	25	2025-03-27 10:15:00	3	55	8	\N	2025-03-27 08:31:08.396432+03	2025-03-27 09:31:30.490015+03	2025-03-27 08:20:23.83352+03	f	f	\N	\N	\N
620	Готовые детали	Нет	1	5	2025-03-27 08:45:00	3	16	8	\N	2025-03-27 08:55:19.961299+03	2025-03-27 09:32:46.252678+03	2025-03-27 08:44:43.992868+03	f	f	\N	\N	\N
618	41-2 цех. Мусор	Из 41-2 на 71 утильбазу	7	150	2025-03-27 09:15:00	3	39	62	\N	2025-03-27 09:27:52.443828+03	2025-03-27 09:34:17.470194+03	2025-03-27 08:36:06.48297+03	f	f	\N	\N	\N
623	Шкалы матить	Нет	1	1	2025-03-27 09:30:00	3	47	40	\N	2025-03-27 08:56:44.871938+03	2025-03-27 09:21:05.142577+03	2025-03-27 08:55:34.698051+03	t	f	\N	\N	\N
603	Прокладка	46 цех 1 этаж(Алена)	10	1	2025-03-27 08:15:00	3	20	8	\N	2025-03-27 07:57:56.959111+03	2025-03-27 08:16:56.070348+03	2025-03-27 07:54:13.606666+03	f	f	\N	\N	\N
606	Заготовки	Заготовки в цех 46	4	10	2025-03-27 08:15:00	3	57	8	\N	2025-03-27 08:04:06.093197+03	2025-03-27 08:17:19.061387+03	2025-03-27 08:03:49.110409+03	f	f	\N	\N	\N
596	41-2 цех. Трубы 6т8626374	Из 41-2 на песок 6/7	1	3	2025-03-27 09:00:00	3	39	8	\N	2025-03-27 07:57:15.069843+03	2025-03-27 09:32:32.633882+03	2025-03-26 15:20:48.908303+03	f	f	\N	\N	\N
601	41/10. Отправка деталей с промывки	Отвезти детали с уч-ка промывки с 41/10 в 41/60/2 на 3й этаж 2уч. в БТК.	1	15	2025-03-27 08:00:00	3	74	8	\N	2025-03-27 07:58:10.384849+03	2025-03-27 09:33:10.57649+03	2025-03-26 16:17:12.159925+03	f	f	\N	\N	\N
621	Бытовой мусор	Нет	7	100	2025-03-27 09:15:00	3	31	61	\N	2025-03-27 08:51:11.232521+03	2025-03-27 09:41:36.224589+03	2025-03-27 08:51:06.737082+03	t	f	\N	\N	\N
608	41-2 цех. Детали	Из 41-2 на 6/7песок, 6/7литейка, 46/12	1	33	2025-03-27 09:00:00	3	39	8	\N	2025-03-27 08:18:44.2015+03	2025-03-27 09:32:19.18829+03	2025-03-27 08:09:50.242147+03	f	f	\N	\N	\N
624	Получение материала (плита д16 #40) 1 шт	Плита д16 #40 (1шт)	4	110	2025-03-27 10:00:00	3	64	8	\N	2025-03-27 08:57:34.863205+03	2025-03-27 10:30:58.157841+03	2025-03-27 08:56:22.64372+03	t	f	\N	\N	\N
605	46	46	10	5	2025-03-27 09:00:00	3	56	8	\N	2025-03-27 08:03:49.017445+03	2025-03-27 08:30:22.709+03	2025-03-27 08:03:21.512329+03	f	f	\N	\N	\N
619	41-2 цех. Отходы в литейку	41ц, 2 уч металлические отходы в 6/7 литейный	6	50	2025-03-27 09:15:00	3	39	8	\N	2025-03-27 08:55:42.101159+03	2025-03-27 09:32:06.469765+03	2025-03-27 08:37:47.647193+03	f	f	\N	\N	\N
615	Детали	Термичка	1	1	2025-03-27 08:45:00	3	54	62	\N	2025-03-27 08:30:18.085627+03	2025-03-27 10:23:34.966343+03	2025-03-27 08:29:06.745749+03	t	f	\N	\N	\N
609	41-2 цех. Стружка	Из 10 корп на утильбазу	6	300	2025-03-27 10:00:00	3	39	62	\N	2025-03-27 09:34:54.254935+03	2025-03-27 09:44:00.191669+03	2025-03-27 08:11:09.572184+03	f	f	\N	\N	\N
597	Мфу	Выч.техника	9	25	2025-03-26 15:45:00	3	27	60	\N	2025-03-26 15:37:18.314951+03	2025-03-27 08:52:04.55585+03	2025-03-26 15:36:07.391914+03	t	f	\N	\N	\N
610	41/3-10корп.развозка деталей	Забрать детали из БТК 10корпуса и отвезти согласно сдат.накладным	1	3	2025-03-27 08:30:00	3	74	8	\N	2025-03-27 08:22:59.247649+03	2025-03-27 09:32:58.435989+03	2025-03-27 08:12:30.036787+03	f	f	\N	\N	\N
611	Мусор	Нет	7	1	2025-03-27 08:45:00	3	47	40	\N	2025-03-27 08:14:12.37963+03	2025-03-27 10:00:32.625335+03	2025-03-27 08:13:57.027107+03	t	f	\N	\N	\N
617	Указатель СКЭС-2027Б	Забрать из 28 отдела корп.50, 3 этаж и привезти в корп. 1, этаж 1, 116 кабинет.	10	1	2025-03-27 10:00:00	3	50	40	\N	2025-03-27 08:50:45.537873+03	2025-03-27 09:20:56.060464+03	2025-03-27 08:35:48.882112+03	f	f	\N	\N	\N
616	Заготовка	Фрезеровка	1	2	2025-03-27 09:00:00	3	54	62	\N	2025-03-27 08:32:58.152021+03	2025-03-27 10:23:20.252361+03	2025-03-27 08:32:37.938394+03	t	f	\N	\N	\N
614	2 стола с упаковки	Нет	9	20	2025-03-27 09:00:00	3	47	60	\N	2025-03-27 08:26:40.98286+03	2025-03-27 09:39:48.294881+03	2025-03-27 08:22:16.723387+03	t	f	\N	\N	\N
626	Одежда	Нет	9	5	2025-03-27 09:00:00	3	16	61	\N	2025-03-27 09:05:22.545987+03	2025-03-27 09:05:35.114496+03	2025-03-27 09:05:05.976057+03	f	f	\N	\N	\N
1478	41	Отправка\n945358	1	1	2025-04-11 08:30:00	3	30	8	\N	2025-04-11 08:04:43.442662+03	2025-04-11 08:38:55.770426+03	2025-04-11 08:04:29.063151+03	f	f	5	26	35
607	Вывоз мусора и стружка	2 ящика мусора и 2 ящика стружки	4	35	2025-03-27 08:30:00	3	64	62	\N	2025-03-27 08:58:30.505734+03	2025-03-27 09:19:27.788586+03	2025-03-27 08:04:34.728114+03	f	f	\N	\N	\N
602	41	Отправка\n6т8410287    44ц	1	1	2025-03-27 09:00:00	3	30	8	\N	2025-03-27 07:55:44.66451+03	2025-03-27 09:31:18.350679+03	2025-03-27 07:43:42.253625+03	f	f	\N	\N	\N
1472	Трубы	Нет	1	1	2025-04-11 07:45:00	3	72	61	\N	2025-04-11 09:29:39.97315+03	2025-04-11 09:37:25.997626+03	2025-04-11 07:43:08.251813+03	t	f	5	41	44
1484	46	46	10	4	2025-04-11 09:00:00	3	56	58	\N	2025-04-11 11:46:01.289488+03	2025-04-11 13:58:03.053755+03	2025-04-11 08:34:43.263906+03	f	f	\N	43	35
625	41 цех	Забрать заготовки с 10 корпуса 41 цеха  на участок 2	4	20	2025-03-27 09:30:00	3	70	8	\N	2025-03-27 09:05:41.697295+03	2025-03-27 09:31:47.7706+03	2025-03-27 09:05:05.317854+03	t	f	\N	\N	\N
637	41 цех 6т8020031	Перевезти из кладовой корп 60/2 3 эт корпуса 6т8020031 в корп 10 бтк Постниковой И.Ю.	1	10	2025-03-27 12:00:00	3	23	8	\N	2025-03-27 11:48:06.695739+03	2025-03-27 12:03:27.964039+03	2025-03-27 10:14:09.197745+03	t	f	\N	\N	\N
650	Вывоз мусора	1 этаж (Алена)	7	10	2025-03-27 13:15:00	3	20	62	\N	2025-03-27 14:14:01.577608+03	2025-03-27 14:44:26.474972+03	2025-03-27 12:48:29.565542+03	f	f	\N	\N	\N
631	Цех 45	Вывоз металлолома на свалку	6	150	2025-03-27 09:45:00	3	67	17	\N	2025-03-27 09:37:43.891954+03	2025-03-27 09:56:21.670335+03	2025-03-27 09:37:16.222111+03	f	f	\N	\N	\N
657	41/10.отправка деталей с уч.промывки	Отвезти с уч.промывки детали согласно сдат.накладным	1	6	2025-03-27 14:00:00	3	74	8	\N	2025-03-27 13:09:28.593815+03	2025-03-27 15:28:19.292803+03	2025-03-27 13:06:18.570813+03	f	f	\N	\N	\N
632	Лазерные детали	Забрать лазерные детали, привезти в основной корпус 46ц	1	5	2025-03-27 10:00:00	3	19	62	\N	2025-03-27 09:53:40.170213+03	2025-03-27 10:10:01.123252+03	2025-03-27 09:46:32.682231+03	f	f	\N	\N	\N
653	Мусор	Стружка, отходы	6	90	2025-03-27 13:45:00	3	54	62	\N	2025-03-27 13:03:29.543698+03	2025-03-27 13:57:37.238556+03	2025-03-27 13:02:51.488407+03	t	f	\N	\N	\N
630	Шайба	1 этаж (Алена)	10	1	2025-03-27 09:45:00	3	20	62	\N	2025-03-27 10:10:49.938847+03	2025-03-27 10:21:49.589119+03	2025-03-27 09:29:29.581561+03	f	f	\N	\N	\N
628	41 цех	Получить материал  со склада, перевезти в 41 цех 10 корпус	4	300	2025-03-27 10:00:00	3	70	8	\N	2025-03-27 09:15:39.772611+03	2025-03-27 10:31:19.681498+03	2025-03-27 09:07:27.982469+03	f	f	\N	\N	\N
647	Цех 45	Отгрузка деталей 28 коробок	1	560	2025-03-27 12:30:00	3	11	17	\N	2025-03-27 12:25:08.797547+03	2025-03-27 13:56:47.018829+03	2025-03-27 12:24:35.655237+03	f	f	\N	\N	\N
638	Трубы с трубного участка	Нет	1	15	2025-03-27 10:45:00	3	47	40	\N	2025-03-27 10:34:30.83285+03	2025-03-27 10:40:13.34477+03	2025-03-27 10:34:08.265424+03	t	f	\N	\N	\N
635	Трубы на лужение	Нет	1	15	2025-03-27 10:15:00	3	47	40	\N	2025-03-27 10:04:20.177063+03	2025-03-27 10:40:29.274623+03	2025-03-27 09:56:54.233875+03	t	f	\N	\N	\N
634	41	Трубы	1	10	2025-03-27 10:30:00	3	55	8	\N	2025-03-27 10:38:10.541078+03	2025-03-27 10:43:16.825853+03	2025-03-27 09:53:16.532259+03	t	f	\N	\N	\N
633	Детали	Нет	1	25	2025-03-27 10:15:00	3	75	8	\N	2025-03-27 09:47:09.297473+03	2025-03-27 10:43:29.606935+03	2025-03-27 09:46:47.416729+03	t	f	\N	\N	\N
639	Детали	Хромированные	1	5	2025-03-27 11:00:00	3	54	62	\N	2025-03-27 10:37:46.115617+03	2025-03-27 10:59:18.777156+03	2025-03-27 10:37:22.545008+03	t	f	\N	\N	\N
629	Шайба	1 этаж(Алена)	10	1	2025-03-27 09:45:00	3	20	8	\N	2025-03-27 10:53:20.804804+03	2025-03-27 11:46:25.069821+03	2025-03-27 09:28:48.002308+03	f	f	\N	\N	\N
645	Цех 45	Отвезти детали на склад	1	1	2025-03-27 14:15:00	3	67	17	\N	2025-03-27 12:19:18.785387+03	2025-03-27 13:53:46.223685+03	2025-03-27 12:19:02.684295+03	f	f	\N	\N	\N
643	Цех 45	Отвезти детали в 58 цех	1	1	2025-03-27 14:00:00	3	67	17	\N	2025-03-27 12:18:22.044643+03	2025-03-27 13:56:28.205454+03	2025-03-27 12:17:15.896231+03	f	f	\N	\N	\N
642	Цех 45	Отвезти детали к токарю	1	15	2025-03-27 12:30:00	3	67	17	\N	2025-03-27 12:15:57.115748+03	2025-03-27 13:57:12.428996+03	2025-03-27 12:15:45.791618+03	f	f	\N	\N	\N
641	Готовые детали	Нет	1	5	2025-03-27 12:15:00	3	16	8	\N	2025-03-27 12:06:49.396559+03	2025-03-27 14:42:06.139331+03	2025-03-27 12:03:44.626333+03	f	f	\N	\N	\N
649	Деревянный палет	Вывоз деревянного палета от оборудования из 41 цеха корп.50 на утильбазу цеха 71	6	100	2025-03-27 12:45:00	3	18	8	\N	2025-03-27 12:40:50.662859+03	2025-03-27 12:48:51.051447+03	2025-03-27 12:37:56.407466+03	f	f	\N	\N	\N
644	Трубки 079-01;094-01	Срочно! Травление	1	10	2025-03-27 12:15:00	3	16	8	\N	2025-03-27 12:26:59.82819+03	2025-03-27 14:41:41.12898+03	2025-03-27 12:17:20.254119+03	t	f	\N	\N	\N
651	Заготовки	В цех 46	4	20	2025-03-27 13:15:00	3	57	8	\N	2025-03-27 12:59:08.274958+03	2025-03-27 14:41:23.907583+03	2025-03-27 12:58:58.566862+03	f	f	\N	\N	\N
660	41	Отправка\n6т8223515-01    154+316  44ц\n6л8222334      250шт   44ц\n944782        15шт     44ц\n6т8132118-03   47шт   в 44ц	1	3	2025-03-27 14:00:00	3	30	8	\N	2025-03-27 14:01:42.869368+03	2025-03-27 14:38:40.748444+03	2025-03-27 13:25:48.301182+03	f	f	\N	\N	\N
662	41-2 цех. Детали	Из 41-2 в 44, 46/12, 6/7	1	27	2025-03-27 14:00:00	3	39	8	\N	2025-03-27 14:02:16.733759+03	2025-03-27 14:38:54.909183+03	2025-03-27 13:41:13.436981+03	f	f	\N	\N	\N
652	Заготовки	На лазер 46 цеха	4	15	2025-03-27 13:30:00	3	57	8	\N	2025-03-27 13:00:47.555442+03	2025-03-27 14:41:12.488939+03	2025-03-27 13:00:36.035119+03	f	f	\N	\N	\N
659	41/3-10.стружка	Вывезти стружку с 10корп.в утильбазу	6	500	2025-03-28 17:45:00	3	74	8	\N	2025-03-28 11:13:07.255228+03	2025-03-28 11:51:14.175621+03	2025-03-27 13:13:29.013232+03	f	t	\N	\N	\N
636	Отборки	Нет	1	15	2025-03-27 10:30:00	3	47	40	\N	2025-03-27 10:06:30.221319+03	2025-03-27 13:10:28.622389+03	2025-03-27 09:57:58.157033+03	t	f	\N	\N	\N
648	Электроника и платы с списываемого оборудования	Цех 41 корп 60/2 этаж 3 переместить платы и электронику в отдел 21 корп. 50, для извлечения драгметаллов.	9	150	2025-03-27 13:00:00	3	18	40	\N	2025-03-27 13:15:12.859143+03	2025-03-27 13:15:30.553261+03	2025-03-27 12:36:09.05258+03	f	f	\N	\N	\N
646	Листы	Внутрицеховое перемещение листов на заготовке	4	1	2025-03-27 13:00:00	3	57	8	\N	2025-03-27 12:29:05.146975+03	2025-03-27 13:37:27.684487+03	2025-03-27 12:21:24.621831+03	f	f	\N	\N	\N
655	41/3-10корп. Отправка деталей	Забрать детали из БТК 10 корп. и отвезти согласно сдат.накладным	1	3	2025-03-27 14:00:00	3	74	8	\N	2025-03-27 13:05:29.868962+03	2025-03-27 14:40:50.547183+03	2025-03-27 13:04:56.059086+03	f	f	\N	\N	\N
661	46	46	10	10	2025-03-27 14:00:00	3	56	8	\N	2025-03-27 14:02:00.030359+03	2025-03-27 14:40:11.683182+03	2025-03-27 13:26:53.427974+03	f	f	\N	\N	\N
658	Детали	С термообработки	1	2	2025-03-27 14:00:00	3	54	62	\N	2025-03-27 13:13:18.980181+03	2025-03-27 14:11:47.695812+03	2025-03-27 13:12:22.125613+03	t	f	\N	\N	\N
656	Форма	Оснастка	8	5	2025-03-27 13:15:00	3	54	62	\N	2025-03-27 14:12:36.284208+03	2025-03-27 14:13:12.922939+03	2025-03-27 13:05:04.310775+03	t	f	\N	\N	\N
654	Детали	Из термички 46/12 в 41 цех	4	20	2025-03-27 14:45:00	3	57	8	\N	2025-03-27 13:03:09.094973+03	2025-03-27 14:38:03.742175+03	2025-03-27 13:03:02.159162+03	f	f	\N	\N	\N
1305	41	Отправка\n6т8120160	1	1	2025-04-09 09:00:00	3	30	8	\N	2025-04-09 08:36:39.772959+03	2025-04-09 09:00:33.939644+03	2025-04-09 08:36:31.933178+03	f	f	5	25	67
1473	Заготовки	На лазер	4	40	2025-04-11 08:15:00	3	57	8	\N	2025-04-11 08:18:34.149813+03	2025-04-11 09:15:02.659723+03	2025-04-11 07:43:09.547086+03	f	f	5	38	67
1489	41-2 цех. Детали	Развозка деталей	1	50	2025-04-11 09:00:00	3	39	8	\N	2025-04-11 08:47:45.360716+03	2025-04-11 09:14:11.671556+03	2025-04-11 08:41:20.043296+03	f	f	5	24	25
670	Отборки	Со склада 6 отд ПДО в 43 цех	4	1	2025-03-27 12:30:00	3	33	60	\N	2025-03-27 14:33:32.80124+03	2025-03-27 14:41:22.087046+03	2025-03-27 14:33:15.259173+03	f	f	\N	\N	\N
673	Рекламационные изделия	С 28 отд в 43 цех	10	2	2025-03-27 13:00:00	3	33	60	\N	2025-03-27 14:39:57.669204+03	2025-03-27 14:41:48.121499+03	2025-03-27 14:39:42.454585+03	f	f	\N	\N	\N
1481	Детали	10	1	10	2025-04-11 10:00:00	3	79	40	AgACAgIAAxkBAAEBMRRn-KaJo33m6JEDsoeZ0ZhYCsSAuQACdOkxG-A1yUsiGLTghpcW8wEAAwIAA3kAAzYE	2025-04-11 09:34:14.766267+03	2025-04-11 13:11:13.522896+03	2025-04-11 08:20:34.897878+03	f	f	5	2	51
667	41/3-10 корпус отвести на промывку детали	Отвести на промывку детали \n6т8034172 корпуса 36шт.\n6т8034170 корпуса 36шт.\n41/3-10 забрать\nот станка 16Б16 и от в 41/3-60 корпус 3 этаж промывку.	1	200	2025-03-27 14:30:00	3	46	8	AgACAgIAAxkBAAKVCmflL7ZbGysbOsdw2wcfei2z1rTnAAK_6TEb0mMoS1NIBYVY22TmAQADAgADeQADNgQ	2025-03-27 14:45:01.470368+03	2025-03-27 15:07:52.430427+03	2025-03-27 14:00:38.03416+03	f	f	\N	\N	\N
664	41/3-10 Отвести заготовки	Отвести заготовки из 41/10 корпуса в 41/50 корпус.\nЗаготовки стоят возле станков Хермле.\n6л8055255 панель 17шт.\n6л8055256 панель 17шт.	4	70	2025-03-27 14:00:00	3	46	8	AgACAgIAAxkBAAKUWmflLM1zH_WjhJ8yWlTGENzCJnkyAAKq6TEb0mMoSwTDqhZkBPKJAQADAgADeQADNgQ	2025-03-27 14:45:19.591446+03	2025-03-27 15:28:02.387956+03	2025-03-27 13:48:09.322032+03	f	f	\N	\N	\N
676	Трубы на лужение	Нет	1	15	2025-03-27 15:30:00	3	47	40	\N	2025-03-27 15:07:37.988563+03	2025-03-27 15:38:23.634814+03	2025-03-27 15:07:28.857395+03	t	f	\N	\N	\N
674	Отборки	Нет	1	15	2025-03-27 15:15:00	3	47	40	\N	2025-03-27 14:55:17.955705+03	2025-03-27 15:38:45.244705+03	2025-03-27 14:55:07.11861+03	t	f	\N	\N	\N
668	Готовые детали	Нет	1	10	2025-03-27 15:30:00	3	16	61	\N	2025-03-27 14:27:38.968817+03	2025-03-27 16:01:07.493816+03	2025-03-27 14:27:37.092146+03	t	f	\N	\N	\N
1486	46	46	10	2	2025-04-11 09:00:00	3	56	58	\N	2025-04-11 11:46:15.008849+03	2025-04-11 13:57:53.8986+03	2025-04-11 08:36:45.177166+03	f	f	\N	43	39
1475	Заготовки	Для 945	4	3	2025-04-11 08:15:00	3	57	8	\N	2025-04-11 08:05:39.660269+03	2025-04-11 08:39:40.817807+03	2025-04-11 07:45:38.40185+03	f	f	5	38	63
1483	Стойка с сильфоном	Нет	10	1	2025-04-11 09:00:00	3	47	40	AgACAgIAAxkBAAEBMTpn-KhEJdirI2B_9gUzttkMPZS8KAACX_IxG98SwUsyiqe0DkoDJgEAAwIAA3kAAzYE	2025-04-11 08:29:44.824+03	2025-04-11 09:42:05.756538+03	2025-04-11 08:27:40.488542+03	t	f	5	51	61
1494	Вода	Нет	5	150	2025-04-11 09:15:00	3	69	8	\N	2025-04-11 09:13:27.250989+03	2025-04-11 09:41:37.274703+03	2025-04-11 08:54:23.339913+03	t	f	5	14	62
1490	Молоко	Нет	9	150	2025-04-11 09:00:00	3	34	61	\N	2025-04-11 08:44:49.687991+03	2025-04-11 10:34:18.049887+03	2025-04-11 08:44:45.479809+03	t	f	5	13	34
1491	Кислота	Канистра	4	800	2025-04-11 10:00:00	3	34	61	\N	2025-04-11 08:46:55.942467+03	2025-04-11 10:33:47.63036+03	2025-04-11 08:46:51.287939+03	t	f	5	12	34
1479	41	Межоперационка \n6т8236101\nВ кладонью к Татьяне Юрьевны	1	2	2025-04-11 08:30:00	3	30	8	\N	2025-04-11 08:06:13.489987+03	2025-04-11 08:37:00.641784+03	2025-04-11 08:06:05.067582+03	f	f	5	26	24
1474	Заготовки	В цех 46	4	30	2025-04-11 08:15:00	3	57	61	\N	2025-04-11 10:32:43.727583+03	2025-04-11 10:56:37.242403+03	2025-04-11 07:44:33.276142+03	f	f	5	38	43
640	Готовая продукция	Продукция на склад сбыта.	10	100	2025-03-27 13:15:00	3	14	61	\N	2025-03-27 11:53:53.689761+03	2025-03-27 13:50:03.299261+03	2025-03-27 10:45:48.351269+03	t	f	\N	\N	\N
681	Заготовки	Из заготовки на лазер 46цех	4	1	2025-03-28 08:00:00	3	57	8	\N	2025-03-28 07:59:35.397439+03	2025-03-28 08:22:19.756135+03	2025-03-28 07:59:27.112132+03	f	f	\N	\N	\N
666	Цех 45	Получить арматуру со склада ПДО	4	1	2025-03-27 14:00:00	3	11	17	\N	2025-03-27 13:54:36.847623+03	2025-03-27 13:55:38.727795+03	2025-03-27 13:54:28.482688+03	t	f	\N	\N	\N
665	Два компьютера и два монитора.	Нет	9	15	2025-03-27 14:00:00	3	34	61	\N	2025-03-27 13:52:34.094215+03	2025-03-27 14:06:24.173934+03	2025-03-27 13:52:27.331448+03	t	f	\N	\N	\N
685	41/3-10 корпус. Промывка	Отвезти с уч.промывки детали согласно маршруту	1	15	2025-03-28 08:45:00	3	74	8	\N	2025-03-28 08:30:09.921452+03	2025-03-28 09:49:54.649588+03	2025-03-28 08:21:52.050534+03	f	f	\N	\N	\N
700	Заготовки 172 корпус	Забрать Заготовки с 46/12	1	20	2025-03-28 10:00:00	3	19	8	\N	2025-03-28 09:54:37.898934+03	2025-03-28 11:09:12.412159+03	2025-03-28 09:47:40.103784+03	t	f	\N	\N	\N
627	Электроника и платы с списываемого оборудования	Цех 41 корп 60/2 этаж 3 переместить платы и электронику в отдел 21 корп. 50, для извлечения драгметаллов.	9	300	2025-03-27 12:00:00	3	18	8	\N	2025-03-27 11:54:43.785564+03	2025-03-27 14:37:51.393786+03	2025-03-27 09:07:09.799192+03	f	f	\N	\N	\N
669	Столы, стеллажи	С 43 цеха на 59 станцию	9	70	2025-03-27 12:30:00	3	33	60	\N	2025-03-27 14:31:15.720866+03	2025-03-27 14:41:13.649824+03	2025-03-27 14:30:58.939016+03	f	f	\N	\N	\N
671	Детали	С 43 цеха в 44 цех	1	2	2025-03-27 12:30:00	3	33	60	\N	2025-03-27 14:35:49.275342+03	2025-03-27 14:41:31.719203+03	2025-03-27 14:35:28.550845+03	f	f	\N	\N	\N
672	Детали	С 44 цеха в 43 цех	1	8	2025-03-27 13:00:00	3	33	60	\N	2025-03-27 14:37:28.955771+03	2025-03-27 14:41:39.88114+03	2025-03-27 14:37:13.207889+03	f	f	\N	\N	\N
675	Плита	С фрезеровки	4	70	2025-03-27 15:15:00	3	54	62	\N	2025-03-27 15:00:00.674836+03	2025-03-27 15:25:35.763182+03	2025-03-27 14:59:30.305693+03	t	f	\N	\N	\N
663	Отборки	Нет	1	15	2025-03-27 14:15:00	3	47	40	\N	2025-03-27 13:59:36.225251+03	2025-03-27 15:38:55.440332+03	2025-03-27 13:47:37.888374+03	t	f	\N	\N	\N
677	Изделия	С 43 цеха на 59 станцию	10	40	2025-03-27 15:15:00	3	33	60	\N	2025-03-27 15:23:39.19838+03	2025-03-27 15:42:50.268998+03	2025-03-27 15:23:20.02395+03	f	f	\N	\N	\N
678	Мусор	Вывезти мусор из заготовки 46 на свалку	7	20	2025-03-28 10:00:00	3	57	8	\N	2025-03-28 07:53:15.697802+03	2025-03-28 11:10:01.601393+03	2025-03-27 16:03:27.379313+03	f	f	\N	\N	\N
699	Шайба	1 этаж Алена	10	1	2025-03-28 09:45:00	3	20	8	\N	2025-03-28 09:48:59.659273+03	2025-03-28 11:10:20.504643+03	2025-03-28 09:47:08.651609+03	f	f	\N	\N	\N
698	Цех 45	Отвезти детали токарю	1	10	2025-03-28 12:15:00	3	67	17	\N	2025-03-28 09:46:49.657928+03	2025-03-28 13:04:32.905179+03	2025-03-28 09:46:25.358061+03	f	f	\N	\N	\N
701	Цех 45	Отвезти детали на склад ПДО	1	1	2025-03-28 13:00:00	3	67	17	\N	2025-03-28 09:48:05.598373+03	2025-03-28 13:04:11.890974+03	2025-03-28 09:47:52.181102+03	f	f	\N	\N	\N
680	Заготовки	Из заготовки в цех46	4	2	2025-03-28 08:00:00	3	57	8	\N	2025-03-28 07:58:27.601318+03	2025-03-28 08:21:32.811168+03	2025-03-28 07:58:17.173295+03	f	f	\N	\N	\N
705	Забрать 2 трубы, отвезти в 8 отдел (Осташкову)	Забрать 2 трубы, отвезти в 8 отдел (Осташкову)	1	2	2025-03-28 10:45:00	3	19	8	AgACAgIAAxkBAAKcaWfmTDuQrPsY8809xJ7MN50xfcbIAALJ5DEbpnwxS1VFS13eWo9LAQADAgADeQADNgQ	2025-03-28 10:51:32.847165+03	2025-03-28 12:20:15.33065+03	2025-03-28 10:14:13.796992+03	f	f	\N	\N	\N
686	Заготовки	Аварийные 172 корпуса	4	6	2025-03-28 08:30:00	3	57	8	\N	2025-03-28 08:35:56.235968+03	2025-03-28 11:10:56.747664+03	2025-03-28 08:28:04.596215+03	t	f	\N	\N	\N
688	41-2 цех. Детали	Из 41-2 в 46/8, 45	1	7	2025-03-28 09:00:00	3	39	8	\N	2025-03-28 08:36:42.76356+03	2025-03-28 09:48:14.579341+03	2025-03-28 08:32:11.838465+03	f	f	\N	\N	\N
706	41 цех. Мусор	Из 10 корпуса заготовительный участок (10-2) в 71 утильбазу	7	70	2025-03-28 11:00:00	3	39	40	\N	2025-03-28 10:50:30.47607+03	2025-03-28 15:34:40.506334+03	2025-03-28 10:28:47.096233+03	f	f	\N	\N	\N
694	Платы	С 31 цеха в 43 цех	4	12	2025-03-28 08:30:00	3	33	60	\N	2025-03-28 09:07:23.458665+03	2025-03-28 10:08:06.210103+03	2025-03-28 09:07:01.613622+03	f	f	\N	\N	\N
695	Компьютер	С 39 отд в 43 цех	9	5	2025-03-28 08:30:00	3	33	60	\N	2025-03-28 09:10:08.295524+03	2025-03-28 10:08:14.80873+03	2025-03-28 09:09:48.53382+03	f	f	\N	\N	\N
704	Приборы	С метрологии 35 отд в 43 цех	8	100	2025-03-28 10:00:00	3	27	60	\N	2025-03-28 10:06:57.919972+03	2025-03-28 10:08:28.818961+03	2025-03-28 10:06:41.09296+03	f	f	\N	\N	\N
689	Заготовки	Два лотка	4	5	2025-03-28 09:00:00	3	32	61	\N	2025-03-28 08:53:16.500942+03	2025-03-28 09:11:08.137681+03	2025-03-28 08:53:00.92838+03	t	f	\N	\N	\N
692	ПКИ	Со склада 14 отд ПКИ в 43 цех	4	10	2025-03-28 08:30:00	3	33	60	\N	2025-03-28 09:03:45.026727+03	2025-03-28 10:07:53.559612+03	2025-03-28 09:03:26.095171+03	f	f	\N	\N	\N
691	41-2 цех. Мусор	Из 10 корп на 71 утильбазу	7	50	2025-03-28 09:30:00	3	39	40	\N	2025-03-28 09:00:01.238498+03	2025-03-28 09:43:44.768786+03	2025-03-28 08:59:14.911829+03	f	f	\N	\N	\N
690	Детали	Термичка	1	2	2025-03-28 09:15:00	3	54	8	\N	2025-03-28 08:59:11.957476+03	2025-03-28 09:47:38.187771+03	2025-03-28 08:59:02.348314+03	t	f	\N	\N	\N
687	41	Детали	1	5	2025-03-28 09:15:00	3	55	8	\N	2025-03-28 08:35:30.700727+03	2025-03-28 09:47:53.396932+03	2025-03-28 08:30:18.457377+03	f	f	\N	\N	\N
684	46	46	10	5	2025-03-28 09:00:00	3	56	8	\N	2025-03-28 08:29:11.96997+03	2025-03-28 09:48:29.551338+03	2025-03-28 08:21:51.715748+03	f	f	\N	\N	\N
682	46	46	10	10	2025-03-28 09:00:00	3	56	8	\N	2025-03-28 08:20:11.101002+03	2025-03-28 09:49:18.331823+03	2025-03-28 08:19:58.401376+03	f	f	\N	\N	\N
683	41/3-10корп. Отправка деталей	Забрать детали из БТК 10корп. и отвезти согласно сдат.накладным	1	20	2025-03-28 09:00:00	3	74	8	\N	2025-03-28 08:29:38.19939+03	2025-03-28 09:49:39.96974+03	2025-03-28 08:20:08.637504+03	f	f	\N	\N	\N
679	Металлические отходы	Вывезти на утиль базу	6	30	2025-03-28 10:00:00	3	57	8	\N	2025-03-28 07:52:57.465557+03	2025-03-28 11:09:39.21586+03	2025-03-27 16:05:23.97402+03	f	f	\N	\N	\N
696	Приборы	В метрологию с 43 цеха в 35 отд	8	200	2025-03-28 09:15:00	3	27	60	\N	2025-03-28 09:16:10.64218+03	2025-03-28 10:07:27.182608+03	2025-03-28 09:15:51.598344+03	f	f	\N	\N	\N
702	Цех 45	Вывезти мусор	6	200	2025-03-28 14:00:00	3	67	17	\N	2025-03-28 09:49:35.797689+03	2025-03-28 13:03:57.179275+03	2025-03-28 09:48:58.017435+03	f	f	\N	\N	\N
697	Мусор стружка	3 ящика	7	150	2025-03-28 13:30:00	3	69	8	\N	2025-03-28 09:54:03.354151+03	2025-03-28 10:58:14.985819+03	2025-03-28 09:21:14.154285+03	f	f	\N	\N	\N
1487	Детали	Термообработка	1	2	2025-04-11 09:00:00	3	54	61	\N	2025-04-11 13:25:51.578996+03	2025-04-11 14:08:47.205066+03	2025-04-11 08:39:11.627597+03	f	f	\N	54	39
703	Забрать лазерные детали	Забрать лазерные детали, отвезти в основной корпус	1	7	2025-03-28 10:15:00	3	19	61	\N	2025-03-28 10:22:40.732896+03	2025-03-28 10:48:58.9479+03	2025-03-28 09:58:32.275401+03	f	f	\N	\N	\N
1493	Детали	Для 945	4	30	2025-04-11 09:00:00	3	57	8	\N	2025-04-11 10:48:02.296358+03	2025-04-11 11:05:35.58696+03	2025-04-11 08:54:07.181932+03	f	f	5	39	63
1480	Плита д16	Забрать плиту д16 #40 в 945 и отвезти в 41	4	55	2025-04-11 09:30:00	3	64	8	\N	2025-04-11 08:18:05.251266+03	2025-04-11 09:35:26.689636+03	2025-04-11 08:17:13.900308+03	f	f	5	63	26
1492	Шайба	Нет	10	1	2025-04-11 09:15:00	3	20	58	\N	2025-04-11 11:46:48.579425+03	2025-04-11 13:56:50.274695+03	2025-04-11 08:47:16.950909+03	t	f	5	44	35
693	Вывоз мусора	Вывоз мусора из цеха 41 корп 50 на утильбазу 71 цеха	6	100	2025-03-28 09:30:00	3	18	40	AgACAgIAAxkBAAKaVWfmO_9V5mTY1jwSblkyz-tkhUAHAAKv_DEbo6UwS_bdYTDq7q1QAQADAgADeQADNgQ	2025-03-28 09:06:24.658793+03	2025-03-28 10:49:37.575931+03	2025-03-28 09:05:00.830199+03	t	f	\N	\N	\N
726	Готовые детали	Нет	1	5	2025-03-28 14:00:00	3	16	61	\N	2025-03-28 13:45:11.684771+03	2025-03-28 14:12:25.581267+03	2025-03-28 13:41:31.144483+03	t	f	\N	\N	\N
710	Детали	Из вакуумного участка 46/8  в цех	4	1	2025-03-28 12:00:00	3	57	8	\N	2025-03-28 10:52:43.350367+03	2025-03-28 11:08:52.520008+03	2025-03-28 10:52:24.471522+03	t	f	\N	\N	\N
720	41-2 цех. Детали	Из 41-2 в 44	1	4	2025-03-28 14:00:00	3	39	8	\N	2025-03-28 13:18:01.032497+03	2025-03-28 14:54:59.269373+03	2025-03-28 13:06:06.193216+03	f	f	\N	\N	\N
709	Вывоз мусора	Вывоз производственного мусора из цеха 41 корп.50на утильбазу цеха 71	6	50	2025-03-28 11:15:00	3	18	40	\N	2025-03-28 11:19:12.89318+03	2025-03-28 11:20:17.523095+03	2025-03-28 10:50:24.303935+03	t	f	\N	\N	\N
711	41/3-10 корп. Отправка деталей	Отвезти детали 6т8034303-01 с 3уч (от Hermle у ворот) в 41/50 на Pinnacle, 2 ящика	1	25	2025-03-28 11:45:00	3	74	8	\N	2025-03-28 11:12:05.81421+03	2025-03-28 12:08:40.968036+03	2025-03-28 11:11:09.983183+03	t	f	\N	\N	\N
708	056 поплавок	Нет	1	10	2025-03-28 10:45:00	3	16	8	\N	2025-03-28 10:37:02.726492+03	2025-03-28 12:09:06.209003+03	2025-03-28 10:36:23.147067+03	t	f	\N	\N	\N
736	Детали	С 43 цеха ПРБ в 44 цех	1	5	2025-03-28 12:30:00	3	33	60	\N	2025-03-28 14:55:42.542158+03	2025-03-28 15:03:00.892623+03	2025-03-28 14:55:26.869372+03	f	f	\N	\N	\N
728	Форма	П/ форма	8	6	2025-03-28 14:00:00	3	54	8	\N	2025-03-28 14:27:31.001568+03	2025-03-28 14:55:14.475629+03	2025-03-28 13:46:14.454173+03	t	f	\N	\N	\N
721	Готовые детали	Нет	1	10	2025-03-28 13:30:00	3	16	61	\N	2025-03-28 13:16:22.64524+03	2025-03-28 13:28:28.343999+03	2025-03-28 13:16:12.924054+03	t	f	\N	\N	\N
718	Отборки	Нет	1	1	2025-03-28 13:15:00	3	47	40	\N	2025-03-28 13:02:27.758653+03	2025-03-28 13:29:26.475317+03	2025-03-28 13:02:08.497384+03	t	f	\N	\N	\N
712	Шайба	1 этаж	10	1	2025-03-28 12:15:00	3	20	8	\N	2025-03-28 12:23:02.132814+03	2025-03-28 12:50:07.138775+03	2025-03-28 12:19:43.844285+03	f	f	\N	\N	\N
740	Сбыт	С упаковки 43 цеха на склад 79	10	20	2025-03-28 15:15:00	3	33	60	\N	2025-03-28 15:16:40.421663+03	2025-03-28 15:52:24.429224+03	2025-03-28 15:16:24.193974+03	f	f	\N	\N	\N
707	ПКИ	Разъёмы	4	10	2025-03-28 10:45:00	3	49	40	\N	2025-03-28 10:49:51.293888+03	2025-03-28 13:29:35.24707+03	2025-03-28 10:34:53.536091+03	t	f	\N	\N	\N
719	Цех 45	Привезти фенопласт со склада	4	120	2025-03-28 13:00:00	3	67	17	\N	2025-03-28 13:06:36.094035+03	2025-03-28 13:07:03.907919+03	2025-03-28 13:06:01.099874+03	f	f	\N	\N	\N
717	Шкалы матить	Нет	1	1	2025-03-28 12:45:00	3	47	40	\N	2025-03-28 12:39:21.652064+03	2025-03-28 13:08:33.27768+03	2025-03-28 12:38:06.898427+03	t	f	\N	\N	\N
713	Заготовки	Из заготовительного 46 в цех	4	2	2025-03-28 12:30:00	3	57	8	\N	2025-03-28 12:25:34.340247+03	2025-03-28 13:14:10.965062+03	2025-03-28 12:25:22.035321+03	f	f	\N	\N	\N
714	46	46	10	3	2025-03-28 12:00:00	3	56	8	\N	2025-03-28 12:38:42.656284+03	2025-03-28 13:14:26.609459+03	2025-03-28 12:30:29.397201+03	f	f	\N	\N	\N
727	Детали с лвзера	Забрать с лазерного участка готовые детали, отвезти в основной корпус	1	5	2025-03-28 14:30:00	3	19	8	\N	2025-03-28 13:43:40.593166+03	2025-03-28 14:53:49.596497+03	2025-03-28 13:43:24.939546+03	t	f	\N	\N	\N
722	Готовые детали	Нет	1	10	2025-03-28 13:30:00	3	16	61	\N	2025-03-28 13:16:25.219139+03	2025-03-28 13:40:34.066313+03	2025-03-28 13:16:14.050737+03	t	f	\N	\N	\N
723	41/3 корп10. Отправка деталей	Забрать детали из БТК 10корп.(меж.операционка) и с участка промывки и отвезти на 2уч в 41/60	1	15	2025-03-28 14:00:00	3	74	8	\N	2025-03-28 13:18:15.666864+03	2025-03-28 14:55:23.055314+03	2025-03-28 13:17:45.756337+03	f	f	\N	\N	\N
730	Ярлыки	1 этаж Алена	9	1	2025-03-28 14:30:00	3	20	8	\N	2025-03-28 14:27:06.497241+03	2025-03-28 14:54:03.592511+03	2025-03-28 14:26:38.489884+03	t	f	\N	\N	\N
742	Детали	С 44 цеха в 43 цех ПРБ	1	1	2025-03-28 15:30:00	3	33	60	\N	2025-03-28 15:49:25.497257+03	2025-03-28 15:52:38.736078+03	2025-03-28 15:49:08.706933+03	f	f	\N	\N	\N
716	Бытовые отходы	Нет	7	50	2025-03-28 13:00:00	3	32	61	\N	2025-03-28 12:33:06.145635+03	2025-03-28 14:36:13.826617+03	2025-03-28 12:32:59.138197+03	t	f	\N	\N	\N
737	Детали	С 44 цеха в 43 цех ПРБ	1	8	2025-03-28 13:00:00	3	33	60	\N	2025-03-28 14:57:45.415306+03	2025-03-28 15:03:11.133228+03	2025-03-28 14:57:29.621215+03	f	f	\N	\N	\N
724	Забрать детали с хрома	Нет	1	2	2025-03-28 14:00:00	3	63	8	\N	2025-03-28 13:39:12.958785+03	2025-03-28 14:52:58.234623+03	2025-03-28 13:39:08.811429+03	t	f	\N	\N	\N
725	Готовые детали	Нет	1	5	2025-03-28 14:00:00	3	16	8	\N	2025-03-28 13:57:18.272445+03	2025-03-28 14:54:15.705268+03	2025-03-28 13:40:58.162225+03	t	f	\N	\N	\N
715	41	Отправка\n926773         в 44ц\n6т7750052  в 46/8ц\n6т8227095     44ц\n6т8236041   58+40   на склад\n6т8236041-06    20  на склад\n6т8236041-29    331   на склад	1	10	2025-03-28 14:00:00	3	30	8	\N	2025-03-28 12:38:27.487119+03	2025-03-28 14:54:36.479302+03	2025-03-28 12:32:12.061832+03	f	f	\N	\N	\N
734	Тара	С 43 цеха ПРБ в 41 цех	9	50	2025-03-28 12:30:00	3	33	60	\N	2025-03-28 14:50:39.884176+03	2025-03-28 15:02:30.417911+03	2025-03-28 14:50:24.498487+03	f	f	\N	\N	\N
735	Тара	С 43 цеха ПРБ на склад 6 отд ПДО	9	15	2025-03-28 12:30:00	3	33	60	\N	2025-03-28 14:53:17.150629+03	2025-03-28 15:02:47.597005+03	2025-03-28 14:53:00.970552+03	f	f	\N	\N	\N
738	Мусор	С 43 цеха в 71 утиль базу	7	80	2025-03-28 13:30:00	3	33	60	\N	2025-03-28 15:00:51.364907+03	2025-03-28 15:03:20.818216+03	2025-03-28 15:00:35.805777+03	f	f	\N	\N	\N
729	Готовая продукция	Нет	10	50	2025-03-28 14:30:00	3	47	40	\N	2025-03-28 14:08:36.155853+03	2025-03-28 15:16:36.792144+03	2025-03-28 14:08:26.16405+03	t	f	\N	\N	\N
731	Трубы с малярки	Нет	1	1	2025-03-28 15:00:00	3	47	40	\N	2025-03-28 14:44:48.746582+03	2025-03-28 15:39:09.18664+03	2025-03-28 14:43:43.336615+03	t	f	\N	\N	\N
732	Шайба	Срочно! 1 этаж Алена	10	1	2025-03-28 14:45:00	3	20	8	\N	2025-03-28 15:21:27.180007+03	2025-03-28 15:23:00.699272+03	2025-03-28 14:44:42.032103+03	t	f	\N	\N	\N
741	Готовые детали	Нет	1	10	2025-03-28 15:45:00	3	16	61	\N	2025-03-28 15:46:13.362112+03	2025-03-28 15:46:29.048543+03	2025-03-28 15:46:10.122982+03	f	f	\N	\N	\N
743	Компьютер	С 39 отд в 43 цех ПРБ	9	5	2025-03-28 15:30:00	3	33	60	\N	2025-03-28 15:50:59.44553+03	2025-03-28 15:52:48.273928+03	2025-03-28 15:50:44.435358+03	f	f	\N	\N	\N
733	Мусор	Нет	7	80	2025-03-28 15:30:00	3	47	40	\N	2025-03-28 14:49:32.986718+03	2025-03-28 15:53:48.144331+03	2025-03-28 14:49:21.44029+03	t	f	\N	\N	\N
739	Приборы	С 43 цеха в МС-35	8	20	2025-03-28 15:00:00	3	33	60	\N	2025-03-28 15:12:58.07787+03	2025-03-28 15:52:06.569551+03	2025-03-28 15:12:42.545132+03	f	f	\N	\N	\N
744	Проверка	Нет	9	5	2025-03-28 17:00:00	4	16	\N	\N	\N	\N	2025-03-28 16:55:21.980803+03	f	f	\N	\N	\N
753	46	46	10	3	2025-03-31 09:00:00	3	56	58	\N	2025-03-31 08:39:54.637486+03	2025-03-31 09:34:50.079975+03	2025-03-31 08:22:58.962676+03	f	f	\N	\N	\N
776	Шайба	1 этаж Алена	10	1	2025-03-31 10:45:00	3	20	58	\N	2025-03-31 10:29:32.945292+03	2025-03-31 11:05:59.692128+03	2025-03-31 10:26:19.141183+03	f	f	\N	\N	\N
761	Цех 45	Привезти детали от токаря	1	30	2025-03-31 09:15:00	3	67	17	\N	2025-03-31 08:56:56.091064+03	2025-03-31 09:37:25.680874+03	2025-03-31 08:56:48.529466+03	f	f	\N	\N	\N
763	ПКИ	Со склада 14 отд ПКИ в 43 цех	4	10	2025-03-31 08:30:00	3	33	60	\N	2025-03-31 09:06:56.515489+03	2025-03-31 09:10:01.032953+03	2025-03-31 09:06:38.172684+03	f	f	\N	\N	\N
764	Халаты спец одежда	С 43 цеха в прачечную	9	12	2025-03-31 08:45:00	3	33	60	\N	2025-03-31 09:09:42.908728+03	2025-03-31 09:10:09.866971+03	2025-03-31 09:09:27.234681+03	f	f	\N	\N	\N
746	41 цех	60/2 3 этаж + 10 корп стирка в прачечную	9	5	2025-03-31 09:00:00	3	42	8	\N	2025-03-31 07:58:58.971333+03	2025-03-31 09:15:08.366626+03	2025-03-31 07:56:44.141158+03	f	f	\N	\N	\N
777	Заготовки	Два лотка	4	5	2025-03-31 10:30:00	3	32	61	\N	2025-03-31 10:29:04.682771+03	2025-03-31 10:46:59.121624+03	2025-03-31 10:29:01.825469+03	t	f	\N	\N	\N
766	Мусорные отходы	Утиль база	6	70	2025-03-31 09:30:00	3	54	62	\N	2025-03-31 09:23:26.471535+03	2025-03-31 09:47:39.197434+03	2025-03-31 09:22:34.19404+03	t	f	\N	\N	\N
759	41-2 цех. Мусор	41-2 в 71	7	70	2025-03-31 09:00:00	3	39	8	\N	2025-03-31 08:48:24.569708+03	2025-03-31 09:15:21.760137+03	2025-03-31 08:36:53.780599+03	f	f	\N	\N	\N
782	46	46	10	2	2025-03-31 12:00:00	3	56	58	\N	2025-03-31 11:06:36.449427+03	2025-03-31 12:54:55.772799+03	2025-03-31 11:00:03.61124+03	f	f	\N	\N	\N
757	41-2 цех. Детали	Из 41-2 в 46/12	1	12	2025-03-31 09:00:00	3	39	8	\N	2025-03-31 08:41:11.860244+03	2025-03-31 09:15:34.277243+03	2025-03-31 08:36:02.796682+03	f	f	\N	\N	\N
748	41/3-10корп. Отправка деталей	Забрать детали из БТК 10корп.и с уч.промывки и отвезти на 2 уч.41/60	1	25	2025-03-31 09:00:00	3	74	8	\N	2025-03-31 08:16:59.882746+03	2025-03-31 09:15:45.229374+03	2025-03-31 08:16:00.720667+03	f	f	\N	\N	\N
749	41/3-10корп. Стружка	Вывезти стружку с 10корп.в утильбазу	6	500	2025-03-31 09:00:00	3	74	40	\N	2025-03-31 08:35:27.146555+03	2025-03-31 09:48:55.284637+03	2025-03-31 08:17:44.230328+03	f	f	\N	\N	\N
745	Отходы на лазере	Вывезти отходы металла с лазерного участка	7	10	2025-03-31 08:30:00	3	19	58	\N	2025-03-31 07:55:58.896641+03	2025-03-31 09:49:38.990565+03	2025-03-31 07:55:45.460142+03	f	f	\N	\N	\N
768	Уголок	6м	4	240	2025-03-31 09:45:00	3	69	8	\N	2025-03-31 09:32:31.59207+03	2025-03-31 09:51:36.997999+03	2025-03-31 09:24:44.096235+03	t	f	\N	\N	\N
754	Детали	Термичка	1	2	2025-03-31 08:45:00	3	54	62	\N	2025-03-31 08:25:48.511921+03	2025-03-31 08:53:37.499763+03	2025-03-31 08:25:08.718025+03	t	f	\N	\N	\N
755	Одежда	Прачечная	9	2	2025-03-31 08:45:00	3	54	62	\N	2025-03-31 08:29:06.501253+03	2025-03-31 08:54:15.342604+03	2025-03-31 08:28:38.345999+03	t	f	\N	\N	\N
765	Расходомеры	Нет	3	15	2025-03-31 09:45:00	3	47	62	\N	2025-03-31 10:05:06.526595+03	2025-03-31 10:20:50.720445+03	2025-03-31 09:15:59.35657+03	t	f	\N	\N	\N
770	Штампы	Оснастка	8	18	2025-03-31 10:00:00	3	36	62	\N	2025-03-31 09:48:00.668987+03	2025-03-31 10:21:26.467585+03	2025-03-31 09:45:52.409209+03	t	f	\N	\N	\N
751	41-2 цех. Стружка	Из 10 корпуса на утильбазу 71	6	500	2025-03-31 08:45:00	3	39	8	\N	2025-03-31 08:22:48.067244+03	2025-03-31 09:15:58.90541+03	2025-03-31 08:19:29.289209+03	t	f	\N	\N	\N
760	Цех 45	Отвезти белье в стирку	9	3	2025-03-31 09:00:00	3	67	17	\N	2025-03-31 08:56:03.483098+03	2025-03-31 09:16:07.209967+03	2025-03-31 08:55:52.780748+03	f	f	\N	\N	\N
774	Колесо	Отвезти в термичку	1	2	2025-03-31 10:45:00	3	20	58	\N	2025-03-31 10:30:00.981305+03	2025-03-31 11:05:43.865935+03	2025-03-31 10:24:46.43543+03	f	f	\N	\N	\N
756	Спецодежда	Нет	9	5	2025-03-31 08:30:00	3	66	61	\N	2025-03-31 08:34:20.305168+03	2025-03-31 09:31:27.590836+03	2025-03-31 08:34:17.155901+03	t	f	\N	\N	\N
758	Хим.Отходы	Вывоз	6	200	2025-03-31 08:30:00	3	66	61	\N	2025-03-31 08:36:15.154397+03	2025-03-31 09:32:05.208267+03	2025-03-31 08:36:12.325609+03	t	f	\N	\N	\N
750	46	46	10	5	2025-03-31 09:00:00	3	56	58	\N	2025-03-31 08:40:36.610278+03	2025-03-31 09:34:14.197184+03	2025-03-31 08:19:14.813168+03	f	f	\N	\N	\N
752	46	46	10	2	2025-03-31 09:00:00	3	56	58	\N	2025-03-31 08:39:11.333396+03	2025-03-31 09:34:34.563969+03	2025-03-31 08:20:58.496897+03	f	f	\N	\N	\N
771	Лист d16	Нет	4	5	2025-03-31 10:00:00	3	32	61	\N	2025-03-31 09:56:18.043763+03	2025-03-31 09:56:51.113749+03	2025-03-31 09:56:14.329536+03	t	f	\N	\N	\N
762	Вывезти мусор из цеха	Вывезти мусор из основного корпуса	7	30	2025-03-31 10:00:00	3	19	58	\N	2025-03-31 08:59:27.198359+03	2025-03-31 10:33:23.367713+03	2025-03-31 08:58:10.472125+03	f	f	\N	\N	\N
778	Отборка	Нет	1	5	2025-03-31 12:00:00	3	47	58	\N	2025-03-31 11:10:51.832331+03	2025-03-31 12:55:09.16064+03	2025-03-31 10:43:22.830396+03	t	f	\N	\N	\N
769	Химия	Коробки, мешки	4	200	2025-03-31 10:00:00	3	34	61	\N	2025-03-31 09:35:44.560921+03	2025-03-31 10:29:57.056368+03	2025-03-31 09:35:41.043968+03	t	f	\N	\N	\N
773	Забрать бытовую химию	Забрать бытовую химию со склада химии	9	10	2025-03-31 10:45:00	3	19	58	\N	2025-03-31 10:07:53.190964+03	2025-03-31 10:33:58.032113+03	2025-03-31 10:07:42.713012+03	f	f	\N	\N	\N
767	41	Склад химии >быт химия>10 корп	9	100	2025-03-31 10:00:00	3	42	40	\N	2025-03-31 09:27:30.836061+03	2025-03-31 10:40:07.083294+03	2025-03-31 09:23:13.114364+03	f	f	\N	\N	\N
772	Стекла	Нет	1	1	2025-03-31 10:30:00	3	47	40	\N	2025-03-31 10:18:00.302231+03	2025-03-31 10:53:06.428811+03	2025-03-31 10:02:39.830062+03	t	f	\N	\N	\N
747	Трубы	Материал	4	60	2025-03-31 10:15:00	3	72	8	\N	2025-03-31 08:07:27.75758+03	2025-03-31 10:55:29.361619+03	2025-03-31 08:03:25.20009+03	f	f	\N	\N	\N
779	Забрать ответ из лаборатории	Нет	9	1	2025-03-31 11:00:00	3	20	58	\N	2025-03-31 10:52:40.258047+03	2025-03-31 11:05:35.577576+03	2025-03-31 10:52:31.563854+03	t	f	\N	\N	\N
775	Шайба	Нет	10	1	2025-03-31 10:45:00	3	20	58	\N	2025-03-31 10:30:23.019198+03	2025-03-31 11:05:53.125695+03	2025-03-31 10:25:44.330202+03	f	f	\N	\N	\N
784	Сбыт	С упаковки 43 цеха в 79 отдел	10	25	2025-03-31 10:15:00	3	33	60	\N	2025-03-31 11:11:55.045437+03	2025-03-31 11:15:31.135606+03	2025-03-31 11:11:37.104771+03	f	f	\N	\N	\N
785	Тара	С 43 цеха на 7 участок 43 цеха	9	30	2025-03-31 10:15:00	3	33	60	\N	2025-03-31 11:14:55.107769+03	2025-03-31 11:15:40.760531+03	2025-03-31 11:14:40.06317+03	f	f	\N	\N	\N
780	Шкалы	Нет	1	1	2025-03-31 12:00:00	3	47	40	\N	2025-03-31 11:01:53.588745+03	2025-03-31 12:17:42.980138+03	2025-03-31 10:55:17.191201+03	t	f	\N	\N	\N
783	Изделия	2ку забрать с 40 станции в 43 цех	10	20	2025-03-31 09:45:00	3	33	60	\N	2025-03-31 11:09:12.502085+03	2025-03-31 11:15:21.89377+03	2025-03-31 11:08:54.081617+03	f	f	\N	\N	\N
781	46	46	10	10	2025-03-31 12:00:00	3	56	58	\N	2025-03-31 11:06:19.937886+03	2025-03-31 12:54:49.186043+03	2025-03-31 10:58:09.254213+03	f	f	\N	\N	\N
787	Детали	Из термического участка 46/50-3	4	5	2025-03-31 12:30:00	3	57	8	\N	2025-03-31 12:27:01.791917+03	2025-03-31 12:48:29.012432+03	2025-03-31 12:20:32.487924+03	f	f	\N	\N	\N
1477	41	Отправка\n945202\n944618	1	2	2025-04-11 08:30:00	3	30	8	\N	2025-04-11 08:03:52.894748+03	2025-04-11 08:37:32.292795+03	2025-04-11 08:03:42.288194+03	f	f	5	26	41
805	Бланки	С кб на 46/12	9	2	2025-03-31 14:00:00	3	57	58	\N	2025-03-31 13:42:25.036169+03	2025-03-31 14:40:26.353794+03	2025-03-31 13:42:18.643237+03	f	f	\N	\N	\N
810	Канистры	Нет	9	10	2025-03-31 14:00:00	3	66	61	\N	2025-03-31 13:59:14.333573+03	2025-03-31 14:00:22.143009+03	2025-03-31 13:59:11.000636+03	t	f	\N	\N	\N
806	46	46	10	3	2025-03-31 14:00:00	3	56	58	\N	2025-03-31 13:46:38.693211+03	2025-03-31 14:40:32.560857+03	2025-03-31 13:44:49.452211+03	f	f	\N	\N	\N
789	Детали	Из термического участка 46/50-3	4	5	2025-03-31 12:30:00	3	57	8	\N	2025-03-31 12:26:16.513295+03	2025-03-31 12:47:55.353938+03	2025-03-31 12:20:32.611394+03	f	f	\N	\N	\N
788	Детали	Из термического участка 46/50-3	4	5	2025-03-31 12:30:00	3	57	8	\N	2025-03-31 12:26:44.901768+03	2025-03-31 12:48:10.572813+03	2025-03-31 12:20:32.490448+03	f	f	\N	\N	\N
808	Химия отходы	С 43 цеха на утиль базу	6	250	2025-03-31 12:15:00	3	33	60	\N	2025-03-31 13:54:42.7077+03	2025-03-31 14:00:23.010194+03	2025-03-31 13:54:26.50474+03	f	f	\N	\N	\N
801	41/3-10корп. Промывка	Отвезти коробку с 10корп.с уч.промывки в метрологическую службу отдел 35	8	5	2025-03-31 14:00:00	3	74	8	\N	2025-03-31 13:29:45.077497+03	2025-03-31 14:57:17.36474+03	2025-03-31 13:19:10.168911+03	f	f	\N	\N	\N
786	Детали	Из термического участка 46/50-3	4	5	2025-03-31 12:30:00	3	57	58	\N	2025-03-31 12:22:06.957595+03	2025-03-31 12:54:34.04542+03	2025-03-31 12:20:32.486558+03	f	f	\N	\N	\N
791	Заготовки	Из заготовки в цех	4	2	2025-03-31 12:30:00	3	57	58	\N	2025-03-31 12:29:18.504411+03	2025-03-31 12:54:42.545098+03	2025-03-31 12:28:31.542894+03	f	f	\N	\N	\N
790	41	Песок	1	3	2025-03-31 12:30:00	3	55	8	\N	2025-03-31 12:25:55.61984+03	2025-03-31 12:55:54.062037+03	2025-03-31 12:20:58.212111+03	t	f	\N	\N	\N
809	Детали	С 44 цеха в ПРБ 43 цеха	1	12	2025-03-31 13:15:00	3	33	60	\N	2025-03-31 13:57:15.406555+03	2025-03-31 14:00:33.046634+03	2025-03-31 13:57:00.360744+03	f	f	\N	\N	\N
794	Детали	Термообработка	1	5	2025-03-31 13:00:00	3	54	62	\N	2025-03-31 12:51:05.888365+03	2025-03-31 13:40:07.106768+03	2025-03-31 12:50:41.017843+03	t	f	\N	\N	\N
816	Химия	Нет	9	10	2025-03-31 15:15:00	3	47	40	\N	2025-03-31 14:49:05.381522+03	2025-03-31 15:01:50.408341+03	2025-03-31 14:48:59.348879+03	t	f	\N	\N	\N
811	Отборки	Со склада 6 отд ПДО в 43 цех ПРБ	4	20	2025-03-31 13:30:00	3	33	60	\N	2025-03-31 13:59:48.62222+03	2025-03-31 14:00:43.509936+03	2025-03-31 13:59:34.947419+03	f	f	\N	\N	\N
803	46	46	10	2	2025-03-31 14:00:00	3	56	58	\N	2025-03-31 13:55:12.022246+03	2025-03-31 14:13:46.865123+03	2025-03-31 13:36:00.691405+03	f	f	\N	\N	\N
797	Вода	Забрать пустую воду, привезти полные	5	100	2025-03-31 13:15:00	3	19	58	\N	2025-03-31 13:02:47.27771+03	2025-03-31 13:29:21.524739+03	2025-03-31 13:02:43.6675+03	t	f	\N	\N	\N
815	Вода	В 46/8	5	19	2025-03-31 14:45:00	3	57	58	\N	2025-03-31 14:40:55.584982+03	2025-03-31 15:02:12.087074+03	2025-03-31 14:40:47.899491+03	f	f	\N	\N	\N
795	Детали	С термообработки	1	3	2025-03-31 13:15:00	3	54	62	\N	2025-03-31 12:56:03.086159+03	2025-03-31 13:40:29.65068+03	2025-03-31 12:55:32.561764+03	t	f	\N	\N	\N
812	Угольник	Нет	1	1	2025-03-31 15:00:00	3	47	40	\N	2025-03-31 14:34:14.876221+03	2025-03-31 15:24:34.5669+03	2025-03-31 14:33:44.675292+03	t	f	\N	\N	\N
804	46	46	10	1	2025-03-31 14:00:00	3	56	58	\N	2025-03-31 13:38:39.651597+03	2025-03-31 14:13:53.144597+03	2025-03-31 13:38:14.083546+03	f	f	\N	\N	\N
792	Готовая продукция	Нет	10	50	2025-03-31 12:45:00	3	47	40	\N	2025-03-31 12:35:56.249317+03	2025-03-31 14:17:04.896284+03	2025-03-31 12:35:30.93023+03	t	f	\N	\N	\N
798	Цех 45	Отвезти детали токарю	1	4	2025-03-31 13:15:00	3	67	17	\N	2025-03-31 13:06:48.507704+03	2025-03-31 13:51:12.475048+03	2025-03-31 13:06:23.815574+03	f	f	\N	\N	\N
799	Цех 45	Получить материалы со склада	4	180	2025-03-31 14:00:00	3	67	17	\N	2025-03-31 13:07:47.132053+03	2025-03-31 13:51:29.706448+03	2025-03-31 13:07:37.510368+03	f	f	\N	\N	\N
817	Изделия	С 43 цеха на 59 станцию	10	5	2025-03-31 15:15:00	3	33	60	\N	2025-03-31 15:35:39.924533+03	2025-03-31 15:39:42.051365+03	2025-03-31 15:35:21.370055+03	f	f	\N	\N	\N
813	Трубы	Нет	1	12	2025-03-31 14:45:00	3	72	8	\N	2025-03-31 14:36:06.050273+03	2025-03-31 14:56:28.611107+03	2025-03-31 14:35:48.535519+03	t	f	\N	\N	\N
807	Заготовки	Из заготовки в цех	4	3	2025-03-31 14:00:00	3	57	58	\N	2025-03-31 13:46:51.345766+03	2025-03-31 13:59:46.069214+03	2025-03-31 13:46:19.488084+03	f	f	\N	\N	\N
793	41 цех 6т8020031	Перевезти из корпуса 10 бтк корпуса 6т8020031 в корпус 60/2 на 3 этаж (зачистка после заделки раковин).	1	15	2025-03-31 14:00:00	3	23	8	\N	2025-03-31 12:53:57.072324+03	2025-03-31 14:56:45.118021+03	2025-03-31 12:50:37.988323+03	f	f	\N	\N	\N
818	Изделия	С 43 цеха на 40 станцию	10	5	2025-03-31 15:15:00	3	33	60	\N	2025-03-31 15:37:49.04052+03	2025-03-31 15:39:50.565627+03	2025-03-31 15:37:31.532779+03	f	f	\N	\N	\N
823	Сбыт	С 43 цеха в 79 отдел	10	30	2025-03-31 16:30:00	3	33	60	\N	2025-03-31 16:36:14.979494+03	2025-03-31 16:39:39.805291+03	2025-03-31 16:35:49.714456+03	t	f	\N	\N	\N
800	41-2 цех. Детали	Из 41-2 в 10 корп и 46/12	1	24	2025-03-31 14:00:00	3	39	8	\N	2025-03-31 13:29:27.071842+03	2025-03-31 14:56:58.136908+03	2025-03-31 13:13:41.076603+03	f	f	\N	\N	\N
814	Детали	Из 46/12 в цех	4	4	2025-03-31 14:45:00	3	57	58	\N	2025-03-31 14:38:36.876099+03	2025-03-31 14:39:41.800203+03	2025-03-31 14:38:20.776906+03	f	f	\N	\N	\N
802	46	46	10	3	2025-03-31 14:00:00	3	56	58	\N	2025-03-31 13:37:29.994639+03	2025-03-31 14:40:18.716477+03	2025-03-31 13:34:20.751163+03	f	f	\N	\N	\N
796	41/3-10корп. Отправка деталей	Забрать детали из БТК 10 корп.и отвезти соглано сдат.накладным	1	5	2025-03-31 14:00:00	3	74	8	\N	2025-03-31 13:03:03.14926+03	2025-03-31 14:57:09.064852+03	2025-03-31 13:00:32.500805+03	f	f	\N	\N	\N
822	Детали	Нет	1	20	2025-03-31 15:45:00	3	66	61	\N	2025-03-31 15:47:50.404097+03	2025-03-31 15:49:14.995004+03	2025-03-31 15:47:45.794491+03	t	f	\N	\N	\N
819	Детали	С 43 цеха в 44 цех	1	2	2025-03-31 15:15:00	3	33	60	\N	2025-03-31 15:39:31.698489+03	2025-03-31 15:39:59.663586+03	2025-03-31 15:39:14.889905+03	f	f	\N	\N	\N
840	46	46	9	1	2025-04-01 09:00:00	3	56	58	\N	2025-04-01 08:44:31.224096+03	2025-04-01 09:09:54.145542+03	2025-04-01 08:40:55.362744+03	f	f	\N	\N	\N
825	41	Отправка деталей	1	2	2025-04-01 09:00:00	3	30	8	\N	2025-04-01 08:00:43.156968+03	2025-04-01 09:09:51.459668+03	2025-04-01 08:00:02.949415+03	f	f	\N	\N	\N
1503	Мусор стружка	3 ящика	7	130	2025-04-11 13:00:00	3	69	58	\N	2025-04-11 11:47:20.31404+03	2025-04-11 13:55:41.175922+03	2025-04-11 10:26:32.154706+03	f	f	5	14	57
820	Детали	Нет	1	20	2025-03-31 15:45:00	4	66	\N	\N	\N	\N	2025-03-31 15:47:45.104808+03	t	f	\N	\N	\N
841	Вода	Вода	5	15	2025-04-01 14:30:00	3	51	8	\N	2025-04-01 11:44:40.500241+03	2025-04-01 13:15:57.611708+03	2025-04-01 08:47:12.888537+03	f	f	\N	\N	\N
821	Детали	Нет	1	20	2025-03-31 15:45:00	4	66	\N	\N	\N	\N	2025-03-31 15:47:45.164846+03	t	f	\N	\N	\N
866	Вывоз мусора	Корпус 11 склад Пдо. Забрать мусор	6	70	2025-04-01 14:00:00	3	79	8	\N	2025-04-01 11:09:58.872167+03	2025-04-01 11:23:05.978602+03	2025-04-01 10:42:45.064559+03	f	f	\N	\N	\N
837	41-2 цех. Стружка	Из 50корп в 71	6	50	2025-04-01 09:00:00	3	39	8	\N	2025-04-01 08:44:20.818604+03	2025-04-01 11:46:37.307625+03	2025-04-01 08:37:19.313617+03	f	f	\N	\N	\N
854	Пружина	Нет	10	1	2025-04-01 09:45:00	3	20	58	\N	2025-04-01 09:40:58.818988+03	2025-04-01 09:52:43.297515+03	2025-04-01 09:38:02.619815+03	f	f	\N	\N	\N
861	Ящики	Нет	10	50	2025-04-01 13:00:00	3	78	8	\N	2025-04-01 11:48:28.019788+03	2025-04-01 13:05:38.143668+03	2025-04-01 10:24:40.298242+03	f	f	\N	\N	\N
1476	41/10 детали	Забрать детали из БТК 10корп.и отвезти в 41/60 2уч.	1	2	2025-04-11 08:30:00	3	74	8	\N	2025-04-11 08:01:36.733751+03	2025-04-11 09:14:28.695785+03	2025-04-11 07:57:10.252422+03	f	f	5	25	24
835	Детали	Термообработка	1	14	2025-04-01 09:00:00	3	54	62	\N	2025-04-01 08:27:25.90632+03	2025-04-01 09:07:44.989851+03	2025-04-01 08:26:56.882491+03	t	f	\N	\N	\N
831	41	Литье	1	15	2025-04-01 09:30:00	3	55	8	\N	2025-04-01 08:22:58.387528+03	2025-04-01 09:08:59.898122+03	2025-04-01 08:19:25.065874+03	f	f	\N	\N	\N
830	41-2 цех. Детали	Из 41-2 на 06, 46/12	1	10	2025-04-01 09:00:00	3	39	8	\N	2025-04-01 08:15:05.690708+03	2025-04-01 09:09:17.917498+03	2025-04-01 08:14:54.330725+03	f	f	\N	\N	\N
834	Заготовки	В цех	4	5	2025-04-01 08:30:00	3	57	58	\N	2025-04-01 08:25:50.992955+03	2025-04-01 09:09:39.555057+03	2025-04-01 08:25:40.679115+03	f	f	\N	\N	\N
838	46	46	10	2	2025-04-01 09:00:00	3	56	58	\N	2025-04-01 08:43:43.457391+03	2025-04-01 09:10:04.59231+03	2025-04-01 08:37:35.698413+03	f	f	\N	\N	\N
839	46	46	10	2	2025-04-01 09:00:00	3	56	58	\N	2025-04-01 08:43:56.479406+03	2025-04-01 09:10:13.594743+03	2025-04-01 08:39:00.751266+03	f	f	\N	\N	\N
833	Заготовки	Заготовки на лазер	4	1	2025-04-01 08:30:00	3	57	58	\N	2025-04-01 08:25:06.853527+03	2025-04-01 09:10:20.455906+03	2025-04-01 08:24:11.586053+03	f	f	\N	\N	\N
828	Груз: Вывоз мусора и стружка\n📝 Описание: 2 ящика мусора и 2 ящика стружки	Мусор и стружка	7	67	2025-04-01 09:00:00	3	64	8	\N	2025-04-01 08:39:19.933249+03	2025-04-01 09:10:34.908598+03	2025-04-01 08:08:42.705312+03	f	f	\N	\N	\N
827	10/3-10корп. Отправка деталей	Забрать детали с БТК и уч.промывки и отвезти согласно сдат.накладным	1	15	2025-04-01 08:15:00	3	74	8	\N	2025-04-01 08:04:53.05843+03	2025-04-01 09:11:21.431205+03	2025-04-01 08:04:36.202177+03	f	f	\N	\N	\N
829	Вода	Отвезти пустые и привезти полные	5	360	2025-04-01 09:30:00	3	64	8	\N	2025-04-01 13:15:30.522035+03	2025-04-01 13:16:49.290164+03	2025-04-01 08:14:19.419668+03	f	f	\N	\N	\N
849	Ветошь	Ветошь	9	50	2025-04-01 13:00:00	3	54	62	\N	2025-04-01 09:21:16.641686+03	2025-04-01 13:17:45.072493+03	2025-04-01 09:20:56.529808+03	t	f	\N	\N	\N
1512	Вывезти мусор	Нет	6	30	2025-04-11 13:30:00	1	63	\N	\N	\N	\N	2025-04-11 11:25:59.314374+03	t	f	\N	55	57
836	Фланец	225 шт	1	15	2025-04-01 09:00:00	3	47	40	\N	2025-04-01 08:36:29.538786+03	2025-04-01 09:28:50.490057+03	2025-04-01 08:34:59.927561+03	t	f	\N	\N	\N
845	Цех 45	Отвезти принтер в АСУП	9	3	2025-04-01 09:15:00	3	67	17	\N	2025-04-01 09:16:28.105392+03	2025-04-01 09:36:15.982236+03	2025-04-01 09:16:08.449739+03	f	f	\N	\N	\N
856	Приборы	С 43 цеха в метрологию	8	40	2025-04-01 09:00:00	3	33	60	\N	2025-04-01 09:51:06.457292+03	2025-04-01 10:02:29.555734+03	2025-04-01 09:50:50.607124+03	f	f	\N	\N	\N
857	Платы	С 43 цеха в 58 цех	1	16	2025-04-01 09:00:00	3	33	60	\N	2025-04-01 09:54:01.925512+03	2025-04-01 10:02:37.683133+03	2025-04-01 09:53:45.569344+03	f	f	\N	\N	\N
859	Рекламационные изделия	С 28 отд в 43 цех	10	2	2025-04-01 09:30:00	3	33	60	\N	2025-04-01 10:00:34.690095+03	2025-04-01 10:02:58.944526+03	2025-04-01 10:00:17.783143+03	f	f	\N	\N	\N
846	Цех 45	Получить хозяйственные принадлежности	9	5	2025-04-01 10:00:00	3	67	17	\N	2025-04-01 09:18:00.148831+03	2025-04-01 10:21:30.982318+03	2025-04-01 09:17:37.424958+03	f	f	\N	\N	\N
832	Масло	Получить масло на складе для термички и цеха	9	450	2025-04-01 10:15:00	3	57	58	\N	2025-04-01 08:24:51.503076+03	2025-04-01 10:23:17.206283+03	2025-04-01 08:22:27.93745+03	t	f	\N	\N	\N
1502	Фланец	Забрать с маркировки	1	15	2025-04-11 10:45:00	3	47	40	\N	2025-04-11 10:16:29.157677+03	2025-04-11 12:54:24.197502+03	2025-04-11 10:16:00.66371+03	t	f	5	51	52
848	Хоз.товары	Мыло	9	20	2025-04-01 10:00:00	3	54	62	\N	2025-04-01 09:19:31.578889+03	2025-04-01 10:27:18.01237+03	2025-04-01 09:18:52.975058+03	t	f	\N	\N	\N
860	Детали	Нет	1	10	2025-04-01 10:15:00	3	66	61	\N	2025-04-01 10:23:50.076456+03	2025-04-01 10:38:53.273301+03	2025-04-01 10:23:47.296833+03	t	f	\N	\N	\N
862	Основание	Нет	1	1	2025-04-01 10:45:00	3	47	40	\N	2025-04-01 10:54:54.000929+03	2025-04-01 11:08:44.934284+03	2025-04-01 10:33:45.838793+03	t	f	\N	\N	\N
1515	41-2 цех. Стружка СРОЧНО	Вывоз стружки	11	150	2025-04-11 12:30:00	3	39	8	\N	2025-04-11 12:13:16.218729+03	2025-04-11 14:31:57.038732+03	2025-04-11 12:12:55.302154+03	t	f	\N	25	57
1507	ПКИ	С 14 отд ПКИ в 43 цех	4	15	2025-04-11 08:30:00	3	33	60	\N	2025-04-11 10:58:00.554657+03	2025-04-11 11:06:31.658491+03	2025-04-11 10:57:48.179+03	f	f	\N	8	31
1496	Мусор	Нет	9	200	2025-04-11 10:00:00	3	47	40	\N	2025-04-11 09:41:35.403884+03	2025-04-11 10:02:09.427506+03	2025-04-11 09:41:24.3304+03	t	f	5	51	57
1510	Изделия	С 43 цеха на 40 уч. Исп.станц.	10	5	2025-04-11 09:45:00	3	33	60	\N	2025-04-11 11:06:15.678629+03	2025-04-11 11:06:46.405338+03	2025-04-11 11:05:58.343708+03	f	f	\N	31	23
1501	Детали	Кондуктор	1	2	2025-04-11 10:30:00	3	54	61	\N	2025-04-11 13:23:46.528754+03	2025-04-11 14:08:23.927808+03	2025-04-11 09:55:01.212705+03	t	f	\N	54	34
1500	Кап ремонт	Забрать с 5-го участка на втором этаже	9	15	2025-04-11 10:30:00	3	47	40	\N	2025-04-11 11:15:33.41223+03	2025-04-11 12:54:54.172981+03	2025-04-11 09:54:18.230028+03	t	f	5	52	41
1498	Цех 45	Отвезти детали токарю	1	5	2025-04-11 13:00:00	3	67	17	\N	2025-04-11 09:46:01.432568+03	2025-04-11 12:53:59.36964+03	2025-04-11 09:44:23.397157+03	f	f	5	37	64
1499	Цех 45	Вывезти мусор	6	150	2025-04-11 13:30:00	3	67	17	\N	2025-04-11 09:48:58.222645+03	2025-04-11 12:54:10.172484+03	2025-04-11 09:48:37.563044+03	f	f	5	37	57
1508	Ремонтные датчики	Забрать ремонтные датчики из 28 отдела (50 корп, 3 этаж) и привезти в 58 цех (1 корп, 116 комната).	10	30	2025-04-11 13:00:00	3	50	40	\N	2025-04-11 11:15:56.612317+03	2025-04-11 14:01:58.770876+03	2025-04-11 10:59:30.819491+03	f	f	5	68	51
872	Забрать детали с лазера	Забрать детали с лазера, отвезти в основной корпус	1	5	2025-04-01 12:15:00	3	19	58	\N	2025-04-01 11:16:47.322812+03	2025-04-01 12:44:02.986345+03	2025-04-01 11:15:11.822983+03	f	f	\N	\N	\N
826	41	Межоперационка\nТрубки от Тамары на шлифовка в литейку	1	3	2025-04-01 10:30:00	3	30	8	\N	2025-04-01 08:02:40.71741+03	2025-04-01 09:08:49.217735+03	2025-04-01 08:01:47.460871+03	f	f	\N	\N	\N
865	Деталь	Вакуумная калка	1	5	2025-04-01 10:45:00	3	54	62	\N	2025-04-01 10:38:13.752147+03	2025-04-01 11:06:59.625683+03	2025-04-01 10:37:42.459114+03	t	f	\N	\N	\N
864	Ручка	Нет	1	1	2025-04-01 11:00:00	3	47	62	\N	2025-04-01 10:49:35.005889+03	2025-04-01 11:11:25.991007+03	2025-04-01 10:35:24.049268+03	t	f	\N	\N	\N
870	Заготовки	В цех	4	2	2025-04-01 11:00:00	3	57	58	\N	2025-04-01 11:00:42.735845+03	2025-04-01 11:12:43.382948+03	2025-04-01 11:00:22.742239+03	f	f	\N	\N	\N
868	Детали	Из 46/8 в цех	1	1	2025-04-01 11:00:00	3	57	58	\N	2025-04-01 10:54:18.704638+03	2025-04-01 11:12:50.332446+03	2025-04-01 10:53:51.775187+03	f	f	\N	\N	\N
843	Металл	Лист не большой	4	80	2025-04-01 09:30:00	3	69	8	\N	2025-04-01 09:03:26.000205+03	2025-04-01 09:29:27.042148+03	2025-04-01 08:59:10.12211+03	t	f	\N	\N	\N
881	Вода	Вода	5	130	2025-04-01 14:00:00	3	54	62	\N	2025-04-01 12:51:17.100432+03	2025-04-01 14:39:22.431816+03	2025-04-01 12:51:08.188795+03	t	f	\N	\N	\N
853	Прокладка	1 этаж	10	1	2025-04-01 09:45:00	3	20	58	\N	2025-04-01 09:40:52.951106+03	2025-04-01 09:52:49.767278+03	2025-04-01 09:37:26.149013+03	f	f	\N	\N	\N
869	Заготовки	На лазер	4	2	2025-04-01 11:00:00	3	57	58	\N	2025-04-01 10:59:53.075537+03	2025-04-01 11:14:15.103378+03	2025-04-01 10:59:08.074173+03	f	f	\N	\N	\N
855	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	12	2025-04-01 08:30:00	3	33	60	\N	2025-04-01 09:46:23.050526+03	2025-04-01 10:01:55.87441+03	2025-04-01 09:46:07.031371+03	f	f	\N	\N	\N
858	Изделия	С 43 цеха в 28 отд	10	8	2025-04-01 09:00:00	3	33	60	\N	2025-04-01 09:58:12.190982+03	2025-04-01 10:02:45.903344+03	2025-04-01 09:57:56.422397+03	f	f	\N	\N	\N
847	Цех 45	Получить силиконовую смазку	9	1.5	2025-04-01 10:15:00	3	67	17	\N	2025-04-01 09:19:06.96142+03	2025-04-01 10:21:54.702738+03	2025-04-01 09:18:52.6272+03	f	f	\N	\N	\N
850	ДСМК8А-47 (3 шт.)	Забрать из 28 отдела корп.50, 3 этаж и привезти в корп. 1, этаж 1, 116 кабинет.	10	5	2025-04-01 10:00:00	3	50	40	\N	2025-04-01 09:28:12.192378+03	2025-04-01 10:25:57.571571+03	2025-04-01 09:21:49.477868+03	f	f	\N	\N	\N
877	Детали	Нет	1	2	2025-04-01 12:15:00	3	66	58	\N	2025-04-01 12:24:01.930715+03	2025-04-01 12:44:23.606807+03	2025-04-01 12:23:52.138894+03	t	f	\N	\N	\N
842	Растворители	20 канистр	4	200	2025-04-01 10:00:00	3	34	61	\N	2025-04-01 08:53:19.785107+03	2025-04-01 10:39:25.544598+03	2025-04-01 08:52:53.600476+03	t	f	\N	\N	\N
851	Заготовки	Нет	9	2	2025-04-01 09:15:00	3	66	61	\N	2025-04-01 09:23:11.897913+03	2025-04-01 10:40:04.622258+03	2025-04-01 09:23:08.320132+03	t	f	\N	\N	\N
852	Знаки заводские	Нет	1	0.5	2025-04-01 09:15:00	3	66	61	\N	2025-04-01 09:28:39.620848+03	2025-04-01 10:40:29.455024+03	2025-04-01 09:27:32.323382+03	t	f	\N	\N	\N
863	Забрать с термички детали	Забрать детали с термички	1	1	2025-04-01 10:45:00	3	19	58	\N	2025-04-01 10:34:26.987569+03	2025-04-01 10:52:53.426338+03	2025-04-01 10:34:19.479324+03	t	f	\N	\N	\N
888	41-2 цех. Детали	Из 41-2 в 44	1	10	2025-04-01 14:00:00	3	39	8	\N	2025-04-01 13:56:59.574197+03	2025-04-01 14:35:24.800458+03	2025-04-01 13:29:51.445271+03	f	f	\N	\N	\N
884	437 фланцы	Забрать с 46/12 50 корпус, отвезти в 41ц	1	40	2025-04-01 13:15:00	3	19	8	\N	2025-04-01 13:05:16.341306+03	2025-04-01 14:35:42.240225+03	2025-04-01 13:03:41.401981+03	t	f	\N	\N	\N
873	Сбыт	С упаковки 43 цеха на склад 79 отд	10	100	2025-04-01 11:00:00	3	33	60	\N	2025-04-01 11:43:09.833638+03	2025-04-01 11:45:58.913181+03	2025-04-01 11:42:53.951205+03	f	f	\N	\N	\N
882	45 цех	Отправка формы в 61 цех	8	60	2025-04-01 14:00:00	3	80	17	\N	2025-04-01 12:58:43.409554+03	2025-04-01 14:39:10.441082+03	2025-04-01 12:56:12.403422+03	f	f	\N	\N	\N
867	Вода	В корпус 11 склад пдо	5	60	2025-04-02 15:00:00	3	79	8	\N	2025-04-02 07:54:51.029146+03	2025-04-02 10:51:12.561992+03	2025-04-01 10:47:10.135102+03	f	t	\N	\N	\N
883	Вода	Описание: Отвезти пустые и привезти полные бутыли с водой	5	360	2025-04-01 13:30:00	3	64	8	\N	2025-04-01 13:12:37.611691+03	2025-04-01 13:16:10.55313+03	2025-04-01 12:57:49.342248+03	f	f	\N	\N	\N
871	Отвезти детали на песок	Забрать 2 детали с цеха, отвезти в 41ц на песок	1	3	2025-04-01 12:00:00	3	19	58	\N	2025-04-01 11:13:23.026377+03	2025-04-01 12:50:11.195768+03	2025-04-01 11:13:05.581656+03	f	f	\N	\N	\N
874	/46	46	10	5	2025-04-01 12:00:00	3	56	58	\N	2025-04-01 11:50:53.872141+03	2025-04-01 12:50:25.197109+03	2025-04-01 11:50:31.030597+03	f	f	\N	\N	\N
875	Патрубок	Нет	1	30	2025-04-01 12:00:00	3	72	58	\N	2025-04-01 11:53:10.111671+03	2025-04-01 12:50:33.354124+03	2025-04-01 11:51:21.531077+03	t	f	\N	\N	\N
885	41	Отправка\n944618            46/12\n6т8236041-05      склад \n6т8236041-20      склад \n6т8627008*       44ц	1	4	2025-04-01 14:00:00	3	30	8	\N	2025-04-01 13:27:54.975732+03	2025-04-01 14:34:58.206706+03	2025-04-01 13:19:12.821622+03	f	f	\N	\N	\N
878	Цех 45	Отвезти детали в 58 цех	1	3	2025-04-01 13:00:00	3	67	17	\N	2025-04-01 12:48:21.153748+03	2025-04-01 13:27:40.968487+03	2025-04-01 12:47:58.690506+03	f	f	\N	\N	\N
880	Цех 45	Отвезти детали на склад ПДО	1	2	2025-04-01 13:30:00	3	67	17	\N	2025-04-01 12:49:29.179617+03	2025-04-01 13:28:08.226105+03	2025-04-01 12:49:11.886103+03	f	f	\N	\N	\N
894	Вода	На заготовку	5	40	2025-04-01 12:30:00	3	57	58	\N	2025-04-01 14:26:51.396746+03	2025-04-01 14:31:04.365156+03	2025-04-01 14:26:40.181411+03	f	f	\N	\N	\N
893	41 цех	Плита  Д16 #65	4	150	2025-04-01 14:30:00	3	70	8	\N	2025-04-01 14:19:51.596171+03	2025-04-01 14:34:32.458734+03	2025-04-01 14:01:37.680299+03	f	f	\N	\N	\N
879	Детали	С термообработки	1	14	2025-04-01 13:30:00	3	54	62	\N	2025-04-01 12:48:40.243804+03	2025-04-01 13:39:49.553741+03	2025-04-01 12:48:09.088687+03	f	f	\N	\N	\N
892	Отборки	Со склада 6 отд ПДО в 43 цех ПРБ	4	15	2025-04-01 13:00:00	3	33	60	\N	2025-04-01 14:00:18.908743+03	2025-04-01 14:00:54.982513+03	2025-04-01 14:00:02.17827+03	f	f	\N	\N	\N
891	Детали	С 43 цеха ПРБ в 44 цех	1	1	2025-04-01 12:30:00	3	33	60	\N	2025-04-01 13:58:15.185326+03	2025-04-01 14:00:38.515033+03	2025-04-01 13:57:59.753931+03	f	f	\N	\N	\N
844	Склад цветных металлов	Получить материал на складе цветных металлов	4	100	2025-04-01 09:30:00	3	70	8	\N	2025-04-01 11:54:05.00713+03	2025-04-02 09:22:11.226717+03	2025-04-01 09:02:37.205105+03	f	f	\N	\N	\N
896	Ярлыки	Отвезти на заготовку	9	1	2025-04-01 15:00:00	3	20	58	\N	2025-04-01 14:48:49.270317+03	2025-04-01 15:02:12.002741+03	2025-04-01 14:48:38.443751+03	t	f	\N	\N	\N
889	46	46	10	5	2025-04-01 14:00:00	3	56	58	\N	2025-04-01 13:38:00.268148+03	2025-04-01 14:30:38.605747+03	2025-04-01 13:37:17.034507+03	f	f	\N	\N	\N
886	Вода	Нет	5	300	2025-04-02 09:30:00	3	51	8	\N	2025-04-02 07:46:42.523337+03	2025-04-02 10:51:39.252715+03	2025-04-01 13:20:27.459964+03	f	f	\N	\N	\N
890	46	46	10	3	2025-04-01 14:00:00	3	56	58	\N	2025-04-01 13:39:48.05499+03	2025-04-01 14:30:50.802744+03	2025-04-01 13:39:25.578192+03	f	f	\N	\N	\N
887	41	Межоперационка \n6т8601055\n6т8601050\n6в8602132\nОтвезти в кладовую на 3 этаж  к Татьяне Юрьевны	1	5	2025-04-01 14:00:00	3	30	8	\N	2025-04-01 13:25:01.622016+03	2025-04-01 14:34:45.516821+03	2025-04-01 13:23:02.617896+03	f	f	\N	\N	\N
897	Забрать сош	Забрать сош	9	10	2025-04-01 15:00:00	3	19	58	\N	2025-04-01 14:49:52.834511+03	2025-04-01 15:16:59.466735+03	2025-04-01 14:49:38.320545+03	f	f	\N	\N	\N
895	Детали	Нет	1	3	2025-04-01 14:30:00	3	66	40	\N	2025-04-01 14:29:41.178508+03	2025-04-01 15:17:16.431967+03	2025-04-01 14:29:20.775432+03	t	f	\N	\N	\N
933	Бытовые отходы	Отходы	6	15	2025-04-02 09:45:00	3	54	62	\N	2025-04-02 09:41:26.432086+03	2025-04-02 10:48:32.882961+03	2025-04-02 09:40:47.682626+03	t	f	\N	\N	\N
918	Детали	Детали	1	10	2025-04-02 09:00:00	3	79	8	\N	2025-04-02 08:38:57.436478+03	2025-04-02 09:20:45.50662+03	2025-04-02 08:38:49.229217+03	f	f	\N	\N	\N
921	Детали	Пескоструй	1	1	2025-04-02 09:15:00	3	54	62	\N	2025-04-02 08:47:31.730709+03	2025-04-02 09:38:16.647491+03	2025-04-02 08:47:00.348666+03	t	f	\N	\N	\N
899	Молоко	Нет	9	550	2025-04-02 09:00:00	3	47	40	\N	2025-04-01 15:21:43.413824+03	2025-04-01 15:23:33.642124+03	2025-04-01 14:57:44.540699+03	f	f	\N	\N	\N
901	Молоко	Нет	9	550	2025-04-02 09:00:00	3	47	40	\N	2025-04-01 15:20:57.569338+03	2025-04-01 15:24:18.932169+03	2025-04-01 14:57:44.752527+03	f	f	\N	\N	\N
902	Молоко	Нет	9	550	2025-04-02 09:00:00	3	47	40	\N	2025-04-01 15:18:43.388808+03	2025-04-01 15:24:30.398217+03	2025-04-01 14:57:44.753599+03	f	f	\N	\N	\N
900	Молоко	Нет	9	550	2025-04-02 09:00:00	3	47	40	\N	2025-04-01 15:21:14.317983+03	2025-04-01 15:24:59.947839+03	2025-04-01 14:57:44.751214+03	f	f	\N	\N	\N
906	Детали	С 43 цеха в 44 цех	1	3	2025-04-01 15:15:00	3	33	60	\N	2025-04-01 15:58:47.119644+03	2025-04-01 15:59:00.904204+03	2025-04-01 15:58:28.425154+03	f	f	\N	\N	\N
904	Детали	Нет	1	30	2025-04-01 15:30:00	3	66	61	\N	2025-04-01 15:35:26.156087+03	2025-04-01 16:00:48.027261+03	2025-04-01 15:35:22.512467+03	t	f	\N	\N	\N
911	Цех 45	Привезти бельё из стирки	9	3	2025-04-02 08:15:00	3	67	17	\N	2025-04-02 08:24:17.989143+03	2025-04-02 08:24:57.345992+03	2025-04-02 08:24:00.102117+03	f	f	\N	\N	\N
914	Материал	Забрать у Галины Степановны резину	4	3	2025-04-02 09:00:00	3	57	58	\N	2025-04-02 08:32:59.734868+03	2025-04-02 09:50:27.470852+03	2025-04-02 08:32:22.053974+03	f	f	\N	\N	\N
930	Трубы d25	Трубы 3м ,2 шт	4	10	2025-04-02 09:30:00	3	32	61	\N	2025-04-02 09:19:46.068035+03	2025-04-02 09:31:15.616616+03	2025-04-02 09:19:42.89051+03	t	f	\N	\N	\N
907	Заготовка	На лазер	4	0.5	2025-04-02 08:00:00	3	57	58	\N	2025-04-02 08:26:00.654933+03	2025-04-02 09:52:18.603873+03	2025-04-02 07:57:28.595832+03	f	f	\N	\N	\N
910	Вывезти упаковочный бумагу с участка	Вывезти упаковочную бумагу с лазерного участка, отвезти на утильбазу	7	10	2025-04-02 08:30:00	3	19	62	\N	2025-04-02 08:21:15.505448+03	2025-04-02 08:41:42.946206+03	2025-04-02 08:03:30.681223+03	f	f	\N	\N	\N
929	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	10	2025-04-02 08:30:00	3	33	60	\N	2025-04-02 09:19:42.881045+03	2025-04-02 09:22:59.663931+03	2025-04-02 09:19:26.46395+03	f	f	\N	\N	\N
919	Детали	Термообработка	1	3	2025-04-02 09:00:00	3	54	62	\N	2025-04-02 08:44:05.417746+03	2025-04-02 09:22:44.478756+03	2025-04-02 08:43:47.72642+03	t	f	\N	\N	\N
924	41-2 цех. Мусор СРОЧНО	41-2 на 71	7	50	2025-04-02 09:15:00	3	39	8	\N	2025-04-02 09:08:46.559313+03	2025-04-02 10:51:51.308472+03	2025-04-02 08:54:50.871874+03	t	f	\N	\N	\N
925	41-2 цех. Мусор СРОЧНО	Из 10 корп в 71	7	50	2025-04-02 09:15:00	3	39	8	\N	2025-04-02 10:52:07.574572+03	2025-04-02 11:38:55.282357+03	2025-04-02 08:55:57.228619+03	t	f	\N	\N	\N
916	Спецодежда	Нет	9	5	2025-04-02 08:30:00	3	66	61	\N	2025-04-02 08:36:41.284396+03	2025-04-02 08:48:02.649671+03	2025-04-02 08:36:36.418212+03	t	f	\N	\N	\N
908	Заготовки	В цех	4	3	2025-04-02 08:00:00	3	57	58	\N	2025-04-02 08:26:16.592163+03	2025-04-02 08:53:42.208297+03	2025-04-02 07:58:43.754051+03	f	f	\N	\N	\N
920	6л8650179	Нет	1	0.5	2025-04-02 08:45:00	3	66	8	\N	2025-04-02 08:44:56.332386+03	2025-04-02 09:21:02.94648+03	2025-04-02 08:44:53.760543+03	t	f	\N	\N	\N
898	Молоко	Нет	9	550	2025-04-02 09:00:00	3	47	40	\N	2025-04-01 15:21:28.845341+03	2025-04-02 09:07:19.206832+03	2025-04-01 14:57:44.533456+03	f	f	\N	\N	\N
905	6л8650179	Нет	1	0.5	2025-04-01 15:45:00	4	66	\N	\N	\N	\N	2025-04-01 15:37:35.526691+03	t	f	\N	\N	\N
913	41-2 цех. Детали	Из 41-2 в 44 и 06	1	7	2025-04-02 09:00:00	3	39	8	\N	2025-04-02 08:31:24.385821+03	2025-04-02 09:20:01.001875+03	2025-04-02 08:31:07.096567+03	f	f	\N	\N	\N
927	Вода	Отвезти пустые привезти полные с водой	5	120	2025-04-02 09:00:00	3	64	8	\N	2025-04-02 08:59:47.194428+03	2025-04-02 09:20:27.407746+03	2025-04-02 08:59:26.291987+03	f	f	\N	\N	\N
909	41/3-10 корп. Отправка деталей	Забрать детали с бтк и уч.промывки и отвезти согласно сдат.накладным	1	20	2025-04-02 08:15:00	3	74	8	\N	2025-04-02 08:00:07.718674+03	2025-04-02 09:21:33.532324+03	2025-04-02 07:59:17.751307+03	f	f	\N	\N	\N
931	Халаты спец одежда	С прачечной в 43 цех	9	15	2025-04-02 08:30:00	3	33	60	\N	2025-04-02 09:22:09.276674+03	2025-04-02 09:23:10.735949+03	2025-04-02 09:21:50.428191+03	f	f	\N	\N	\N
934	Стол	Нет	9	10	2025-04-02 10:00:00	3	20	58	\N	2025-04-02 09:50:45.359839+03	2025-04-02 10:48:43.373982+03	2025-04-02 09:50:30.140518+03	f	f	\N	\N	\N
932	Пруток Д-16	Получение прутка Д-16  круг 160 на складе цветных металлов	4	166	2025-04-02 10:00:00	3	64	8	\N	2025-04-02 09:40:24.860383+03	2025-04-02 10:51:25.166725+03	2025-04-02 09:35:09.157688+03	t	f	\N	\N	\N
912	Детали с лазера	Забрать с лазерного участка, привезти в основной корпус	1	10	2025-04-02 09:15:00	3	19	58	\N	2025-04-02 08:28:08.794577+03	2025-04-02 09:50:18.973867+03	2025-04-02 08:28:00.738096+03	f	f	\N	\N	\N
922	Трубка.	Нет	4	1	2025-04-02 10:00:00	3	47	40	\N	2025-04-02 08:47:56.540194+03	2025-04-02 10:52:11.613055+03	2025-04-02 08:47:50.420654+03	t	f	\N	\N	\N
917	46	46	10	3	2025-04-02 09:00:00	3	56	58	\N	2025-04-02 08:39:50.451519+03	2025-04-02 09:51:27.063447+03	2025-04-02 08:37:38.881354+03	f	f	\N	\N	\N
915	46	46	10	5	2025-04-02 09:00:00	3	56	58	\N	2025-04-02 08:40:00.10594+03	2025-04-02 09:52:11.01368+03	2025-04-02 08:35:13.267574+03	f	f	\N	\N	\N
876	Вода	Вода для цеха 946 и участок 40	5	200	2025-04-01 14:30:00	3	14	40	\N	2025-04-01 14:07:12.766541+03	2025-04-02 10:00:36.847976+03	2025-04-01 12:07:53.400734+03	f	f	\N	\N	\N
903	Вода	Нет	5	200	2025-04-02 09:00:00	3	47	40	\N	2025-04-01 15:18:31.653365+03	2025-04-02 10:01:07.365256+03	2025-04-01 15:17:33.507214+03	f	f	\N	\N	\N
923	6т6234026-35	Нет	1	10	2025-04-02 08:45:00	3	66	40	\N	2025-04-02 10:57:20.415497+03	2025-04-02 11:38:32.782388+03	2025-04-02 08:54:36.33778+03	t	f	\N	\N	\N
926	41-2 цех. Мусор СРОЧНО	Из 50 Корп в 71	7	50	2025-04-02 09:15:00	3	39	61	\N	2025-04-02 11:42:13.23374+03	2025-04-02 11:42:43.654818+03	2025-04-02 08:56:49.446747+03	t	f	\N	\N	\N
940	41	Литье	1	10	2025-04-02 14:00:00	3	55	8	\N	2025-04-02 11:39:08.58118+03	2025-04-02 11:50:22.823214+03	2025-04-02 11:17:03.249946+03	f	f	\N	\N	\N
928	Магнит	Нет	1	1	2025-04-02 10:15:00	3	47	62	AgACAgIAAxkBAALHXGfs1LZd7ODroO6fMumgL1gN0csAAznxMRuw6GFL2orEwyLlzY8BAAMCAAN5AAM2BA	2025-04-02 09:46:17.975975+03	2025-04-02 10:48:05.400443+03	2025-04-02 09:10:08.27785+03	t	f	\N	\N	\N
943	46	46	10	5	2025-04-02 12:00:00	3	56	58	\N	2025-04-02 11:51:36.721035+03	2025-04-02 12:40:45.876287+03	2025-04-02 11:47:14.088674+03	f	f	\N	\N	\N
936	Шкалы	Нет	1	1	2025-04-02 10:30:00	3	47	40	\N	2025-04-02 10:00:16.77635+03	2025-04-02 10:51:59.299882+03	2025-04-02 09:58:00.281466+03	t	f	\N	\N	\N
968	Детали	Детали	1	10	2025-04-02 14:00:00	3	79	40	\N	2025-04-02 13:57:32.986439+03	2025-04-02 14:25:06.297165+03	2025-04-02 13:56:45.342661+03	t	f	\N	\N	\N
938	Вода	С 43 цеха пустые Бутыли на склад воды	5	11	2025-04-02 09:30:00	3	33	60	\N	2025-04-02 10:55:49.698208+03	2025-04-02 10:59:35.622026+03	2025-04-02 10:55:31.979019+03	f	f	\N	\N	\N
939	Вода	Со склада воды в 43 цех	5	440	2025-04-02 10:00:00	3	33	60	\N	2025-04-02 10:59:15.154775+03	2025-04-02 10:59:45.538501+03	2025-04-02 10:58:58.016808+03	f	f	\N	\N	\N
937	6т8626344-ые трубы	Аварийно!	1	5	2025-04-02 10:45:00	3	66	40	\N	2025-04-02 10:50:49.683448+03	2025-04-02 11:38:23.247715+03	2025-04-02 10:49:20.481962+03	t	f	\N	\N	\N
950	Тара для 41 цеха	Ящики,коробки	9	15	2025-04-02 12:30:00	3	47	8	\N	2025-04-02 12:39:23.086197+03	2025-04-02 12:45:26.60513+03	2025-04-02 12:17:36.180065+03	t	f	\N	\N	\N
963	41	Отправка\n944618       46/12\n0366729    46/8\n0151196    46/8\n6т8652024   46/12\n6т8652024-01  46/12\n6т8229145       44\n923952             44	1	10	2025-04-02 14:00:00	3	30	8	\N	2025-04-02 13:50:47.744208+03	2025-04-03 08:02:29.809794+03	2025-04-02 13:43:24.129743+03	f	f	\N	\N	\N
949	Ярлык	Нет	9	1	2025-04-02 12:00:00	3	20	58	\N	2025-04-02 12:19:23.824646+03	2025-04-02 13:31:13.212715+03	2025-04-02 12:17:15.563838+03	f	f	\N	\N	\N
951	Заготовки	В цех	4	1	2025-04-02 12:30:00	3	57	58	\N	2025-04-02 12:20:40.642583+03	2025-04-02 13:10:18.967761+03	2025-04-02 12:20:24.763628+03	f	f	\N	\N	\N
961	41/3 10корп.Отправка деталей	Забрать детали с БТК и отвезти согласно сдат.накладным	1	10	2025-04-02 14:00:00	3	74	8	\N	2025-04-02 13:38:46.911259+03	2025-04-03 08:02:54.691094+03	2025-04-02 13:25:24.633319+03	f	f	\N	\N	\N
948	Канистры ,быт отходы	Нет	7	50	2025-04-02 12:15:00	3	32	61	\N	2025-04-02 12:00:56.682186+03	2025-04-02 12:15:31.441892+03	2025-04-02 12:00:51.135673+03	t	f	\N	\N	\N
946	Две трубы d25 3,4 m	Нет	4	10	2025-04-02 12:00:00	3	32	61	\N	2025-04-02 11:58:09.634704+03	2025-04-02 12:16:13.80914+03	2025-04-02 11:58:06.173066+03	t	f	\N	\N	\N
956	46	46	9	1	2025-04-02 13:15:00	3	56	58	\N	2025-04-02 13:12:25.150218+03	2025-04-02 13:31:21.701702+03	2025-04-02 13:12:19.186916+03	f	f	\N	\N	\N
944	46	46	10	3	2025-04-02 12:00:00	3	56	58	\N	2025-04-02 11:49:44.088404+03	2025-04-02 13:31:39.622796+03	2025-04-02 11:48:32.318462+03	f	f	\N	\N	\N
942	46	46	10	3	2025-04-02 12:00:00	3	56	58	\N	2025-04-02 11:49:56.994954+03	2025-04-02 13:31:46.588913+03	2025-04-02 11:45:58.110411+03	f	f	\N	\N	\N
941	Тара	Из цеха 52 (деревообрабатывающий) в цех 41 ( 10 корпус, ворота, ЧПУ)	9	200	2025-04-02 12:30:00	3	9	8	AgACAgIAAxkBAALLPWfs-E1p4jErOfeW3Ug0MVmvOL4-AAJv9jEbG5JpSxzO84St8o_pAQADAgADeQADNgQ	2025-04-02 11:46:41.213904+03	2025-04-02 12:37:32.43871+03	2025-04-02 11:42:16.308789+03	t	f	\N	\N	\N
947	46	46	10	2	2025-04-02 12:00:00	3	56	58	\N	2025-04-02 12:01:33.973524+03	2025-04-02 13:31:53.288729+03	2025-04-02 12:00:46.937433+03	f	f	\N	\N	\N
945	Вода	Заменить пустые бутылки с водой	5	100	2025-04-02 12:15:00	3	19	58	\N	2025-04-02 11:55:18.625565+03	2025-04-02 12:40:27.922754+03	2025-04-02 11:55:00.060008+03	f	f	\N	\N	\N
954	Детали	В цех	4	2	2025-04-02 12:45:00	3	57	58	\N	2025-04-02 12:41:00.025705+03	2025-04-02 13:10:53.832273+03	2025-04-02 12:40:37.087412+03	f	f	\N	\N	\N
952	Детали	В цех	4	5	2025-04-02 12:30:00	3	57	58	\N	2025-04-02 12:22:24.513263+03	2025-04-02 13:11:13.827365+03	2025-04-02 12:21:51.085033+03	f	f	\N	\N	\N
971	Заготовки	На лазер	4	3	2025-04-02 14:15:00	3	57	58	\N	2025-04-02 14:06:48.160116+03	2025-04-03 09:03:30.561799+03	2025-04-02 14:06:37.036432+03	f	f	\N	\N	\N
958	41/3-10корп. Детали с промывки	Забрать 14ящ с уч.промывки 41/60 и отвезти в 41/10	1	40	2025-04-02 13:45:00	3	74	8	\N	2025-04-02 13:23:44.289548+03	2025-04-03 08:03:53.935204+03	2025-04-02 13:23:27.964711+03	f	f	\N	\N	\N
953	Цех 45	Отвезти детали на склад ПДО	1	7	2025-04-02 13:00:00	3	67	17	\N	2025-04-02 12:26:04.400605+03	2025-04-02 13:19:56.455537+03	2025-04-02 12:25:40.936098+03	f	f	\N	\N	\N
967	46	46	10	1	2025-04-02 14:00:00	3	56	58	\N	2025-04-02 13:53:26.740678+03	2025-04-03 09:02:08.7215+03	2025-04-02 13:53:18.640026+03	f	f	\N	\N	\N
970	Детали	С 44 цеха в 43 цех	1	5	2025-04-02 12:30:00	3	33	60	\N	2025-04-02 14:05:12.835937+03	2025-04-02 14:09:58.839355+03	2025-04-02 14:04:41.130268+03	f	f	\N	\N	\N
957	41-2 цех. Детали	Из 41-2 в 06 и 10 корп	1	10	2025-04-02 13:45:00	3	39	8	\N	2025-04-02 13:19:14.272765+03	2025-04-03 08:03:33.915039+03	2025-04-02 13:17:48.459265+03	f	f	\N	\N	\N
964	41	Отправка\n0367454	1	1	2025-04-02 14:00:00	3	30	8	\N	2025-04-02 13:50:37.52925+03	2025-04-03 08:01:34.517086+03	2025-04-02 13:44:34.858212+03	f	f	\N	\N	\N
966	Кожух	После травления	1	3	2025-04-02 13:45:00	3	66	58	\N	2025-04-02 13:52:49.362513+03	2025-04-03 09:02:35.403935+03	2025-04-02 13:52:32.045214+03	t	f	\N	\N	\N
1497	Мусор	Нет	9	200	2025-04-11 10:15:00	3	47	40	\N	2025-04-11 09:42:18.754245+03	2025-04-11 12:29:20.155287+03	2025-04-11 09:42:16.146757+03	t	f	5	53	57
969	Детали	С 43 цеха в 44 цех	1	80	2025-04-02 12:15:00	3	33	60	\N	2025-04-02 14:02:47.490071+03	2025-04-02 14:03:18.116765+03	2025-04-02 14:02:04.994104+03	f	f	\N	\N	\N
972	Отборки	Со склада 6 ПДО в 43 цех	4	1	2025-04-02 12:45:00	3	33	60	\N	2025-04-02 14:07:24.181751+03	2025-04-02 14:10:16.317146+03	2025-04-02 14:06:47.950673+03	f	f	\N	\N	\N
973	Мусор	С 43 цеха на утиль базу	7	100	2025-04-02 13:00:00	3	33	60	\N	2025-04-02 14:09:22.927432+03	2025-04-02 14:11:00.414467+03	2025-04-02 14:09:05.834424+03	f	f	\N	\N	\N
955	Детали	С термообработки	1	3	2025-04-02 13:00:00	3	54	62	\N	2025-04-02 12:50:58.163907+03	2025-04-02 14:08:28.812591+03	2025-04-02 12:50:15.92641+03	f	f	\N	\N	\N
959	Отвезти мерительный инструмент в лабораторию	Нет	4	5	2025-04-02 13:30:00	3	63	62	\N	2025-04-02 13:24:01.967629+03	2025-04-02 14:09:12.95838+03	2025-04-02 13:23:47.75034+03	t	f	\N	\N	\N
960	Отвезти отходы на утильбазу	Нет	6	60	2025-04-02 13:30:00	3	63	62	\N	2025-04-02 13:25:11.424588+03	2025-04-02 14:09:26.916838+03	2025-04-02 13:24:55.647919+03	t	f	\N	\N	\N
962	Привезти материал	Нет	4	200	2025-04-02 14:00:00	3	63	62	\N	2025-04-02 13:26:44.275972+03	2025-04-02 14:20:24.827772+03	2025-04-02 13:26:25.323125+03	t	f	\N	\N	\N
974	Изделия	С 43 цеха на 59 станцию	10	20	2025-04-02 15:15:00	3	33	60	\N	2025-04-02 14:12:47.735951+03	2025-04-02 15:25:25.507802+03	2025-04-02 14:12:21.487924+03	f	f	\N	\N	\N
978	41 цех	Отвезти тару из 10 корпуса в 50й, тара стоит у гаражной двери	9	50	2025-04-03 10:00:00	3	59	40	AgACAgIAAxkBAALSVmftQwABqijsTDZoIF3PDcmIJBQTVAAC7vcxG_0tcUv4uN7gmo4bUAEAAwIAA3kAAzYE	2025-04-03 09:13:41.638178+03	2025-04-03 10:18:12.118969+03	2025-04-02 17:01:20.038886+03	f	f	\N	\N	\N
975	Детали лазер	Забрать с лазерного участка, отвезти в корпус основной	1	12	2025-04-02 15:15:00	3	19	62	AgACAgIAAxkBAALRo2ftKQ6PIRyxU8DtN8ct3AvaDqCKAAJO8DEbbppoS8gP5Zcm-mIhAQADAgADeQADNgQ	2025-04-02 15:10:35.795703+03	2025-04-02 15:27:53.461988+03	2025-04-02 15:09:59.769343+03	t	f	\N	\N	\N
977	Детали	Нет	1	5	2025-04-02 15:30:00	3	66	61	\N	2025-04-02 15:29:59.411726+03	2025-04-02 16:08:03.095206+03	2025-04-02 15:29:56.038577+03	t	f	\N	\N	\N
985	Заготовки	В цех	4	25	2025-04-03 08:30:00	3	57	58	\N	2025-04-03 08:29:02.368218+03	2025-04-03 09:04:14.135569+03	2025-04-03 08:27:56.76141+03	f	f	\N	\N	\N
976	Забрать странные вещи из прачечной	Забрать старинные вещи из прачечной	9	5	2025-04-03 10:00:00	3	42	8	\N	2025-04-03 06:58:17.177136+03	2025-04-03 07:56:35.612131+03	2025-04-02 15:15:08.771748+03	f	f	\N	\N	\N
965	41	Межоперационка \n6л7770016\n6т8626156-58\nНа 3 этаж к Березиной в кладовую	1	5	2025-04-02 14:00:00	3	30	8	\N	2025-04-02 13:50:18.266118+03	2025-04-03 08:00:58.736792+03	2025-04-02 13:46:38.924153+03	f	f	\N	\N	\N
980	Молоко	Нет	9	500	2025-04-03 09:00:00	3	47	40	\N	2025-04-03 07:55:48.557182+03	2025-04-03 09:22:50.148126+03	2025-04-03 07:54:31.546262+03	t	f	\N	\N	\N
982	Вывоз мусора и стружки	Два ящика	7	27	2025-04-03 09:00:00	3	64	8	\N	2025-04-03 08:19:03.637502+03	2025-04-03 09:23:05.599047+03	2025-04-03 08:08:00.697823+03	f	f	\N	\N	\N
979	41/3 10 корп. Отправка деталей	Забрать детали из 10корп. БТК и отвезти согласно сдат.накладным	1	10	2025-04-03 08:30:00	3	74	8	\N	2025-04-03 07:43:16.603353+03	2025-04-03 09:24:25.413375+03	2025-04-03 07:27:11.478904+03	f	f	\N	\N	\N
984	Заготовки	На лазер	4	3	2025-04-03 08:30:00	3	57	62	\N	2025-04-03 08:27:08.103931+03	2025-04-03 08:42:28.168014+03	2025-04-03 08:21:36.824707+03	f	f	\N	\N	\N
1002	41	Ветошь из 10 корп в 60/2 2 участок	9	20	2025-04-03 10:30:00	3	42	8	\N	2025-04-03 10:00:21.52331+03	2025-04-03 10:06:35.915964+03	2025-04-03 09:44:01.222391+03	f	f	\N	\N	\N
992	Вещи	Вещи стирать	9	5	2025-04-03 09:00:00	3	34	61	\N	2025-04-03 09:26:08.595881+03	2025-04-03 09:26:46.84772+03	2025-04-03 08:47:35.231159+03	t	f	\N	\N	\N
1008	Детали	Нет	1	10	2025-04-03 10:30:00	3	66	61	\N	2025-04-03 10:43:50.405157+03	2025-04-03 14:31:59.173537+03	2025-04-03 10:43:48.03613+03	t	f	\N	\N	\N
990	Вещи	Вещи стирать	9	5	2025-04-03 09:00:00	3	34	61	\N	2025-04-03 08:47:40.091499+03	2025-04-03 09:08:59.898707+03	2025-04-03 08:47:35.203773+03	t	f	\N	\N	\N
1001	Бумага	Для ксерокса и оберточная	9	15	2025-04-03 09:45:00	3	34	61	\N	2025-04-03 09:39:55.98664+03	2025-04-03 10:41:08.708236+03	2025-04-03 09:39:51.685847+03	t	f	\N	\N	\N
995	ИТ2-2	Аварийно‼️	1	1	2025-04-03 08:45:00	4	66	\N	\N	\N	\N	2025-04-03 08:56:30.786364+03	t	f	\N	\N	\N
993	46	46	10	4	2025-04-03 09:00:00	3	56	58	\N	2025-04-03 08:54:33.961376+03	2025-04-03 09:18:05.758706+03	2025-04-03 08:47:48.213843+03	f	f	\N	\N	\N
996	41 цех	Получить материал на складе , перевезти  в 41 цех 10 корпус	4	100	2025-04-03 09:30:00	3	70	8	\N	2025-04-03 09:20:44.700988+03	2025-04-03 10:18:26.690653+03	2025-04-03 09:03:54.48048+03	f	f	\N	\N	\N
983	Молоко	Привезти в 945цех молоко	9	367	2025-04-03 09:00:00	3	35	8	\N	2025-04-03 08:19:45.060391+03	2025-04-03 09:21:02.291641+03	2025-04-03 08:15:36.364618+03	f	f	\N	\N	\N
1003	Штампы	Нет	10	30	2025-04-03 10:00:00	3	54	62	\N	2025-04-03 09:50:58.622513+03	2025-04-03 10:25:03.540931+03	2025-04-03 09:50:25.701058+03	t	f	\N	\N	\N
981	41-2 цех детали	Из 41-2 в 46/11, 44, 43	1	3	2025-04-03 09:00:00	3	39	8	\N	2025-04-03 08:07:57.098247+03	2025-04-03 09:22:48.409787+03	2025-04-03 08:07:04.483361+03	f	f	\N	\N	\N
991	Вещи	Вещи стирать	9	5	2025-04-03 09:00:00	3	34	61	\N	2025-04-03 09:27:40.64244+03	2025-04-03 09:28:28.938456+03	2025-04-03 08:47:35.207446+03	t	f	\N	\N	\N
997	ИТ2-2	Аварийно❗️❗️❗️	1	1	2025-04-03 09:15:00	3	16	62	\N	2025-04-03 09:10:54.272994+03	2025-04-03 09:29:38.121669+03	2025-04-03 09:04:29.563303+03	t	f	\N	\N	\N
998	Детали	Термообработка	1	3	2025-04-03 09:30:00	3	54	62	\N	2025-04-03 09:26:43.939107+03	2025-04-03 09:36:51.793971+03	2025-04-03 09:11:33.263154+03	t	f	\N	\N	\N
988	Ярлыки	Нет	9	1	2025-04-03 09:00:00	3	20	58	\N	2025-04-03 09:05:01.92419+03	2025-04-03 09:38:43.243577+03	2025-04-03 08:43:13.162847+03	t	f	\N	\N	\N
1031	Реостаты	Нет	1	1	2025-04-03 12:45:00	3	47	40	\N	2025-04-03 12:27:53.385059+03	2025-04-03 13:14:35.29698+03	2025-04-03 12:27:26.730622+03	t	f	\N	\N	\N
1004	Металл, проволка	Металл	4	170	2025-04-03 10:00:00	3	54	62	\N	2025-04-03 09:59:11.640757+03	2025-04-03 10:25:15.590969+03	2025-04-03 09:58:51.480027+03	t	f	\N	\N	\N
1007	Прокладка	Нет	10	1	2025-04-03 10:00:00	3	20	58	\N	2025-04-03 10:05:28.314567+03	2025-04-03 10:52:40.369809+03	2025-04-03 10:05:09.330798+03	t	f	\N	\N	\N
1000	Детали	С 46/8	4	1	2025-04-03 09:45:00	3	57	58	\N	2025-04-03 09:40:12.213997+03	2025-04-03 10:05:46.852764+03	2025-04-03 09:39:41.790986+03	f	f	\N	\N	\N
999	41	Получить материал со склада	4	100	2025-04-03 09:30:00	3	70	8	\N	2025-04-03 09:20:29.175617+03	2025-04-03 10:06:55.828476+03	2025-04-03 09:16:06.835212+03	f	f	\N	\N	\N
986	41-2 цех. Стружка СРОЧНО	Из 10 корпуса в 71 утильбазу	6	300	2025-04-03 08:45:00	3	39	40	\N	2025-04-03 09:22:21.608976+03	2025-04-03 10:18:24.105542+03	2025-04-03 08:29:09.674316+03	t	f	\N	\N	\N
1005	41 цех	Получить со склада цветных металлов , силумин	4	500	2025-04-03 10:30:00	3	70	8	\N	2025-04-03 10:06:07.642606+03	2025-04-03 10:49:48.896129+03	2025-04-03 09:59:26.70701+03	f	f	\N	\N	\N
987	Хоз товары	Забрать с центрального склада 14 отдела хоз товары	9	20	2025-04-03 09:30:00	3	19	58	\N	2025-04-03 08:46:56.408965+03	2025-04-03 12:22:59.687359+03	2025-04-03 08:41:36.699214+03	f	f	\N	\N	\N
1006	Шайба	Нет	10	2	2025-04-03 10:00:00	3	20	58	\N	2025-04-03 10:05:25.91459+03	2025-04-03 10:52:14.742547+03	2025-04-03 10:03:58.492443+03	t	f	\N	\N	\N
1009	Ярлык	Нет	9	1	2025-04-03 12:00:00	3	20	58	\N	2025-04-03 10:51:41.624878+03	2025-04-03 12:22:39.193153+03	2025-04-03 10:49:03.033773+03	t	f	\N	\N	\N
994	Вода	7 бутылок	5	100	2025-04-03 13:30:00	3	69	58	\N	2025-04-03 09:06:24.249185+03	2025-04-03 13:58:39.968761+03	2025-04-03 08:52:32.242681+03	f	f	\N	\N	\N
1012	Вывоз мусора	Нет	7	20	2025-04-03 12:15:00	3	20	58	\N	2025-04-03 11:02:26.3741+03	2025-04-03 12:21:24.108015+03	2025-04-03 11:02:22.444209+03	t	f	\N	\N	\N
1010	Вывоз мусора	Нет	6	50	2025-04-03 11:00:00	3	63	62	\N	2025-04-03 10:49:49.539966+03	2025-04-03 11:15:57.867768+03	2025-04-03 10:49:19.629638+03	t	f	\N	\N	\N
1013	Мусор	Нет	7	22	2025-04-03 12:15:00	3	20	58	\N	2025-04-03 11:03:21.87975+03	2025-04-03 12:20:18.735334+03	2025-04-03 11:03:17.275383+03	t	f	\N	\N	\N
1505	Приспособление	Оснастка	8	2	2025-04-11 11:00:00	1	54	\N	\N	\N	\N	2025-04-11 10:34:21.37228+03	t	f	\N	54	34
1020	Ветошь	С ангара 94 14 отд в 43 цех	4	45	2025-04-03 08:45:00	3	33	60	\N	2025-04-03 11:49:45.220842+03	2025-04-03 12:09:21.119148+03	2025-04-03 11:49:28.972896+03	f	f	\N	\N	\N
1011	Вывоз бытовых отходов	Вывоз бытовых отходов	7	20	2025-04-03 12:00:00	3	19	58	\N	2025-04-03 11:02:20.845007+03	2025-04-03 12:21:45.969048+03	2025-04-03 11:01:58.283208+03	f	f	\N	\N	\N
1015	Вывоз бытовых отходов	Вывоз бытовых отходов с трубного участка	7	12	2025-04-03 12:45:00	3	19	58	\N	2025-04-03 11:04:47.052112+03	2025-04-03 12:46:02.489829+03	2025-04-03 11:04:38.981703+03	f	f	\N	\N	\N
1035	Цех 45	Отвезти детали в 46 цех	1	1	2025-04-03 12:45:00	3	67	17	\N	2025-04-03 12:46:37.719055+03	2025-04-03 13:28:09.774492+03	2025-04-03 12:46:27.709041+03	f	f	\N	\N	\N
1032	Установки проверки поплавков в глицерине	Нет	9	30	2025-04-03 13:00:00	3	32	61	\N	2025-04-03 12:36:07.771619+03	2025-04-03 14:32:52.339425+03	2025-04-03 12:36:04.76965+03	t	f	\N	\N	\N
1482	Плита д16	Со склада цветных металлов забрать плиту д16 #40 и отвезти в 41 (10-2)	4	110	2025-04-11 10:00:00	3	64	8	\N	2025-04-11 08:28:34.914828+03	2025-04-11 09:35:15.234851+03	2025-04-11 08:25:18.090734+03	f	f	5	9	26
1506	41	Отправка\n6л8470428	1	1	2025-04-11 11:00:00	3	30	8	\N	2025-04-11 10:47:21.312917+03	2025-04-11 11:04:01.637018+03	2025-04-11 10:46:19.721282+03	t	f	5	26	35
1495	Черный металл	Нет	4	100	2025-04-11 09:30:00	3	70	8	\N	2025-04-11 10:41:34.074288+03	2025-04-11 14:32:19.969514+03	2025-04-11 09:09:24.895405+03	f	f	5	8	25
1504	41 цех	Из 41 цеха 10 корпус нужно отвезти в 44 цех \nДеталь 6л8.470.428 одна штука	1	0.1	2025-04-11 10:45:00	3	53	8	\N	2025-04-11 10:28:24.959999+03	2025-04-11 11:04:14.343443+03	2025-04-11 10:28:00.493371+03	t	f	\N	25	34
1509	Паяльные станции	С метрологии в 43 цех	8	40	2025-04-11 09:15:00	3	33	60	\N	2025-04-11 11:01:06.570287+03	2025-04-11 11:06:39.537028+03	2025-04-11 11:00:47.744771+03	f	f	\N	16	31
1511	41-2 цех. Детали	Со склада 6ПДО забрать деталь 6л7834336 -51 шт, привезти в кладовую 2 уч. 41цех	1	0.5	2025-04-11 12:30:00	4	39	\N	\N	\N	\N	2025-04-11 11:14:20.919841+03	f	f	\N	2	24
1019	Бумага А4	Со склада 14 отд в заводоуправление	4	55	2025-04-03 08:30:00	3	33	60	\N	2025-04-03 11:47:07.24159+03	2025-04-03 12:09:09.728364+03	2025-04-03 11:46:51.241546+03	f	f	\N	\N	\N
1025	Изделия	С 43 цеха в 59 станцию	10	3	2025-04-03 09:00:00	3	33	60	\N	2025-04-03 12:00:54.765068+03	2025-04-03 12:09:50.863838+03	2025-04-03 12:00:38.806761+03	f	f	\N	\N	\N
1024	Прибор	С 43 цеха в метрологию	8	5	2025-04-03 09:00:00	3	33	60	\N	2025-04-03 11:58:47.326341+03	2025-04-03 12:09:59.906588+03	2025-04-03 11:58:32.168984+03	f	f	\N	\N	\N
1029	Материалы	На лазер	4	2	2025-04-03 12:30:00	3	57	58	\N	2025-04-03 12:23:16.637418+03	2025-04-03 12:37:08.127063+03	2025-04-03 12:23:06.970949+03	f	f	\N	\N	\N
1016	Мусор	Нет	7	10	2025-04-03 12:30:00	3	20	58	\N	2025-04-03 11:05:05.466435+03	2025-04-03 12:45:45.084614+03	2025-04-03 11:04:51.582504+03	t	f	\N	\N	\N
1513	Детали	Магниты	1	8	2025-04-11 13:00:00	2	75	8	\N	2025-04-11 13:42:06.789863+03	\N	2025-04-11 11:50:23.927239+03	f	f	\N	27	54
1485	46	46	10	1	2025-04-11 09:00:00	3	56	58	\N	2025-04-11 11:46:07.307759+03	2025-04-11 13:57:14.06448+03	2025-04-11 08:35:49.134643+03	f	f	\N	43	2
1516	41-2 цех. Детали	Со склада 6 ПДО привезти детали 6л7834330 в кладовую 2уч 41цеха	1	0.5	2025-04-11 14:00:00	3	39	8	\N	2025-04-11 12:24:51.35922+03	2025-04-11 14:29:40.178594+03	2025-04-11 12:23:12.185748+03	f	f	\N	2	24
1514	Ярлык	Нет	9	1	2025-04-11 12:00:00	3	20	58	\N	2025-04-11 12:33:36.552+03	2025-04-11 13:56:39.067985+03	2025-04-11 12:10:25.172137+03	f	f	5	44	38
1017	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	70	2025-04-03 08:30:00	3	33	60	\N	2025-04-03 11:38:44.206948+03	2025-04-03 12:08:51.979245+03	2025-04-03 11:38:28.545672+03	f	f	\N	\N	\N
1018	Х/Б ткань белая	Со склада 14 отд в 43 цех	4	15	2025-04-03 08:30:00	3	33	60	\N	2025-04-03 11:43:19.004293+03	2025-04-03 12:09:00.047738+03	2025-04-03 11:43:02.723312+03	f	f	\N	\N	\N
1028	Химия	Со склада химии 14 отд в 43 цех	4	120	2025-04-03 10:15:00	3	33	60	\N	2025-04-03 12:08:32.020251+03	2025-04-03 12:10:23.769521+03	2025-04-03 12:08:14.052075+03	f	f	\N	\N	\N
935	Стол	Привезти стол с трубного участка в основной корпус	9	20	2025-04-02 12:45:00	3	19	58	\N	2025-04-02 09:51:45.307667+03	2025-04-03 12:35:20.000069+03	2025-04-02 09:51:32.518503+03	f	f	\N	\N	\N
1014	Вывоз бытовых отходов	Вывоз бытовых отходов	7	32	2025-04-03 12:30:00	3	19	58	\N	2025-04-03 11:05:00.609029+03	2025-04-03 12:46:09.25211+03	2025-04-03 11:03:24.30124+03	f	f	\N	\N	\N
1021	Детали с лазера	Забрать детали с лазерного участка	1	6	2025-04-03 12:00:00	3	19	58	\N	2025-04-03 11:50:02.722853+03	2025-04-03 12:46:26.450482+03	2025-04-03 11:49:58.196823+03	t	f	\N	\N	\N
1034	Проволока бухты	Нет	4	90	2025-04-03 13:15:00	3	32	61	\N	2025-04-03 12:45:54.223468+03	2025-04-03 14:32:25.082514+03	2025-04-03 12:45:49.715127+03	t	f	\N	\N	\N
1033	Весы	Нет	9	5	2025-04-03 13:00:00	3	32	61	\N	2025-04-03 12:44:37.75602+03	2025-04-03 14:33:07.768199+03	2025-04-03 12:44:33.425703+03	t	f	\N	\N	\N
1065	Детали	Нет	1	3	2025-04-03 14:45:00	3	66	58	\N	2025-04-03 14:49:16.064507+03	2025-04-03 15:12:44.703818+03	2025-04-03 14:48:53.256668+03	t	f	\N	\N	\N
1022	Платы	С 31 цеха в 43 цех	1	15	2025-04-03 08:45:00	3	33	60	\N	2025-04-03 11:52:14.977951+03	2025-04-03 12:09:34.287815+03	2025-04-03 11:52:00.194499+03	f	f	\N	\N	\N
1023	Паяльные станции	С 43 цеха в метрологию	8	60	2025-04-03 09:00:00	3	33	60	\N	2025-04-03 11:56:48.172186+03	2025-04-03 12:09:43.847973+03	2025-04-03 11:56:31.469546+03	f	f	\N	\N	\N
1026	Изделия	С 59 станции в 43 цех	10	10	2025-04-03 09:30:00	3	33	60	\N	2025-04-03 12:03:23.377903+03	2025-04-03 12:10:08.533201+03	2025-04-03 12:03:08.162228+03	f	f	\N	\N	\N
1027	Коробки пакеты	С 52 цеха в 43 цех на упаковку	9	100	2025-04-03 09:45:00	3	33	60	\N	2025-04-03 12:06:10.34719+03	2025-04-03 12:10:17.008798+03	2025-04-03 12:05:55.763989+03	f	f	\N	\N	\N
989	Заготовки	Забрать заготовки в кол-ве 21 шт из 41 цеха и привезти в 945	1	63	2025-04-03 10:00:00	3	64	8	\N	2025-04-03 09:59:30.765851+03	2025-04-03 12:46:53.207349+03	2025-04-03 08:43:54.78443+03	f	f	\N	\N	\N
1063	Вывоз мусора	Нет	7	300	2025-04-03 14:15:00	3	16	61	\N	2025-04-03 14:36:50.063035+03	2025-04-03 15:24:47.319573+03	2025-04-03 14:36:32.601118+03	f	f	\N	\N	\N
1057	Втулка	Нет	1	2	2025-04-03 13:45:00	3	66	8	\N	2025-04-03 13:48:03.405077+03	2025-04-03 16:13:50.925446+03	2025-04-03 13:47:47.330917+03	t	f	\N	\N	\N
1042	41-2 цех. Детали	41-2 в 46,44	1	25	2025-04-03 13:15:00	3	39	8	\N	2025-04-03 13:10:18.82301+03	2025-04-03 16:13:42.251507+03	2025-04-03 13:10:10.750274+03	f	f	\N	\N	\N
1036	Заготовки	В цех	4	3	2025-04-03 12:45:00	3	57	58	\N	2025-04-03 12:46:53.416094+03	2025-04-03 13:22:12.479097+03	2025-04-03 12:46:42.484534+03	f	f	\N	\N	\N
1030	Заготовки	В цех	4	3	2025-04-03 12:30:00	3	57	58	\N	2025-04-03 12:37:01.411495+03	2025-04-03 13:22:18.465206+03	2025-04-03 12:24:25.78207+03	f	f	\N	\N	\N
1038	Вывезти стружку	Нет	6	100	2025-04-03 13:00:00	3	63	62	\N	2025-04-03 12:48:14.398563+03	2025-04-03 13:23:20.468184+03	2025-04-03 12:47:51.364888+03	t	f	\N	\N	\N
1037	Цех 45	Отвезти детали на склад ПДО	1	5	2025-04-03 13:00:00	3	67	17	\N	2025-04-03 12:47:29.926694+03	2025-04-03 13:28:25.208541+03	2025-04-03 12:47:19.459966+03	f	f	\N	\N	\N
1055	46	46	10	3	2025-04-03 14:00:00	3	56	58	\N	2025-04-03 13:52:25.767787+03	2025-04-03 14:48:30.602032+03	2025-04-03 13:46:30.78003+03	f	f	\N	\N	\N
1040	Детали	Детали для 58 цеха	1	6	2025-04-03 13:30:00	3	79	40	\N	2025-04-03 12:58:34.571969+03	2025-04-03 15:13:36.56635+03	2025-04-03 12:58:12.876114+03	t	f	\N	\N	\N
1048	Кожух с буксами	Нет	2	1	2025-04-03 14:15:00	3	47	40	AgACAgIAAxkBAALet2fuY4ggGDG8k3vSaGf-OhcJGjcjAAJO-TEbn9hwS9UhurIdGG7KAQADAgADeQADNgQ	2025-04-03 13:35:07.532094+03	2025-04-03 14:31:48.738554+03	2025-04-03 13:31:48.701003+03	t	f	\N	\N	\N
1064	41цех	Плита Д16 #65	4	100	2025-04-03 15:00:00	3	70	62	\N	2025-04-03 14:55:00.638995+03	2025-04-03 15:18:12.470988+03	2025-04-03 14:45:31.857504+03	f	f	\N	\N	\N
1041	Крышка	Нет	1	1	2025-04-03 13:15:00	3	47	40	AgACAgIAAxkBAALdemfuXLypv39bgncTkNHpvAV6hzBAAAIe-TEbn9hwS09ARMILvctrAQADAgADeQADNgQ	2025-04-03 13:03:43.313738+03	2025-04-03 14:32:40.587025+03	2025-04-03 13:02:46.98014+03	t	f	\N	\N	\N
1044	41/3-10корп. Отправка деталей	Забрать детали с БТК и уч.промывки	1	30	2025-04-03 13:30:00	3	74	8	\N	2025-04-03 13:16:09.358579+03	2025-04-03 16:13:58.284747+03	2025-04-03 13:14:48.073644+03	f	f	\N	\N	\N
1052	Детали	Нет	1	10	2025-04-03 15:15:00	3	47	40	\N	2025-04-03 13:37:18.673079+03	2025-04-03 14:30:56.709162+03	2025-04-03 13:37:06.336774+03	t	f	\N	\N	\N
1039	Цех 45	Отвезти детали в 52 цех	1	100	2025-04-03 14:00:00	3	67	17	\N	2025-04-03 12:50:08.69114+03	2025-04-03 13:49:57.992463+03	2025-04-03 12:49:59.010984+03	f	f	\N	\N	\N
1047	Цех 45	Отвезти детали токарю	1	0.5	2025-04-03 13:30:00	3	67	17	\N	2025-04-03 13:31:05.846266+03	2025-04-03 13:50:09.150586+03	2025-04-03 13:30:56.345272+03	f	f	\N	\N	\N
1049	Цех 45	Привезти детали от токаря	1	2	2025-04-03 13:45:00	3	67	17	\N	2025-04-03 13:32:39.339987+03	2025-04-03 13:50:22.055654+03	2025-04-03 13:32:19.336338+03	f	f	\N	\N	\N
1059	46	46	10	5	2025-04-03 14:00:00	3	56	58	\N	2025-04-03 13:52:39.891919+03	2025-04-03 14:49:08.435357+03	2025-04-03 13:51:36.304397+03	f	f	\N	\N	\N
1060	Кронштейн	Нет	1	1	2025-04-03 15:30:00	3	47	58	AgACAgIAAxkBAALgvWfubN8zZfNHo0ptDtHgQ4bEN_6NAAIR7zEbn9h4S-gy3Nlgi2SAAQADAgADeQADNgQ	2025-04-03 14:14:49.203513+03	2025-04-03 15:09:45.917647+03	2025-04-03 14:11:41.029846+03	t	f	\N	\N	\N
1053	6л8034709-01 23 шт (4 ящика)	Не.	1	10	2025-04-03 15:30:00	3	47	40	\N	2025-04-03 13:38:49.603727+03	2025-04-03 13:58:20.597543+03	2025-04-03 13:38:38.28481+03	t	f	\N	\N	\N
1051	Фланец	Нет	1	10	2025-04-03 15:00:00	3	47	40	\N	2025-04-03 13:36:48.372302+03	2025-04-03 13:58:37.047083+03	2025-04-03 13:36:07.021015+03	t	f	\N	\N	\N
1054	Доставка деревянной столешницы	Листы фанеры 26шт	10	50	2025-04-03 14:00:00	3	31	61	\N	2025-04-03 13:43:18.104871+03	2025-04-03 14:31:30.273704+03	2025-04-03 13:43:15.142042+03	t	f	\N	\N	\N
1518	Мусор	Нет	7	50	2025-04-11 12:30:00	3	16	61	\N	2025-04-11 12:34:12.003265+03	2025-04-11 13:03:07.546216+03	2025-04-11 12:34:07.847332+03	t	f	5	34	57
1046	Готовая продукция	Нет	10	20	2025-04-03 13:45:00	3	47	40	\N	2025-04-03 13:29:15.955641+03	2025-04-03 14:34:25.82318+03	2025-04-03 13:29:05.490344+03	t	f	\N	\N	\N
1045	344-ые трубы	Аварийно	1	20	2025-04-03 13:15:00	3	66	40	\N	2025-04-03 13:21:41.281942+03	2025-04-03 14:34:52.523892+03	2025-04-03 13:21:16.570616+03	t	f	\N	\N	\N
1056	46	46	10	5	2025-04-03 14:00:00	3	56	58	\N	2025-04-03 14:01:31.823242+03	2025-04-03 14:48:36.640459+03	2025-04-03 13:47:44.685762+03	f	f	\N	\N	\N
1058	46	46	10	2	2025-04-03 14:00:00	3	56	58	\N	2025-04-03 13:52:34.466932+03	2025-04-03 14:48:42.404642+03	2025-04-03 13:49:32.223093+03	f	f	\N	\N	\N
1061	Заготовки	На лазер	4	2	2025-04-03 14:30:00	3	57	58	\N	2025-04-03 14:24:01.51464+03	2025-04-03 14:49:43.909357+03	2025-04-03 14:23:55.807299+03	f	f	\N	\N	\N
1062	Заготовки	В цех	4	2	2025-04-03 12:30:00	3	57	58	\N	2025-04-03 14:24:59.074343+03	2025-04-03 15:12:52.28586+03	2025-04-03 14:24:54.0011+03	f	f	\N	\N	\N
1050	Отборки	Нет	1	10	2025-04-03 14:45:00	3	47	40	\N	2025-04-03 13:35:11.766249+03	2025-04-03 15:13:30.784232+03	2025-04-03 13:34:51.299076+03	t	f	\N	\N	\N
1067	Детали	С 43 цеха в 44 цех	1	10	2025-04-03 12:30:00	3	33	60	\N	2025-04-03 15:41:05.652535+03	2025-04-03 15:41:18.607982+03	2025-04-03 15:40:52.113112+03	f	f	\N	\N	\N
1068	Отборки	Со склада 6 отд ПДО в 43 цех	4	10	2025-04-03 13:00:00	3	33	60	\N	2025-04-03 15:43:09.995596+03	2025-04-03 15:43:17.698322+03	2025-04-03 15:42:53.53659+03	f	f	\N	\N	\N
1069	Приборы	С МС-35 в 43 цех	8	45	2025-04-03 15:00:00	3	33	60	\N	2025-04-03 15:47:03.247348+03	2025-04-03 15:47:11.945851+03	2025-04-03 15:46:48.869686+03	f	f	\N	\N	\N
1070	Изделия	С 43 цеха в 59 станцию	10	8	2025-04-03 15:15:00	3	33	60	\N	2025-04-03 15:48:53.899496+03	2025-04-03 15:49:01.922377+03	2025-04-03 15:48:37.915245+03	f	f	\N	\N	\N
1066	Детали	Нет	1	5	2025-04-03 15:30:00	3	66	61	\N	2025-04-03 15:39:59.927361+03	2025-04-03 16:02:28.157078+03	2025-04-03 15:39:39.885021+03	t	f	\N	\N	\N
1112	Цех 45	Вывезти мусор	6	100	2025-04-04 13:00:00	3	67	17	\N	2025-04-04 12:11:25.116701+03	2025-04-04 13:25:17.405022+03	2025-04-04 12:11:14.882135+03	f	f	5	\N	\N
1071	Изделия	С 40 станции в 43 цех	10	6	2025-04-03 15:30:00	3	33	60	\N	2025-04-03 15:50:26.474218+03	2025-04-03 15:50:33.536254+03	2025-04-03 15:50:11.319695+03	f	f	\N	\N	\N
1519	Детали	Готовые детали	1	20	2025-04-11 12:30:00	3	26	58	\N	2025-04-11 12:34:56.950635+03	2025-04-11 13:55:09.330173+03	2025-04-11 12:34:54.155406+03	t	f	5	34	43
1517	41/10 отправка деталей	Забрать детали в10корп. с БТК и уч.промывки и отвезти на 2уч. 41/60	1	5	2025-04-11 12:30:00	3	74	8	\N	2025-04-11 12:36:02.179676+03	2025-04-11 14:31:31.299708+03	2025-04-11 12:23:38.433496+03	f	f	5	25	24
1043	41	Отправка\n0367347         44ц\n931852            44ц\n6т8132086-2     44ц\n945185             44ц\n0131523-54      44ц\n0367454            44ц	1	5	2025-04-03 14:00:00	3	30	8	\N	2025-04-03 13:15:57.25468+03	2025-04-03 16:13:34.92217+03	2025-04-03 13:13:21.638944+03	f	f	\N	\N	\N
1078	Заготовки	В цех	4	4	2025-04-04 08:15:00	3	57	8	\N	2025-04-04 08:39:29.363167+03	2025-04-04 08:59:24.687897+03	2025-04-04 08:10:58.329247+03	f	f	\N	\N	\N
1087	41цех	Стержень ф-4  50	4	50	2025-04-04 09:30:00	3	70	8	\N	2025-04-04 08:48:00.328115+03	2025-04-04 09:44:49.159764+03	2025-04-04 08:47:07.00894+03	t	f	\N	\N	\N
1077	Заготовки	На лазер	4	1	2025-04-04 08:15:00	3	57	8	\N	2025-04-04 08:39:41.46218+03	2025-04-04 08:59:43.745083+03	2025-04-04 08:09:58.865713+03	f	f	\N	\N	\N
1072	Корпуса 0140627	Нет	1	15	2025-04-04 07:45:00	3	66	8	\N	2025-04-04 07:50:03.900197+03	2025-04-04 08:59:56.382711+03	2025-04-04 07:48:03.03438+03	t	f	\N	\N	\N
1081	Мусор	Нет	9	100	2025-04-04 09:00:00	3	47	40	\N	2025-04-04 08:30:44.738941+03	2025-04-04 10:20:17.787731+03	2025-04-04 08:30:38.007813+03	t	f	\N	\N	\N
1092	Кислота соляная	В канистрах	4	350	2025-04-04 10:15:00	3	34	61	\N	2025-04-04 09:07:52.343294+03	2025-04-04 10:46:16.873958+03	2025-04-04 09:07:43.449607+03	t	f	\N	\N	\N
1088	Вывезти стружку	Нет	6	100	2025-04-04 10:00:00	3	63	62	\N	2025-04-04 08:49:26.740991+03	2025-04-04 10:25:46.475631+03	2025-04-04 08:48:56.216093+03	t	f	\N	\N	\N
1086	Форма	Оснастка	8	8	2025-04-04 09:00:00	3	54	62	\N	2025-04-04 08:44:25.722346+03	2025-04-04 09:46:59.443914+03	2025-04-04 08:43:56.050593+03	t	f	\N	\N	\N
1082	Заготовки на скоростную фрезеровку	Нет	1	20	2025-04-04 09:00:00	3	63	62	\N	2025-04-04 08:39:23.04946+03	2025-04-04 09:47:39.588822+03	2025-04-04 08:39:00.951752+03	t	f	\N	\N	\N
1079	Детали	Термообработка	1	1.5	2025-04-04 08:45:00	3	54	62	\N	2025-04-04 08:24:58.262148+03	2025-04-04 09:48:03.574466+03	2025-04-04 08:24:36.391486+03	t	f	\N	\N	\N
1096	Решетки 1м на 1м	Нет	10	40	2025-04-04 10:15:00	3	69	62	\N	2025-04-04 09:50:57.230071+03	2025-04-04 10:38:33.691867+03	2025-04-04 09:42:27.853788+03	t	f	\N	\N	\N
1095	41 цех	Склад химии> забратьVactra2 80л> 10 корпус	9	80	2025-04-04 10:30:00	3	42	8	\N	2025-04-04 09:43:01.533964+03	2025-04-04 10:41:25.796681+03	2025-04-04 09:42:20.810911+03	f	f	\N	\N	\N
1074	41-2 цех Детали	Из 41-2 в 46/12	1	15	2025-04-04 09:00:00	3	39	8	\N	2025-04-04 07:59:40.638461+03	2025-04-04 08:58:22.434222+03	2025-04-04 07:59:27.799296+03	f	f	\N	\N	\N
1075	41	Отправка \n0367347      44ц\n0131523*     44ц\n919226        44ц	1	3	2025-04-04 08:30:00	3	30	8	\N	2025-04-04 08:06:31.829944+03	2025-04-04 08:58:36.031455+03	2025-04-04 08:06:19.311886+03	f	f	\N	\N	\N
1076	41	Межоперационка \n0151777    в кладовую  к Березиной Т.Ю.	1	1	2025-04-04 08:30:00	3	30	8	\N	2025-04-04 08:07:58.949436+03	2025-04-04 08:58:50.036831+03	2025-04-04 08:07:54.625438+03	f	f	\N	\N	\N
1073	41/3-10корп. Отправка деталей	Забрать детали с БТК в 10корп.и отвезти согласно сдат.накладным	1	15	2025-04-04 08:30:00	3	74	8	\N	2025-04-04 07:49:54.115095+03	2025-04-04 08:59:06.548923+03	2025-04-04 07:48:43.690133+03	f	f	\N	\N	\N
1097	41 цех	Склад цветных металлов	4	50	2025-04-04 10:00:00	3	70	8	\N	2025-04-04 09:43:53.261061+03	2025-04-04 10:41:37.311347+03	2025-04-04 09:43:02.611726+03	f	f	\N	\N	\N
1084	41-2 цех Мусор СРОЧНО	Из 10 корп в 71	7	70	2025-04-04 08:45:00	3	39	8	\N	2025-04-04 08:42:12.644509+03	2025-04-04 09:10:54.986932+03	2025-04-04 08:41:33.691689+03	t	f	\N	\N	\N
1083	41-2 цех. Мусор СРОЧНО	Из 41-2 цеха в 71	7	40	2025-04-04 08:45:00	3	39	8	\N	2025-04-04 08:42:29.079088+03	2025-04-04 09:11:10.340241+03	2025-04-04 08:40:43.897802+03	t	f	\N	\N	\N
1098	Прокладки	1 этаж Алена	10	1	2025-04-04 10:15:00	3	20	58	\N	2025-04-04 11:59:08.702702+03	2025-04-04 12:59:39.950196+03	2025-04-04 09:54:03.862526+03	t	f	5	\N	\N
1089	46	46	10	2	2025-04-04 09:00:00	3	56	8	\N	2025-04-04 09:10:17.971067+03	2025-04-04 09:15:45.99124+03	2025-04-04 08:57:16.062373+03	f	f	\N	\N	\N
1091	Листы стали	Металл	4	50	2025-04-04 09:30:00	3	34	61	\N	2025-04-04 09:04:44.810548+03	2025-04-04 09:41:24.977823+03	2025-04-04 09:04:41.032141+03	t	f	\N	\N	\N
1102	41	Плита	4	50	2025-04-04 11:00:00	3	70	8	\N	2025-04-04 10:44:00.870522+03	2025-04-04 10:56:14.101114+03	2025-04-04 10:43:47.954264+03	f	f	\N	\N	\N
1093	Быт отходы	4 ящика	7	200	2025-04-04 13:00:00	3	69	8	\N	2025-04-04 10:04:54.650988+03	2025-04-04 13:37:21.064791+03	2025-04-04 09:16:17.086983+03	f	f	5	\N	\N
1099	45 цех	Отправка формы в 61 цех	8	50	2025-04-04 10:00:00	3	80	17	\N	2025-04-04 09:57:57.261431+03	2025-04-04 10:11:45.050286+03	2025-04-04 09:57:51.023759+03	t	f	\N	\N	\N
1085	Паспорта на изделия	Забрать паспорта из типографии (корп.11) и привезти в 58 цех (корп.1)	9	10	2025-04-04 10:00:00	3	50	40	\N	2025-04-04 08:47:40.00506+03	2025-04-04 10:19:55.285534+03	2025-04-04 08:43:07.120375+03	f	f	\N	\N	\N
1080	Мусор	Нет	9	200	2025-04-04 09:00:00	3	47	40	\N	2025-04-04 08:29:55.841988+03	2025-04-04 10:20:09.529885+03	2025-04-04 08:29:47.828331+03	t	f	\N	\N	\N
1100	Коммерческие детали	Детали после покрытия	1	200	2025-04-04 10:30:00	3	26	61	\N	2025-04-04 10:22:40.548066+03	2025-04-04 10:44:48.979202+03	2025-04-04 10:06:39.917647+03	f	f	\N	\N	\N
1104	6т6452525-1 трубка	После травления	1	2	2025-04-04 11:00:00	3	16	62	\N	2025-04-04 10:55:53.852474+03	2025-04-04 11:09:19.17151+03	2025-04-04 10:54:49.173092+03	t	f	\N	\N	\N
1105	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	70	2025-04-04 08:30:00	3	33	60	\N	2025-04-04 11:47:33.677508+03	2025-04-04 11:47:40.647673+03	2025-04-04 11:47:18.177868+03	f	f	\N	\N	\N
1101	Ящики	Нет	10	15	2025-04-04 12:00:00	3	78	8	\N	2025-04-04 11:42:16.307435+03	2025-04-04 12:11:08.070424+03	2025-04-04 10:41:12.904788+03	f	f	5	\N	\N
1107	Детали	Из 46/12 в цех	4	5	2025-04-04 12:00:00	3	57	58	\N	2025-04-04 11:59:22.246243+03	2025-04-04 13:37:49.627364+03	2025-04-04 11:50:46.206755+03	f	f	5	\N	\N
1090	46	46	9	2	2025-04-04 09:00:00	3	56	58	\N	2025-04-04 11:59:02.104019+03	2025-04-04 13:37:15.40605+03	2025-04-04 08:58:31.050986+03	f	f	\N	\N	\N
1109	46	46	10	3	2025-04-04 12:00:00	3	56	58	\N	2025-04-04 12:00:15.921359+03	2025-04-04 12:58:17.350734+03	2025-04-04 11:52:05.948343+03	f	f	\N	\N	\N
1111	46	46	10	1	2025-04-04 12:00:00	3	56	58	\N	2025-04-04 12:00:21.840862+03	2025-04-04 12:58:42.178772+03	2025-04-04 11:55:37.030549+03	f	f	\N	\N	\N
1106	46	46	10	2	2025-04-04 12:00:00	3	56	58	\N	2025-04-04 11:59:39.343499+03	2025-04-04 12:58:54.118081+03	2025-04-04 11:49:22.013598+03	f	f	\N	\N	\N
1110	Детали	Нет	1	15	2025-04-04 11:45:00	3	66	61	\N	2025-04-04 11:55:15.237028+03	2025-04-04 12:16:34.513942+03	2025-04-04 11:54:49.348595+03	t	f	5	\N	\N
1108	46	46	10	3	2025-04-04 12:00:00	3	56	58	\N	2025-04-04 11:59:45.168971+03	2025-04-04 12:58:04.636216+03	2025-04-04 11:50:49.625408+03	f	f	\N	\N	\N
1094	41-2 цех. Стружка	Из 50 корпуса на утильбазу 71	6	100	2025-04-04 09:30:00	3	39	8	\N	2025-04-04 12:01:27.024273+03	2025-04-04 12:28:46.523517+03	2025-04-04 09:18:03.796484+03	f	f	5	\N	\N
1520	Готовые детали	Нет	1	10	2025-04-11 13:00:00	3	16	61	\N	2025-04-11 13:05:54.295516+03	2025-04-11 13:19:04.472548+03	2025-04-11 13:05:50.70389+03	t	f	5	34	2
1527	Тара	Нет	9	50	2025-04-11 13:45:00	3	47	58	\N	2025-04-11 13:53:51.512168+03	2025-04-11 15:04:30.482658+03	2025-04-11 13:27:32.621831+03	t	f	5	52	41
1529	46	46	10	2	2025-04-11 14:00:00	3	56	58	\N	2025-04-11 13:45:16.696363+03	2025-04-11 14:37:51.173556+03	2025-04-11 13:29:28.712867+03	f	f	\N	43	24
1113	Цех 45	Отвезти детали на склад ПДО	1	5	2025-04-04 14:00:00	3	67	17	\N	2025-04-04 12:12:20.27293+03	2025-04-04 13:45:34.870528+03	2025-04-04 12:12:12.466248+03	f	f	5	\N	\N
1128	41/3-10корп. Отправка деталей	Забрать детали 6Т8074419 из БТК 10корп.и отвезти в 41/60 2уч. СРОЧНО	1	10	2025-04-04 14:00:00	3	74	8	\N	2025-04-04 14:16:56.358394+03	2025-04-04 15:16:01.866636+03	2025-04-04 13:56:04.659754+03	t	f	5	\N	\N
1126	Цех 45	Привезти арматуру со склада	1	0.1	2025-04-04 13:45:00	3	67	17	\N	2025-04-04 13:47:04.411975+03	2025-04-04 13:49:40.571069+03	2025-04-04 13:46:53.322434+03	f	f	5	\N	\N
1116	Вывоз мусора и стружку	Нет	6	100	2025-04-04 13:00:00	3	63	62	\N	2025-04-04 12:46:04.132837+03	2025-04-04 13:50:55.478875+03	2025-04-04 12:45:48.047676+03	t	f	\N	\N	\N
1119	41/3-10корп. Отправка деталей	Забрать детали с БТК в 10корп.и отвезти согласно сдат.накладным	1	50	2025-04-04 13:15:00	3	74	8	\N	2025-04-04 12:53:16.187399+03	2025-04-04 13:37:50.860564+03	2025-04-04 12:52:32.062425+03	f	f	5	\N	\N
1123	Спец. Одежба	В мешке	9	25	2025-04-04 13:15:00	3	34	61	\N	2025-04-04 13:11:34.897356+03	2025-04-04 13:30:13.831754+03	2025-04-04 13:11:12.650482+03	t	f	5	\N	\N
1114	Заготовки	В цех	4	1	2025-04-04 12:30:00	3	57	58	\N	2025-04-04 12:30:22.918587+03	2025-04-04 13:37:43.731423+03	2025-04-04 12:30:03.967238+03	f	f	5	\N	\N
1143	320-ые фланцы+ крышки	Нет	1	10	2025-04-04 15:30:00	1	66	\N	\N	\N	\N	2025-04-04 15:31:25.211858+03	t	f	\N	\N	\N
1122	Картридж	В 39 отд	9	2	2025-04-04 13:30:00	3	20	58	\N	2025-04-04 13:12:22.177367+03	2025-04-04 13:37:24.264116+03	2025-04-04 13:07:06.855009+03	t	f	5	\N	\N
1134	Детали	Детали	1	10	2025-04-04 14:45:00	3	79	40	\N	2025-04-04 14:28:53.268226+03	2025-04-04 14:50:48.53753+03	2025-04-04 14:28:39.510756+03	t	f	5	\N	\N
1118	Ярлыки	1 этаж	9	1	2025-04-04 13:00:00	3	20	58	\N	2025-04-04 12:57:30.189394+03	2025-04-04 13:37:29.664192+03	2025-04-04 12:50:29.173667+03	t	f	5	\N	\N
1117	Прокладка	Масло	1	1	2025-04-04 12:45:00	3	20	58	\N	2025-04-04 12:57:51.356343+03	2025-04-04 13:37:36.954977+03	2025-04-04 12:49:30.553113+03	t	f	5	\N	\N
1129	Трубы	Нет	1	2	2025-04-04 14:15:00	3	72	58	\N	2025-04-04 14:19:44.981779+03	2025-04-04 14:41:17.751881+03	2025-04-04 14:02:15.914497+03	t	f	5	\N	\N
1120	41-2 цех. Детали	Из 41-2 в 44, 46/12, 10 корп к Ане	1	25	2025-04-04 14:00:00	3	39	8	\N	2025-04-04 12:57:03.39796+03	2025-04-04 13:37:59.17269+03	2025-04-04 12:56:42.605863+03	f	f	\N	\N	\N
1523	41-2 цех. Детали	Развозка деталей	1	15	2025-04-11 14:00:00	3	39	8	\N	2025-04-11 13:29:04.939963+03	2025-04-11 13:41:33.141216+03	2025-04-11 13:18:35.163366+03	f	f	5	24	2
1115	6т8020031 корпус	На пропитку	1	3	2025-04-04 12:30:00	3	66	8	\N	2025-04-04 12:33:36.076567+03	2025-04-04 13:37:13.280714+03	2025-04-04 12:33:07.945161+03	t	f	5	\N	\N
1121	Мусор	Нет	6	150	2025-04-04 13:00:00	3	66	61	\N	2025-04-04 13:04:35.740832+03	2025-04-04 13:40:23.067865+03	2025-04-04 13:04:30.307872+03	t	f	5	\N	\N
1131	Детали	С 43 цеха в 44 цех	1	2	2025-04-04 12:30:00	3	33	60	\N	2025-04-04 14:21:21.35472+03	2025-04-04 14:36:12.937825+03	2025-04-04 14:21:06.623803+03	f	f	\N	\N	\N
1139	Трубочки	Нет	1	5	2025-04-04 14:45:00	3	16	62	\N	2025-04-04 14:50:52.742355+03	2025-04-04 15:05:38.265355+03	2025-04-04 14:50:11.929867+03	t	f	5	\N	\N
1125	41-2 цех. Детали	Из 41-2 в 44 и 10 корп	1	25	2025-04-04 13:45:00	3	39	8	\N	2025-04-04 13:38:21.885406+03	2025-04-04 15:16:12.061425+03	2025-04-04 13:34:49.775987+03	t	f	\N	\N	\N
1127	Получить воду	Нет	5	100	2025-04-04 14:00:00	3	63	62	\N	2025-04-04 13:52:12.453816+03	2025-04-04 14:30:44.329823+03	2025-04-04 13:51:48.663544+03	t	f	\N	\N	\N
1132	Изделия	С 43 цеха на 40 станцию	10	15	2025-04-04 12:30:00	3	33	60	\N	2025-04-04 14:25:19.118033+03	2025-04-04 14:36:20.745435+03	2025-04-04 14:25:05.103286+03	f	f	\N	\N	\N
1133	Тара	С 43 цеха на склад ПДО 6 отд	9	20	2025-04-04 12:30:00	3	33	60	\N	2025-04-04 14:27:31.798141+03	2025-04-04 14:36:30.016174+03	2025-04-04 14:27:16.381692+03	f	f	\N	\N	\N
1135	Отборки	Со склада 6 ПДО в 43 цех	4	20	2025-04-04 13:00:00	3	33	60	\N	2025-04-04 14:30:31.342909+03	2025-04-04 14:36:38.152537+03	2025-04-04 14:30:19.526885+03	f	f	\N	\N	\N
1136	Детали	С 44 цеха в 43 цех	1	30	2025-04-04 13:15:00	3	33	60	\N	2025-04-04 14:32:11.478746+03	2025-04-04 14:36:45.411414+03	2025-04-04 14:31:54.749761+03	f	f	\N	\N	\N
1137	Картонные коробки	С 52 цеха в 43 цех	9	10	2025-04-04 13:15:00	3	33	60	\N	2025-04-04 14:34:10.173247+03	2025-04-04 14:37:10.731913+03	2025-04-04 14:33:53.004847+03	f	f	\N	\N	\N
1138	Мусор	С 43 цеха на утиль базу	7	70	2025-04-04 13:30:00	3	33	60	\N	2025-04-04 14:35:50.569983+03	2025-04-04 14:37:19.941218+03	2025-04-04 14:35:39.070502+03	f	f	\N	\N	\N
1141	Готовые детали	Нет	1	10	2025-04-04 15:30:00	3	16	61	\N	2025-04-04 15:26:30.663359+03	2025-04-04 15:48:17.046632+03	2025-04-04 15:26:27.174114+03	t	f	5	\N	\N
1103	Корпуса	Объемные(большие) корпуса	1	30	2025-04-04 10:45:00	3	66	40	AgACAgIAAxkBAALom2fvj9e0Jt9TvMOWT8kaBUAe1b8cAALL7DEbOTOBS15ZOVTVYDKPAQADAgADeQADNgQ	2025-04-04 10:53:42.9327+03	2025-04-04 14:50:55.181999+03	2025-04-04 10:53:23.482403+03	t	f	5	\N	\N
1142	Трубы	Аварийно‼️	1	10	2025-04-04 15:30:00	1	66	\N	AgACAgIAAxkBAALv8Gfv0Jf5Y7SjpMT4ocEMW1W96sj0AAKz7jEbOTOBS4egqGF_3XtMAQADAgADeQADNgQ	\N	\N	2025-04-04 15:29:20.526254+03	t	f	\N	\N	\N
1144	Изделия	С 43 на 59 станцию	10	6	2025-04-04 15:15:00	3	33	60	\N	2025-04-04 15:48:48.788236+03	2025-04-04 15:49:00.518259+03	2025-04-04 15:48:31.032162+03	f	f	\N	\N	\N
1130	Ярлык	Нет	9	1	2025-04-04 14:15:00	3	20	58	\N	2025-04-04 14:18:10.718906+03	2025-04-04 14:41:12.069642+03	2025-04-04 14:04:55.688356+03	t	f	5	\N	\N
1148	41	Отправка\n6т8850004    44ц	1	1	2025-04-07 08:30:00	3	30	8	\N	2025-04-07 08:10:50.168822+03	2025-04-07 08:58:23.340137+03	2025-04-07 08:10:25.711925+03	f	f	5	25	34
1521	Форма 45	Форма	8	20	2025-04-11 14:00:00	3	80	17	\N	2025-04-11 13:09:35.269213+03	2025-04-11 13:46:18.782912+03	2025-04-11 13:09:29.864927+03	t	f	5	37	54
1156	Детали	Термообработка	1	1	2025-04-07 09:00:00	3	54	62	\N	2025-04-07 08:41:37.296055+03	2025-04-07 09:24:40.667452+03	2025-04-07 08:40:49.363241+03	t	f	\N	54	39
1147	Заготовки	В цех	4	3	2025-04-07 08:15:00	3	57	58	\N	2025-04-07 08:17:02.153749+03	2025-04-07 10:35:01.873435+03	2025-04-07 08:09:01.957375+03	f	f	5	38	43
1150	Прокладка	Нет	10	1	2025-04-07 08:45:00	3	20	58	\N	2025-04-07 08:17:33.458127+03	2025-04-07 10:34:43.739621+03	2025-04-07 08:16:34.160424+03	f	f	5	44	2
1154	46	46	10	2	2025-04-07 09:00:00	3	56	58	\N	2025-04-07 08:39:20.876771+03	2025-04-07 10:34:07.992133+03	2025-04-07 08:35:39.606695+03	f	f	\N	43	39
1140	Мусор	На свалку	7	20	2025-04-04 15:15:00	3	57	58	\N	2025-04-04 15:04:24.286879+03	2025-04-07 08:19:17.586009+03	2025-04-04 15:03:04.936278+03	f	f	5	\N	\N
1152	46	46	10	5	2025-04-07 09:00:00	3	56	58	\N	2025-04-07 08:39:36.29391+03	2025-04-07 10:34:15.507068+03	2025-04-07 08:31:01.476263+03	f	f	\N	43	24
1153	46	46	10	3	2025-04-07 09:00:00	3	56	58	\N	2025-04-07 08:39:42.792292+03	2025-04-07 10:34:37.113456+03	2025-04-07 08:34:14.602327+03	f	f	\N	43	35
1149	Заготовки	На лазер	4	5	2025-04-07 08:15:00	3	57	58	\N	2025-04-07 08:18:51.590998+03	2025-04-07 10:35:08.175052+03	2025-04-07 08:13:05.3316+03	f	f	5	38	41
1155	41 цех. Детали	Детали	1	10	2025-04-07 09:00:00	3	39	8	\N	2025-04-07 08:37:13.611816+03	2025-04-07 08:58:35.152783+03	2025-04-07 08:36:28.44457+03	f	f	5	24	26
1124	41	Отправка\n6т8950004    44ц	1	1	2025-04-04 13:30:00	3	30	8	\N	2025-04-04 13:34:58.854043+03	2025-04-04 13:38:07.152161+03	2025-04-04 13:21:55.34499+03	f	f	5	\N	\N
1157	41 цех. Стружка	Из 10-1 Стружка на 71 утильбазу	6	400	2025-04-07 09:00:00	3	39	8	\N	2025-04-07 08:45:49.655962+03	2025-04-07 08:58:02.568318+03	2025-04-07 08:45:33.515413+03	f	f	\N	25	57
1151	41 цех	Стирка из 60/2 и 10 корп в прачечнкю	9	5	2025-04-07 09:00:00	3	42	8	\N	2025-04-07 08:16:52.68746+03	2025-04-07 09:06:47.307171+03	2025-04-07 08:16:39.881002+03	f	f	\N	24	6
1158	Дртс150б-1	Нет	10	1	2025-04-07 10:00:00	3	47	40	\N	2025-04-07 09:49:24.047024+03	2025-04-07 10:48:01.637505+03	2025-04-07 09:49:12.63676+03	t	f	\N	51	53
1161	41 цех	41 цех 8 участок , нужна вода на шлифовку в корпус 6-7 (2 бутылки)	5	1	2025-04-07 12:15:00	3	53	8	\N	2025-04-07 10:46:03.958768+03	2025-04-07 10:54:58.624887+03	2025-04-07 10:44:52.310144+03	t	f	\N	28	28
1168	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	100	2025-04-07 08:30:00	3	33	60	\N	2025-04-07 11:20:14.429425+03	2025-04-07 11:35:13.671593+03	2025-04-07 11:19:53.662846+03	f	f	\N	8	31
1167	41-2 цех. Детали	Со склада 06 нужно забрать наконечники 6л7773013 для 41 цеха. Привезти в на 2 уч в кладовую	1	5	2025-04-07 12:00:00	3	39	8	\N	2025-04-07 10:53:21.530043+03	2025-04-07 12:19:59.429349+03	2025-04-07 10:52:57.305422+03	t	f	\N	2	24
1159	Тара	Нет	9	30	2025-04-07 10:30:00	3	47	40	\N	2025-04-07 09:59:06.644174+03	2025-04-07 12:38:42.527393+03	2025-04-07 09:50:17.690712+03	t	f	\N	53	51
1164	Детали	В покраску	1	1	2025-04-07 11:00:00	3	54	62	\N	2025-04-07 10:49:09.488036+03	2025-04-07 12:57:43.213437+03	2025-04-07 10:48:47.106815+03	t	f	\N	54	34
1165	41-2 цех. Детали	Со склада 06 нужно забрать наконечники 6л7773013 для 41 цеха. Привезти в на 2 уч в кладовую	1	5	2025-04-07 12:00:00	3	39	8	\N	2025-04-07 10:54:30.787916+03	2025-04-07 12:21:06.843118+03	2025-04-07 10:52:47.543297+03	t	f	5	2	24
1535	Детали	Нет	1	3	2025-04-11 12:15:00	3	33	60	\N	2025-04-11 13:41:53.940398+03	2025-04-11 13:56:15.267527+03	2025-04-11 13:41:38.998903+03	f	f	\N	31	35
1162	Трубы	Нет	1	10	2025-04-07 11:00:00	3	47	40	AgACAgIAAxkBAAL2omfzgwRl0bgRy1RAFxTJSQzw-PL7AAJU9zEbD2yYS6LkNZ6A6LN0AQADAgADeQADNgQ	2025-04-07 10:47:46.69913+03	2025-04-07 13:14:21.274629+03	2025-04-07 10:47:25.698328+03	t	f	5	34	53
1163	41 цех	41 цех 8 участок , нужна вода на шлифовку в корпус 6-7 (2 бутылки)	5	40	2025-04-07 13:30:00	3	53	8	\N	2025-04-07 10:48:19.035514+03	2025-04-07 13:44:04.981664+03	2025-04-07 10:48:13.728267+03	t	f	\N	28	28
1488	Плита	К форме	1	1	2025-04-11 09:15:00	3	54	61	\N	2025-04-11 13:24:55.806474+03	2025-04-11 14:09:10.283832+03	2025-04-11 08:40:34.913343+03	t	f	\N	54	34
1160	Глицерин	Забрать со склада химии, отвезти в основной корпус цеха 46	4	10	2025-04-08 10:30:00	3	19	58	\N	2025-04-07 10:35:40.474763+03	2025-04-08 10:36:23.331144+03	2025-04-07 10:35:13.741893+03	f	f	5	12	43
1530	46	46	10	3	2025-04-11 14:00:00	3	56	58	\N	2025-04-11 13:45:03.352216+03	2025-04-11 14:33:20.764362+03	2025-04-11 13:30:27.312884+03	f	f	\N	43	39
1533	Детали	Нет	1	1	2025-04-11 14:00:00	3	20	58	\N	2025-04-11 13:44:15.550712+03	2025-04-11 14:32:54.577822+03	2025-04-11 13:31:32.75297+03	t	f	5	44	35
1526	Заготовки	В цех	4	3	2025-04-11 13:30:00	3	57	58	\N	2025-04-11 13:44:28.455863+03	2025-04-11 14:39:17.758014+03	2025-04-11 13:27:19.749219+03	f	f	5	38	43
1522	Корпуса БППД с 3 этажа корпуса 60-2 в клопус 6-7	Нет	1	60	2025-04-11 13:00:00	3	9	8	\N	2025-04-11 13:12:01.699234+03	2025-04-11 14:30:52.912324+03	2025-04-11 13:11:23.379095+03	t	f	5	24	27
1184	Вода	Нет	5	400	2025-04-07 13:30:00	3	74	8	\N	2025-04-07 13:20:01.035702+03	2025-04-07 13:44:20.597353+03	2025-04-07 13:19:44.453031+03	t	f	5	37	25
1174	Плата ркм	Нет	10	1	2025-04-07 13:00:00	3	47	40	\N	2025-04-07 12:46:29.830119+03	2025-04-07 13:49:11.755583+03	2025-04-07 12:45:59.463181+03	t	f	5	51	32
1187	Цех 45	Отправка деталей токарю	1	3	2025-04-07 09:30:00	3	67	17	\N	2025-04-07 13:28:26.988621+03	2025-04-07 13:28:41.427855+03	2025-04-07 13:27:59.967043+03	f	f	5	37	63
1169	Трафареты	С 51 цеха в 43 цех	8	15	2025-04-07 09:00:00	3	33	60	\N	2025-04-07 11:23:09.233843+03	2025-04-07 11:35:23.483183+03	2025-04-07 11:22:52.546027+03	f	f	\N	45	31
1170	Платы	С 31 в 43 цех	4	40	2025-04-07 09:00:00	3	33	60	\N	2025-04-07 11:27:14.244607+03	2025-04-07 11:35:38.747131+03	2025-04-07 11:26:50.727882+03	f	f	\N	45	31
1166	41-2 цех. Детали	Со склада 06 нужно забрать наконечники 6л7773013 для 41 цеха. Привезти в на 2 уч в кладовую	1	5	2025-04-07 12:00:00	3	39	8	\N	2025-04-07 10:53:44.448096+03	2025-04-07 12:20:16.903897+03	2025-04-07 10:52:55.085501+03	t	f	\N	2	24
1203	Деревянная тара	Забрать деревянную тару из 52 цеха (деревообрабатывающий) и привезти в 58 цех (корпус 1)	9	20	2025-04-07 15:00:00	3	50	61	\N	2025-04-07 14:39:21.476053+03	2025-04-07 15:21:13.478494+03	2025-04-07 14:36:34.551899+03	f	f	5	46	51
1181	41	Отправка\n6т8236041*   на склад	1	2	2025-04-07 13:30:00	3	30	8	\N	2025-04-07 13:09:42.95772+03	2025-04-07 14:01:39.463458+03	2025-04-07 13:07:58.693213+03	f	f	5	25	2
1186	Трубы	Нет	1	3	2025-04-07 13:45:00	3	72	62	\N	2025-04-07 13:28:15.937468+03	2025-04-07 14:01:48.27067+03	2025-04-07 13:26:40.281079+03	t	f	5	41	44
1175	Мусор	Нет	7	200	2025-04-07 13:00:00	3	47	40	\N	2025-04-07 12:47:36.188682+03	2025-04-09 14:33:42.524254+03	2025-04-07 12:47:20.293979+03	t	f	5	51	57
1179	41	Отправка \n0131523*       44Ц\nМНОГО	1	3	2025-04-07 13:30:00	3	30	8	\N	2025-04-07 13:10:01.225546+03	2025-04-07 14:01:49.851623+03	2025-04-07 13:04:54.175041+03	f	f	5	25	34
1191	Цех 45	Отправка деталей в 52 цех	1	2	2025-04-07 13:30:00	3	67	17	\N	2025-04-07 13:33:08.781487+03	2025-04-07 14:41:30.393175+03	2025-04-07 13:32:47.073822+03	f	f	5	37	46
1189	46	46	10	3	2025-04-07 14:00:00	3	56	58	\N	2025-04-07 13:48:16.422834+03	2025-04-07 14:47:56.527405+03	2025-04-07 13:31:28.86946+03	f	f	\N	43	52
1193	Цех 45	Отвезти детали на склад ПДО	1	1	2025-04-07 13:45:00	3	67	17	\N	2025-04-07 13:34:57.572089+03	2025-04-07 14:40:59.648227+03	2025-04-07 13:34:34.626803+03	f	f	5	37	2
1188	Цех 45	Отправка деталей на склад ПДО	1	1	2025-04-07 09:45:00	3	67	17	\N	2025-04-07 13:30:48.080902+03	2025-04-07 13:31:06.911453+03	2025-04-07 13:30:40.011245+03	f	f	5	37	2
1176	Вода	Нет	5	300	2025-04-07 13:15:00	3	47	40	\N	2025-04-07 12:54:43.348533+03	2025-04-07 14:04:59.370998+03	2025-04-07 12:54:34.302033+03	t	f	\N	62	51
1173	Забрать детали с термичку	Нет	1	5	2025-04-07 13:00:00	3	63	62	\N	2025-04-07 12:44:38.003967+03	2025-04-07 13:25:37.350015+03	2025-04-07 12:44:16.927047+03	t	f	\N	55	39
1185	Цех 45	Отвезти белье в прачечную	9	2	2025-04-07 09:00:00	3	67	17	\N	2025-04-07 13:25:38.000357+03	2025-04-07 13:26:06.877765+03	2025-04-07 13:25:25.509109+03	f	f	5	37	7
1183	Детали	Пескоструй	1	0.5	2025-04-07 13:15:00	3	36	62	\N	2025-04-07 13:13:30.927548+03	2025-04-07 13:26:18.189167+03	2025-04-07 13:13:12.17134+03	t	f	\N	54	29
1199	Детали	С 43 цеха в 44 цех	1	30	2025-04-07 12:30:00	3	33	60	\N	2025-04-07 14:29:06.766566+03	2025-04-07 14:41:50.422156+03	2025-04-07 14:28:48.734083+03	f	f	\N	31	35
1201	Детали	С 44 цеха в 43 цех	1	5	2025-04-07 13:00:00	3	33	60	\N	2025-04-07 14:30:32.436283+03	2025-04-07 14:41:58.049082+03	2025-04-07 14:30:16.449002+03	f	f	\N	34	31
1202	Отборки	Со склада 6 отд ПДО в 43 цех	4	10	2025-04-07 13:00:00	3	33	60	\N	2025-04-07 14:35:48.918799+03	2025-04-07 14:42:08.37641+03	2025-04-07 14:35:34.287988+03	f	f	\N	2	33
1171	Одежда	Нет	9	10	2025-04-07 12:00:00	3	16	61	\N	2025-04-07 12:09:55.767111+03	2025-04-07 12:43:28.454958+03	2025-04-07 12:09:38.609591+03	f	f	5	34	6
1172	Химия	Нет	4	2000	2025-04-07 12:15:00	3	16	61	\N	2025-04-07 12:14:19.031915+03	2025-04-07 12:43:07.642681+03	2025-04-07 12:14:14.265574+03	t	f	5	10	36
1180	Оснастка	Штамп	8	8	2025-04-07 13:30:00	3	36	62	\N	2025-04-07 13:11:11.950307+03	2025-04-07 13:43:23.285592+03	2025-04-07 13:06:35.639698+03	f	f	\N	55	44
1197	Детали	Нет	1	45	2025-04-07 13:45:00	3	16	8	AgACAgIAAxkBAAL8z2fzrFGJse0bOhRYUpyCRkFfoTDvAAKW9jEbAAFCmEu9-2mYeJQrBQEAAwIAA3kAAzYE	2025-04-07 14:34:10.329865+03	2025-04-07 14:46:39.431596+03	2025-04-07 13:43:40.134068+03	t	f	5	34	52
1198	056 Поплавки	Нет	1	10	2025-04-07 14:15:00	3	16	62	\N	2025-04-07 14:19:59.662989+03	2025-04-07 14:40:51.934118+03	2025-04-07 14:18:38.719605+03	t	f	5	34	43
1177	41/3-10корп Отправка деталей	Забрать детали с БТК 10корп. и отвезти на 2уч. 41/60	1	15	2025-04-07 13:30:00	3	74	8	\N	2025-04-07 12:55:48.914435+03	2025-04-07 14:02:02.193681+03	2025-04-07 12:54:39.137475+03	f	f	5	25	24
1178	Вода	Нет	5	100	2025-04-07 13:15:00	3	47	40	\N	2025-04-07 12:55:45.225106+03	2025-04-07 14:05:54.565639+03	2025-04-07 12:55:26.077694+03	t	f	5	62	52
1195	СУ3-16	Нет	10	1	2025-04-07 14:00:00	3	47	40	\N	2025-04-07 13:35:36.661747+03	2025-04-07 14:19:10.143864+03	2025-04-07 13:35:23.042409+03	t	f	5	51	61
1204	Отборки	Со склада 6 отд ПДО в 43 цех	4	10	2025-04-07 13:00:00	3	33	60	\N	2025-04-07 14:37:36.339054+03	2025-04-07 14:42:14.645495+03	2025-04-07 14:37:19.500271+03	f	f	\N	2	31
1208	Колесо	Нет	1	1	2025-04-07 15:00:00	3	20	58	\N	2025-04-07 14:57:25.107055+03	2025-04-07 15:23:51.657171+03	2025-04-07 14:57:19.211966+03	t	f	5	44	40
1207	Форма	Оснастка	8	6	2025-04-07 15:00:00	3	54	62	\N	2025-04-07 14:48:32.43845+03	2025-04-07 15:14:27.924507+03	2025-04-07 14:48:10.210723+03	t	f	\N	54	37
1194	46	46	10	3	2025-04-07 14:00:00	3	56	58	\N	2025-04-07 13:47:08.172889+03	2025-04-07 14:47:31.092555+03	2025-04-07 13:34:42.857509+03	f	f	\N	39	39
1206	Цех 45	Отвезти детали в 46 цех	1	1	2025-04-07 14:00:00	3	67	17	\N	2025-04-07 14:43:58.283917+03	2025-04-07 14:44:17.661615+03	2025-04-07 14:43:48.570379+03	f	f	5	37	44
1192	46	46	10	2	2025-04-07 14:00:00	3	56	58	\N	2025-04-07 13:47:29.793064+03	2025-04-07 14:47:37.094997+03	2025-04-07 13:33:39.524981+03	f	f	\N	43	35
1205	Поддоны	С 43 цеха на утиль базу	9	300	2025-04-07 13:30:00	3	33	60	\N	2025-04-07 14:40:46.468303+03	2025-04-07 14:42:21.754024+03	2025-04-07 14:40:23.829159+03	f	f	\N	31	57
1196	Цех 45	Отвезти ящик для льда	9	3	2025-04-07 13:45:00	3	67	17	\N	2025-04-07 13:36:25.166979+03	2025-04-07 14:41:14.599865+03	2025-04-07 13:36:08.427143+03	f	f	5	37	10
1190	46	46	10	2	2025-04-07 14:00:00	3	56	58	\N	2025-04-07 13:47:49.95857+03	2025-04-07 14:47:44.845719+03	2025-04-07 13:32:33.386663+03	f	f	\N	43	24
1200	41	Межоперационка \n6т8626516-59	10	1	2025-04-07 14:30:00	3	30	8	\N	2025-04-07 14:29:39.345501+03	2025-04-07 14:46:27.24185+03	2025-04-07 14:29:23.962273+03	f	f	5	25	41
1210	Детали	Детали	1	0.5	2025-04-07 15:45:00	3	54	62	\N	2025-04-07 15:42:19.163843+03	2025-04-07 15:50:51.312616+03	2025-04-07 15:41:50.844841+03	t	f	\N	27	54
1211	Изделия	С 43 цеха на 59 станцию	10	10	2025-04-07 15:15:00	3	33	60	\N	2025-04-07 15:44:23.43912+03	2025-04-07 15:44:36.503066+03	2025-04-07 15:44:00.220701+03	f	f	\N	31	53
1209	Готовые детали	Склад ПДО	1	10	2025-04-07 15:45:00	3	16	61	\N	2025-04-07 15:41:32.196285+03	2025-04-07 16:00:41.787486+03	2025-04-07 15:41:26.900034+03	t	f	5	34	63
1231	41-2 цех. Мусор СРОЧНО	Из 41 в 71	6	15	2025-04-08 09:00:00	3	39	8	\N	2025-04-08 09:09:17.362523+03	2025-04-08 10:03:25.274207+03	2025-04-08 08:44:21.462131+03	t	f	5	24	57
1182	41-2 цех. Детали	Из 41-2 в 44, 10 кор, 46/8, 06	1	35	2025-04-07 14:00:00	3	39	8	\N	2025-04-07 13:12:18.466065+03	2025-04-07 14:01:30.721771+03	2025-04-07 13:11:36.733247+03	f	f	5	24	34
1216	41-2 цех. Детали	Из 41 в 43	1	5	2025-04-08 09:00:00	3	39	8	\N	2025-04-08 08:20:37.285603+03	2025-04-08 08:33:41.757518+03	2025-04-08 08:12:35.402406+03	f	f	\N	24	31
1246	Мебель	С 43 цеха в 51 цех	9	50	2025-04-08 09:15:00	3	33	60	\N	2025-04-08 11:05:35.021235+03	2025-04-08 11:12:43.634295+03	2025-04-08 11:05:16.396066+03	f	f	\N	31	45
1213	41	Отправка\n944695\n945016\n6с8927047\n0131523-37	1	5	2025-04-08 08:30:00	3	30	8	\N	2025-04-08 07:56:53.461816+03	2025-04-08 08:33:57.764367+03	2025-04-08 07:52:29.245242+03	f	f	5	25	34
1247	Изделия	С 40 станции в 43 цех	10	15	2025-04-08 09:30:00	3	33	60	\N	2025-04-08 11:08:57.487561+03	2025-04-08 11:12:52.040846+03	2025-04-08 11:08:39.963339+03	f	f	\N	23	31
1214	41/3-10 корп. Отправка деталей	Забрать с БТК 10корп.детали и отвезти на 2уч. 41/60	1	5	2025-04-08 08:30:00	3	74	8	\N	2025-04-08 08:00:58.863157+03	2025-04-08 08:34:12.078334+03	2025-04-08 07:57:24.134243+03	f	f	5	25	24
1256	Прокладки	Отвезти на склад	10	2	2025-04-08 12:45:00	3	20	58	\N	2025-04-08 12:38:15.389545+03	2025-04-08 13:17:15.199755+03	2025-04-08 12:37:54.401854+03	t	f	5	44	2
1248	Химия	Бензин, растворители	4	250	2025-04-08 10:00:00	3	33	60	\N	2025-04-08 11:12:05.851773+03	2025-04-08 11:13:00.528118+03	2025-04-08 11:11:37.513527+03	f	f	\N	12	31
1237	Забрать трубы	Нет	4	1000	2025-04-08 09:45:00	3	63	62	\N	2025-04-08 09:36:10.929487+03	2025-04-08 11:43:02.545297+03	2025-04-08 09:35:44.223628+03	t	f	\N	55	55
1240	Шкалы матить	Нет	1	1	2025-04-08 10:15:00	3	47	40	\N	2025-04-08 10:13:16.638607+03	2025-04-08 10:25:43.127372+03	2025-04-08 10:07:50.676056+03	t	f	5	51	34
1239	Прокладки	Забрать из лаборатории	1	1	2025-04-08 10:15:00	3	20	58	\N	2025-04-08 10:08:12.603473+03	2025-04-08 10:36:29.983754+03	2025-04-08 10:07:32.58917+03	t	f	5	44	16
1250	46	46	10	3	2025-04-08 12:00:00	3	56	58	\N	2025-04-08 11:52:39.573542+03	2025-04-08 13:16:48.708479+03	2025-04-08 11:49:11.851439+03	f	f	\N	43	35
1236	Сода кальциниров.	Мешки	4	2250	2025-04-08 10:00:00	3	34	61	\N	2025-04-08 09:33:59.144604+03	2025-04-08 10:45:03.482193+03	2025-04-08 09:33:49.529514+03	t	f	5	12	36
1232	Плита#16	Нет	4	200	2025-04-08 09:30:00	3	70	8	\N	2025-04-08 09:08:43.217197+03	2025-04-08 10:31:59.596477+03	2025-04-08 08:48:01.285862+03	f	f	5	8	25
1215	Лазерные детали	Забрать детали с 50 корпуса, лазерного участка, отвезти в основной корпус 60-4-2	1	7	2025-04-08 08:15:00	3	19	58	\N	2025-04-08 07:58:43.580289+03	2025-04-08 08:42:29.572618+03	2025-04-08 07:58:21.83956+03	t	f	5	67	43
1219	Вывоз стружки	Металлическая стружка	11	40	2025-04-08 09:00:00	3	64	8	\N	2025-04-08 08:43:26.288611+03	2025-04-08 09:08:07.383968+03	2025-04-08 08:25:04.954026+03	f	f	\N	63	57
1218	Вывоз мусора	Мусор	7	23	2025-04-08 09:00:00	3	64	8	\N	2025-04-08 08:23:56.254746+03	2025-04-08 09:08:24.053189+03	2025-04-08 08:22:49.373171+03	f	f	5	63	57
1257	Детали	В цех	4	1	2025-04-08 12:45:00	3	57	58	\N	2025-04-08 12:38:31.598887+03	2025-04-08 13:17:10.086675+03	2025-04-08 12:38:15.744393+03	f	f	5	40	43
1228	46	46	10	1	2025-04-08 09:00:00	3	56	58	\N	2025-04-08 08:40:44.644411+03	2025-04-08 09:37:52.860775+03	2025-04-08 08:39:05.976346+03	f	f	\N	43	2
1230	46	46	10	2	2025-04-08 09:00:00	3	56	58	\N	2025-04-08 08:49:06.445211+03	2025-04-08 09:37:59.400438+03	2025-04-08 08:44:14.238572+03	f	f	\N	43	41
1220	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:57:43.428443+03	2025-04-08 09:53:05.623481+03	2025-04-08 08:31:14.826639+03	t	f	\N	54	39
1223	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:58:13.66071+03	2025-04-08 09:53:35.527904+03	2025-04-08 08:31:53.989956+03	t	f	\N	54	39
1235	Вывезти отходы проволоки	Нет	6	100	2025-04-08 09:15:00	3	63	62	\N	2025-04-08 09:11:48.879432+03	2025-04-08 09:53:54.546414+03	2025-04-08 09:11:27.99677+03	t	f	\N	55	55
1226	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:32:34.810102+03	2025-04-08 09:54:13.24216+03	2025-04-08 08:32:09.960507+03	t	f	\N	54	39
1225	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:56:49.750719+03	2025-04-08 09:54:35.247352+03	2025-04-08 08:32:09.955948+03	t	f	\N	54	39
1224	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:57:03.741977+03	2025-04-08 09:55:15.411587+03	2025-04-08 08:31:53.992457+03	t	f	\N	54	39
1222	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:58:36.005768+03	2025-04-08 09:55:37.642781+03	2025-04-08 08:31:50.393236+03	t	f	\N	54	39
1221	Детали	Термообработка	1	2	2025-04-08 08:45:00	3	54	62	\N	2025-04-08 08:59:11.873262+03	2025-04-08 09:55:56.330279+03	2025-04-08 08:31:50.392119+03	t	f	\N	54	39
1217	Заготовки	На лазер	4	7	2025-04-08 08:30:00	3	57	58	AgACAgIAAxkBAAEBAWdn9LHSfT_Z0U4228DLA8f-rnW3AANY7TEbKiOpS3mco6qdRRCgAQADAgADeQADNgQ	2025-04-08 08:20:34.112181+03	2025-04-08 08:42:42.214972+03	2025-04-08 08:19:34.820878+03	f	f	5	38	41
1227	41 цех	52 цех, набрать древесные опилки (с лопатой из 10-2корп) >10-1 корп	9	30	2025-04-08 09:30:00	3	42	40	\N	2025-04-08 08:42:34.872872+03	2025-04-08 10:13:34.542747+03	2025-04-08 08:34:19.190046+03	f	f	\N	46	25
1253	41/10 промывка	Отвезти детали с уч.промывки 41/10 в 41/60	1	15	2025-04-08 12:15:00	3	74	8	\N	2025-04-08 12:16:33.522142+03	2025-04-08 12:23:24.790575+03	2025-04-08 12:15:21.089382+03	f	f	5	25	24
1252	46	46	10	1	2025-04-08 12:00:00	3	56	58	\N	2025-04-08 11:52:58.731833+03	2025-04-08 13:16:54.239643+03	2025-04-08 11:51:38.560759+03	f	f	\N	40	40
1229	Вода	Забрать пустые бутыли и привезти полные	5	300	2025-04-08 09:30:00	3	64	8	\N	2025-04-08 08:42:37.545464+03	2025-04-08 09:34:35.893465+03	2025-04-08 08:41:42.13457+03	f	f	5	63	62
1254	Заготовки	В цех	4	5	2025-04-08 12:30:00	3	57	58	\N	2025-04-08 12:33:51.845084+03	2025-04-08 13:17:00.041332+03	2025-04-08 12:26:32.00756+03	f	f	5	38	43
1241	41-2 цех. Детали	Со склада забрать детали 6в8613028-01 в 41 цех в кладовую на 2 участок	1	5	2025-04-08 14:00:00	3	39	8	\N	2025-04-08 10:45:16.931327+03	2025-04-08 13:12:11.699363+03	2025-04-08 10:40:58.372473+03	f	f	5	2	24
1238	41/10 промывка	Забрать детали с мойки  41/60 3й этаж и привезти в 41/10	1	15	2025-04-08 10:00:00	3	74	8	\N	2025-04-08 10:33:12.185397+03	2025-04-08 12:24:08.383503+03	2025-04-08 09:40:06.062506+03	t	f	5	24	25
1242	516-58 трубка	После травления!!!	1	2	2025-04-08 10:45:00	3	16	8	\N	2025-04-08 12:06:02.245667+03	2025-04-08 12:23:46.195476+03	2025-04-08 10:51:10.787578+03	t	f	5	34	24
1249	46	46	10	2	2025-04-08 12:00:00	3	56	58	\N	2025-04-08 11:52:30.99732+03	2025-04-08 13:16:43.721193+03	2025-04-08 11:48:16.978509+03	f	f	\N	43	24
1251	46	46	10	1	2025-04-08 12:00:00	3	56	58	\N	2025-04-08 11:52:51.853313+03	2025-04-08 13:17:04.958019+03	2025-04-08 11:50:08.961074+03	f	f	\N	43	39
1534	Шайба	В 41 цех	10	1	2025-04-11 14:00:00	3	20	58	\N	2025-04-11 13:45:33.857934+03	2025-04-11 14:32:28.898796+03	2025-04-11 13:40:39.193432+03	f	f	5	44	24
1542	Тара пустая	Нет	9	20	2025-04-11 13:15:00	3	33	60	\N	2025-04-11 13:53:44.895498+03	2025-04-11 13:57:03.357038+03	2025-04-11 13:53:29.20645+03	f	f	\N	31	30
1532	Фланцы	Забрать с маркировки в 14:40, отвезти на 5 участок,второй этаж	1	15	2025-04-11 14:45:00	3	47	40	\N	2025-04-11 14:01:27.421744+03	2025-04-11 15:25:55.859811+03	2025-04-11 13:31:28.570614+03	f	f	5	51	52
1540	Отборки	Со склада 6 ПДО	1	150	2025-04-11 12:45:00	3	33	60	\N	2025-04-11 13:50:29.643317+03	2025-04-11 13:56:49.600248+03	2025-04-11 13:50:16.839775+03	f	f	\N	2	31
1528	46	46	10	3	2025-04-11 14:00:00	3	56	58	\N	2025-04-11 13:44:38.557086+03	2025-04-11 14:38:01.774451+03	2025-04-11 13:28:26.842923+03	f	f	\N	43	35
1524	трубы 6л6452094	Срочно со склада ПДО к Шелег , отвезти трубы 6л6452094	1	15	2025-04-11 13:30:00	3	47	40	\N	2025-04-11 13:26:03.745886+03	2025-04-11 15:25:49.595328+03	2025-04-11 13:19:25.238201+03	t	f	5	2	52
1261	Цех 45	Отвезти детали на склад ПДО	1	2	2025-04-08 14:00:00	3	67	17	\N	2025-04-08 12:42:00.149996+03	2025-04-08 14:39:40.209098+03	2025-04-08 12:41:47.546703+03	f	f	\N	37	1
1262	Индикатор	Нет	1	1	2025-04-08 13:00:00	3	47	40	\N	2025-04-08 12:42:16.821822+03	2025-04-08 14:16:23.936041+03	2025-04-08 12:42:15.009201+03	t	f	5	51	31
1234	Молоко	Коробки	9	150	2025-04-08 09:00:00	3	34	61	\N	2025-04-08 09:07:03.37815+03	2025-04-08 09:29:47.736777+03	2025-04-08 09:07:00.523035+03	t	f	5	5	34
1212	Молоко	Погрузка/разгрузка нашим такелажником	9	190	2025-04-08 09:00:00	3	14	8	\N	2025-04-08 07:56:18.882093+03	2025-04-08 09:07:52.846776+03	2025-04-07 16:28:13.691734+03	t	t	5	7	66
1233	41-2 цех. Детали СРОЧНО	Из 41-2 в 10-2 на мойку	1	20	2025-04-08 09:00:00	3	39	8	\N	2025-04-08 09:09:32.867514+03	2025-04-08 10:03:06.019607+03	2025-04-08 08:48:15.139717+03	t	f	5	24	26
1293	Материал	Получить со склада 2.0200	4	400	2025-04-09 10:30:00	3	57	58	\N	2025-04-09 07:59:10.165359+03	2025-04-09 11:12:29.667978+03	2025-04-09 07:58:19.447242+03	t	f	5	9	38
1276	Детали	С 43 цеха в 41 цех	1	8	2025-04-08 12:30:00	3	33	60	\N	2025-04-08 14:05:20.376358+03	2025-04-08 14:22:56.421786+03	2025-04-08 14:05:02.857408+03	f	f	\N	31	24
1244	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	30	2025-04-08 08:30:00	3	33	60	\N	2025-04-08 11:00:12.718036+03	2025-04-08 11:12:27.311935+03	2025-04-08 10:59:56.76515+03	f	f	\N	8	31
1245	Провода	Со склада 14 отд в 43 цех	4	20	2025-04-08 08:30:00	3	33	60	\N	2025-04-08 11:02:50.592181+03	2025-04-08 11:12:35.231219+03	2025-04-08 11:02:29.119185+03	f	f	\N	8	31
1258	Цех 45	Привезти детали от токаря	1	2	2025-04-08 13:00:00	3	67	17	\N	2025-04-08 12:40:52.908889+03	2025-04-08 13:22:13.557067+03	2025-04-08 12:39:18.968404+03	f	f	5	63	37
1255	Цех 45	Вывоз мусора	6	600	2025-04-08 10:00:00	3	67	17	\N	2025-04-08 12:37:52.272071+03	2025-04-08 12:38:18.884707+03	2025-04-08 12:37:43.094289+03	f	f	5	37	57
1267	41/10 детали в 46/12	Забрать с БТК 41/10 и отвезти в 46/12 термичка	1	5	2025-04-08 13:15:00	3	74	8	\N	2025-04-08 13:07:01.121307+03	2025-04-08 14:09:32.100951+03	2025-04-08 13:02:45.06496+03	f	f	5	25	39
1268	41/10 отправка деталей	Отвезти детали с БТК 10корп. В 58ц 2 ящика	1	30	2025-04-08 13:15:00	3	74	8	\N	2025-04-08 13:16:10.817471+03	2025-04-08 14:09:50.979361+03	2025-04-08 13:13:50.234574+03	f	f	5	25	51
1277	Форма	Оснастка	8	5	2025-04-08 14:15:00	3	54	62	\N	2025-04-08 14:06:53.868938+03	2025-04-08 15:21:18.635824+03	2025-04-08 14:06:31.220468+03	t	f	\N	54	37
1279	Детали	Хим окс	1	1	2025-04-08 14:30:00	3	54	62	\N	2025-04-08 14:10:26.717691+03	2025-04-08 15:21:35.854182+03	2025-04-08 14:09:37.524581+03	t	f	\N	54	35
1243	Детали	В цех	4	3	2025-04-08 11:45:00	3	57	58	\N	2025-04-08 11:00:07.146447+03	2025-04-08 13:17:20.008504+03	2025-04-08 10:58:28.212667+03	t	f	5	39	43
1274	41 цех. Мусор	Мусор из 10-2	6	20	2025-04-08 14:30:00	3	39	8	\N	2025-04-08 14:04:18.349144+03	2025-04-08 14:23:00.944621+03	2025-04-08 13:47:48.670327+03	f	f	\N	26	57
1278	Детали	С 43 цеха в 44 цех	1	12	2025-04-08 12:30:00	3	33	60	\N	2025-04-08 14:08:09.848038+03	2025-04-08 14:23:06.666491+03	2025-04-08 14:07:57.340149+03	f	f	\N	31	35
1280	Детали	С 44 цеха в 43 цех	1	8	2025-04-08 13:00:00	3	33	60	\N	2025-04-08 14:10:40.786664+03	2025-04-08 14:23:20.020916+03	2025-04-08 14:10:28.437466+03	f	f	\N	34	31
1281	Крышки	С 45 цеха в 43 цех	9	10	2025-04-08 13:15:00	3	33	60	\N	2025-04-08 14:13:23.592155+03	2025-04-08 14:23:33.952564+03	2025-04-08 14:13:11.065556+03	f	f	\N	37	31
1266	41/10 отправка деталей	Забрать детали с БТК 41/10 и отвезти в 41/60	1	10	2025-04-08 13:15:00	3	74	8	\N	2025-04-08 13:07:12.492079+03	2025-04-08 14:10:14.111388+03	2025-04-08 13:00:13.626204+03	f	f	5	25	24
1263	Лепесток	В 44 цех	10	1	2025-04-08 13:00:00	3	20	58	\N	2025-04-08 12:49:19.30972+03	2025-04-08 13:15:09.896474+03	2025-04-08 12:47:38.116566+03	t	f	5	44	34
1259	Наконечник	В термичку	1	2	2025-04-08 12:45:00	3	20	58	\N	2025-04-08 12:43:03.09958+03	2025-04-08 13:15:32.87003+03	2025-04-08 12:39:38.261342+03	t	f	5	44	40
1285	Сбыт	С 43 цеха в 79 отдел	10	8	2025-04-08 14:30:00	3	33	60	\N	2025-04-08 15:05:14.53341+03	2025-04-08 15:47:38.965015+03	2025-04-08 15:05:03.758842+03	f	f	\N	31	61
1286	Изделия	С 43 цеха на 59 станцию	10	10	2025-04-08 15:15:00	3	33	60	\N	2025-04-08 15:14:00.47991+03	2025-04-08 15:47:46.786246+03	2025-04-08 15:13:43.497806+03	f	f	\N	31	53
1272	41-2 цех. Детали	Из 41 на 06	1	5	2025-04-08 14:00:00	3	39	8	\N	2025-04-08 14:01:31.407454+03	2025-04-08 14:08:58.616526+03	2025-04-08 13:34:38.804032+03	f	f	\N	24	1
1284	Вывоз мусора	Нет	6	50	2025-04-08 15:00:00	3	63	62	\N	2025-04-08 14:51:08.820804+03	2025-04-08 15:21:49.430478+03	2025-04-08 14:51:00.522585+03	t	f	\N	55	55
1270	Цех 45	Отвезти детали в 46 цех	1	1	2025-04-08 14:00:00	3	67	17	\N	2025-04-08 13:23:54.946328+03	2025-04-08 14:39:50.963801+03	2025-04-08 13:23:40.180083+03	f	f	5	37	43
1269	Вода	Нет	5	300	2025-04-08 13:30:00	3	16	61	\N	2025-04-08 13:17:36.858472+03	2025-04-08 14:24:50.956258+03	2025-04-08 13:17:33.032624+03	t	f	5	62	34
1265	Забрать трубы	Нет	4	500	2025-04-08 13:15:00	3	63	62	\N	2025-04-08 12:56:52.686151+03	2025-04-08 14:13:11.582073+03	2025-04-08 12:56:18.183053+03	t	f	\N	55	55
1271	Готовые детали	Нет	1	45	2025-04-08 13:30:00	3	16	8	\N	2025-04-08 13:30:51.211231+03	2025-04-08 14:09:09.930828+03	2025-04-08 13:26:56.841923+03	t	f	5	34	24
1282	Отборки	Со склада 6 отд ПДО в 43 цех	1	2	2025-04-08 13:30:00	3	33	60	\N	2025-04-08 14:15:32.276552+03	2025-04-08 14:23:42.787283+03	2025-04-08 14:15:14.733984+03	f	f	\N	2	31
1287	Готовые детали	Склад ПДО	1	10	2025-04-08 15:30:00	3	16	61	\N	2025-04-08 15:20:43.899015+03	2025-04-08 15:47:32.009853+03	2025-04-08 15:20:27.266779+03	t	f	5	34	63
1264	41	Отправка\n916894-ли\n916841\n916928	1	2	2025-04-08 13:30:00	3	30	8	\N	2025-04-08 12:56:53.660427+03	2025-04-08 14:09:22.062409+03	2025-04-08 12:51:44.868627+03	f	f	5	25	34
1273	46	46	10	2	2025-04-08 14:00:00	3	56	58	\N	2025-04-08 13:47:55.978762+03	2025-04-08 14:33:08.704523+03	2025-04-08 13:47:42.46324+03	f	f	\N	39	39
1290	Заготовки	В цез	4	4	2025-04-09 08:00:00	3	57	58	\N	2025-04-09 07:57:21.494642+03	2025-04-09 09:01:39.621117+03	2025-04-09 07:54:14.881666+03	f	f	5	38	43
1275	Детали	В 41 цех	4	10	2025-04-08 14:00:00	3	57	58	\N	2025-04-08 14:03:20.634618+03	2025-04-08 14:33:35.558744+03	2025-04-08 13:54:19.477117+03	f	f	5	39	24
1283	Вода	Вода	5	19	2025-04-08 14:30:00	3	57	58	\N	2025-04-08 14:32:42.32725+03	2025-04-08 15:22:44.432347+03	2025-04-08 14:24:10.149801+03	f	f	5	62	39
1288	Трубы на лучше	Нет	1	1	2025-04-09 09:00:00	3	47	40	AgACAgIAAxkBAAEBDpxn9RpjS__KS4HBGG8xuXI0r1VVVwAC5ugxGyOvqEvsaLpUx0L7DQEAAwIAA3kAAzYE	2025-04-08 15:46:42.155922+03	2025-04-09 10:25:30.067759+03	2025-04-08 15:45:33.571201+03	f	f	5	34	52
1292	41/10 отправка деталей	Детали с БТК 10корп. В 41/60 2уч	1	10	2025-04-09 08:30:00	3	74	8	\N	2025-04-09 07:58:53.894589+03	2025-04-09 09:10:46.423825+03	2025-04-09 07:56:23.337812+03	f	f	5	25	24
1296	Корпус	В 117 кабинете	1	15	2025-04-09 09:30:00	3	47	40	\N	2025-04-09 08:20:25.678225+03	2025-04-09 10:26:06.667051+03	2025-04-09 08:10:40.317783+03	t	f	5	51	52
1260	Отходы	Нет	6	100	2025-04-08 13:00:00	3	32	61	\N	2025-04-08 12:41:00.385538+03	2025-04-08 13:19:56.611051+03	2025-04-08 12:39:58.088769+03	t	f	5	34	57
1294	Замена баллонов с пропаном	Забрать пустой, отвезти на газовый склад	9	51	2025-04-09 10:30:00	3	19	58	\N	2025-04-09 08:05:29.345532+03	2025-04-09 13:24:07.59908+03	2025-04-09 07:59:47.68622+03	f	f	5	38	38
1295	Корпуса,шкалы	В 117 кабинете	1	10	2025-04-09 09:00:00	3	47	40	\N	2025-04-09 08:20:34.491583+03	2025-04-09 10:32:20.80418+03	2025-04-09 08:06:52.074334+03	t	f	5	51	34
1531	46	46	10	1	2025-04-11 14:00:00	3	56	58	\N	2025-04-11 13:44:51.902255+03	2025-04-11 14:33:07.03487+03	2025-04-11 13:31:24.822634+03	f	f	\N	43	52
1289	Заготовки	На лазер	4	3	2025-04-09 08:00:00	3	57	58	\N	2025-04-09 07:57:01.923858+03	2025-04-09 09:01:16.668446+03	2025-04-09 07:53:00.198473+03	f	f	\N	38	67
1303	41/10 на уч.промывки	Отвезти детали с 41/10 в 41/60-2 на уч.промывки	1	10	2025-04-09 08:30:00	3	74	8	\N	2025-04-09 08:32:31.658692+03	2025-04-09 09:10:32.02173+03	2025-04-09 08:31:21.979121+03	f	f	5	25	24
1536	Химия на прокаливание	Нет	1	8	2025-04-11 12:15:00	3	33	60	\N	2025-04-11 13:44:26.091404+03	2025-04-11 13:56:23.545857+03	2025-04-11 13:44:14.706749+03	f	f	\N	31	39
1298	Индикаторный силикагель	12 пакетиков забрать с упаковки	9	1	2025-04-09 09:45:00	3	47	40	\N	2025-04-09 08:20:08.873272+03	2025-04-09 15:21:33.910383+03	2025-04-09 08:19:38.532653+03	t	f	5	51	43
1304	41	Отправка\n6т8301218*\n0612394\n6т7732020\n918182ЛИ\n6т8221032	1	3	2025-04-09 09:00:00	3	30	8	\N	2025-04-09 08:35:24.767652+03	2025-04-09 09:09:52.91275+03	2025-04-09 08:35:16.825108+03	f	f	5	25	34
1538	Сердечники	Нет	1	8	2025-04-11 12:15:00	3	33	60	\N	2025-04-11 13:46:37.931135+03	2025-04-11 13:56:33.185427+03	2025-04-11 13:46:25.859211+03	f	f	\N	31	40
1541	Детали	Нет	1	18	2025-04-11 13:00:00	3	33	60	\N	2025-04-11 13:52:06.331293+03	2025-04-11 13:56:56.405016+03	2025-04-11 13:51:54.136981+03	f	f	\N	31	24
1539	Детали	Нет	1	5	2025-04-11 12:30:00	3	33	60	\N	2025-04-11 13:48:36.449351+03	2025-04-11 13:56:39.429607+03	2025-04-11 13:48:23.630803+03	f	f	\N	34	31
1306	45цех	Спец.одежда из стирки	9	10	2025-04-09 08:00:00	3	22	17	\N	2025-04-09 08:37:34.749108+03	2025-04-09 10:13:58.434134+03	2025-04-09 08:37:06.37802+03	t	f	\N	37	6
1299	040 переключатель	Забрать с 46 цеха, 2 этаж, основной корпус	1	1	2025-04-09 10:00:00	3	47	58	\N	2025-04-09 08:25:12.056203+03	2025-04-09 09:51:58.525484+03	2025-04-09 08:20:50.923651+03	t	f	5	43	51
1300	41-2 цех. Вода	Вода в 41 цех	5	160	2025-04-09 09:30:00	3	39	8	\N	2025-04-09 08:31:53.478134+03	2025-04-09 10:26:50.377755+03	2025-04-09 08:24:04.437483+03	f	f	5	62	24
1537	Фланцы, по чьей-то ошибке увезенные в 945	Нет	1	88	2025-04-11 14:00:00	3	9	8	AgACAgIAAxkBAAEBOgVn-PLSBGR_-1Yw3Jw_72gc6O-FWQACx-kxG9ILyEtaainkalOItgEAAwIAA3kAAzYE	2025-04-11 13:57:42.974023+03	2025-04-11 14:29:19.512555+03	2025-04-11 13:45:55.780876+03	t	f	\N	64	25
1302	41-2 цех	Опилки	9	60	2025-04-09 09:00:00	3	39	40	\N	2025-04-09 09:30:35.503694+03	2025-04-09 15:18:59.205456+03	2025-04-09 08:26:30.112007+03	f	f	5	26	46
1543	Цех 45	Отвезти детали на склад ПДО	1	3	2025-04-11 14:00:00	3	67	17	\N	2025-04-11 14:09:35.637565+03	2025-04-11 14:44:15.205631+03	2025-04-11 14:07:16.891107+03	f	f	5	37	2
1313	46	46	10	2	2025-04-09 09:00:00	3	56	58	\N	2025-04-09 08:59:15.080767+03	2025-04-09 09:52:27.962194+03	2025-04-09 08:54:10.482648+03	f	f	\N	43	35
1341	Заготовки	В цех	4	2	2025-04-09 12:30:00	3	57	58	\N	2025-04-09 12:30:34.126541+03	2025-04-09 12:54:21.804777+03	2025-04-09 12:29:53.551957+03	f	f	5	38	43
1314	46	46	10	2	2025-04-09 09:00:00	3	56	58	\N	2025-04-09 08:59:59.35019+03	2025-04-09 09:52:33.842414+03	2025-04-09 08:55:29.09671+03	f	f	\N	43	52
1315	46	46	10	2	2025-04-09 09:00:00	3	56	58	\N	2025-04-09 09:00:06.085503+03	2025-04-09 09:52:40.087097+03	2025-04-09 08:56:45.849456+03	f	f	\N	43	41
1318	Забрать пк с 39 отдела, привезти в основной корпус	Забрать пк с 39 отдела, привезти в основной корпус	9	3	2025-04-09 09:15:00	3	19	58	\N	2025-04-09 09:01:31.436919+03	2025-04-09 09:51:49.091173+03	2025-04-09 09:01:16.307993+03	f	f	5	22	43
1291	Лазерные детали	Забрать детали  с лазера, привезти в  основной корпус	1	5	2025-04-09 08:15:00	3	19	58	\N	2025-04-09 07:57:14.896486+03	2025-04-09 09:01:45.962707+03	2025-04-09 07:54:47.323751+03	f	f	5	67	43
1326	Штамп	Оснастка	8	3	2025-04-09 10:45:00	3	54	62	\N	2025-04-09 10:36:22.158998+03	2025-04-09 10:55:55.727552+03	2025-04-09 10:36:06.005162+03	t	f	\N	54	43
1308	45цех	Получить инструмент	8	10	2025-04-09 10:00:00	3	22	17	\N	2025-04-09 08:42:43.509662+03	2025-04-09 10:14:12.745533+03	2025-04-09 08:42:27.05619+03	f	f	\N	15	37
1309	45цех	сдать мерительный инструмент для проверки	8	5	2025-04-09 10:30:00	3	22	17	\N	2025-04-09 08:46:02.229142+03	2025-04-09 10:14:23.47709+03	2025-04-09 08:45:31.032244+03	f	f	\N	37	21
1317	Детали	Нет	1	5	2025-04-09 09:00:00	3	16	8	\N	2025-04-09 08:58:15.352617+03	2025-04-09 09:09:40.088088+03	2025-04-09 08:57:50.358582+03	t	f	5	34	24
1297	41-2 цех детали	Детали	1	10	2025-04-09 09:00:00	3	39	8	\N	2025-04-09 08:19:56.275202+03	2025-04-09 09:10:14.27485+03	2025-04-09 08:19:04.060232+03	f	f	5	24	34
1310	45цех	сдать инструмент	8	10	2025-04-09 13:00:00	3	22	17	\N	2025-04-09 08:47:59.698072+03	2025-04-09 10:14:40.566531+03	2025-04-09 08:47:40.42705+03	f	f	\N	37	21
1307	Забрать спецодежду со стирки	Нет	4	5	2025-04-09 09:00:00	3	63	62	\N	2025-04-09 08:43:53.310373+03	2025-04-09 09:22:43.52958+03	2025-04-09 08:41:46.564521+03	t	f	\N	6	45
1311	Детали	Термообработка	1	1	2025-04-09 09:00:00	3	54	62	\N	2025-04-09 08:48:32.553681+03	2025-04-09 09:22:51.872731+03	2025-04-09 08:48:14.397858+03	t	f	\N	54	39
1319	ПКИ	Со склада ПКИ 14 отд в 43 цех	4	15	2025-04-09 08:30:00	3	33	60	\N	2025-04-09 09:14:35.738696+03	2025-04-09 09:23:56.716736+03	2025-04-09 09:14:24.742932+03	f	f	\N	8	31
1320	Рекламация	С 28 отд в 43 цех	10	20	2025-04-09 08:30:00	3	33	60	\N	2025-04-09 09:17:14.365194+03	2025-04-09 09:24:16.13383+03	2025-04-09 09:17:04.564607+03	f	f	\N	68	31
1322	Халаты спец одежда	С прачечной в 43 цех	9	20	2025-04-09 08:30:00	3	33	60	\N	2025-04-09 09:22:51.657411+03	2025-04-09 09:24:23.110201+03	2025-04-09 09:22:39.331295+03	f	f	\N	6	31
1312	Одежда	Нет	9	10	2025-04-09 08:45:00	3	16	61	\N	2025-04-09 08:52:59.689538+03	2025-04-09 09:24:19.771488+03	2025-04-09 08:52:55.873186+03	t	f	5	6	34
1336	Установка проверки поплавков в глицерине	Нет	9	20	2025-04-09 12:15:00	3	32	61	\N	2025-04-09 12:06:44.596202+03	2025-04-09 13:45:58.164488+03	2025-04-09 12:06:34.871631+03	t	f	5	14	34
1335	41/10 отправка деталей	Забрать с загот.уч. детали 6т8020210 и 6т8074524 (2ящика) и отвезти в термичку 46/12	1	15	2025-04-09 12:30:00	3	74	8	\N	2025-04-09 12:07:14.769312+03	2025-04-09 12:49:37.041745+03	2025-04-09 11:55:33.128853+03	f	f	5	26	39
1330	Изделия	С 59 станции в 43 цех	10	5	2025-04-09 09:30:00	3	33	60	\N	2025-04-09 11:07:35.018894+03	2025-04-09 11:07:57.033523+03	2025-04-09 11:07:22.955844+03	f	f	\N	53	31
1333	46	46	10	2	2025-04-09 12:00:00	3	56	58	\N	2025-04-09 11:56:00.592413+03	2025-04-09 12:27:03.292299+03	2025-04-09 11:50:09.051153+03	f	f	\N	43	35
1324	Пылесос Karcher	Отвезти в ремонт пылесос Karcher из 58 цеха комната 203 в электро-ремонтный цех 63 корп.50 1 этаж	9	5	2025-04-09 13:00:00	3	50	40	\N	2025-04-09 10:17:40.090395+03	2025-04-09 10:24:59.355022+03	2025-04-09 10:17:14.396432+03	f	f	5	51	34
1323	Химия	Нет	9	15	2025-04-09 10:15:00	3	47	40	\N	2025-04-09 09:45:33.103815+03	2025-04-09 10:25:12.361477+03	2025-04-09 09:45:23.685088+03	t	f	5	12	51
1316	Прокладка	На масло	1	1	2025-04-09 09:00:00	3	20	58	\N	2025-04-09 08:59:25.518419+03	2025-04-09 09:51:40.652925+03	2025-04-09 08:57:36.150759+03	f	f	5	44	37
1325	Готовые детали	На склад ПДО	1	10	2025-04-09 10:30:00	3	16	61	\N	2025-04-09 10:25:18.821229+03	2025-04-09 10:56:11.666286+03	2025-04-09 10:25:15.796937+03	t	f	5	34	63
1327	Детали	Детали	1	10	2025-04-09 14:00:00	3	79	8	\N	2025-04-09 10:44:54.780474+03	2025-04-09 11:03:20.357771+03	2025-04-09 10:37:55.92672+03	f	f	5	2	51
1328	Заготовки	В цех	4	3	2025-04-09 12:00:00	3	57	58	\N	2025-04-09 10:54:33.663107+03	2025-04-09 12:54:28.163131+03	2025-04-09 10:53:54.069763+03	f	f	5	39	43
1301	41-2 цех. Вода	Вода в 10 корпус	5	240	2025-04-09 13:30:00	3	39	8	\N	2025-04-09 08:31:34.692381+03	2025-04-09 10:26:42.556253+03	2025-04-09 08:24:59.687337+03	f	f	5	62	26
1332	2 шкафа инструментальных (всего 4 шкафа - будет заказана ещё одна кара) \nИз склада отдела оборудования в корпус 10.\nВремя критично - 12:30, будет ожидать кладовщица. Нужна погрузка и разгрузка. \nИз 75-93 в корпус 10 (2-я кара)	Шкафы (3 и 4 й)	9	100	2025-04-09 12:30:00	3	9	40	AgACAgIAAxkBAAEBFmRn9i7h3-ls0NbTGsWAwLdFO3lAdAACFeoxG1gGsEuDOYd3QjsZTwEAAwIAA3kAAzYE	2025-04-09 12:01:07.283027+03	2025-04-09 12:41:39.578338+03	2025-04-09 11:42:33.416906+03	t	f	5	11	25
1329	Заготовки	В цех	4	1	2025-04-09 11:00:00	3	57	58	\N	2025-04-09 10:55:36.878461+03	2025-04-09 11:12:09.856471+03	2025-04-09 10:55:27.429431+03	f	f	5	40	43
1334	46	46	10	2	2025-04-09 12:00:00	3	56	58	\N	2025-04-09 11:56:43.407565+03	2025-04-09 12:26:15.406471+03	2025-04-09 11:51:11.814629+03	f	f	\N	43	52
1342	Цех 45	Забрать материал со склада	4	20	2025-04-09 14:00:00	3	67	17	\N	2025-04-09 12:31:59.672443+03	2025-04-09 15:21:37.982561+03	2025-04-09 12:31:51.536964+03	f	f	5	12	37
1337	Детали	В цех	4	1	2025-04-09 12:30:00	3	57	58	\N	2025-04-09 12:27:24.401744+03	2025-04-09 12:28:47.172038+03	2025-04-09 12:27:10.700437+03	f	f	\N	40	43
1339	Заготовки	На лазер	4	1	2025-04-09 12:30:00	3	57	58	\N	2025-04-09 12:29:10.700265+03	2025-04-09 12:54:13.981267+03	2025-04-09 12:28:05.837744+03	f	f	5	38	67
1338	Цех 45	Отвезти детали на склад ПДО	1	3	2025-04-09 14:00:00	3	67	17	\N	2025-04-09 12:27:53.815794+03	2025-04-09 15:21:17.259303+03	2025-04-09 12:27:41.567913+03	f	f	5	37	2
1345	Кислота	Канистры	4	500	2025-04-09 13:15:00	3	34	61	\N	2025-04-09 13:04:57.026205+03	2025-04-09 13:46:17.469353+03	2025-04-09 13:04:51.112543+03	t	f	5	59	34
1346	41/10 детали	Детали из бтк на 2уч 41/60	1	3	2025-04-09 13:15:00	3	74	8	\N	2025-04-09 13:16:31.480707+03	2025-04-09 13:33:02.99915+03	2025-04-09 13:13:40.1926+03	f	f	5	25	24
1340	Цех 45	Забрать принтер из ремонта	9	5	2025-04-09 13:00:00	3	67	17	\N	2025-04-09 12:29:42.559074+03	2025-04-09 15:21:27.932074+03	2025-04-09 12:29:32.397384+03	f	f	5	22	37
1344	040 переключатель	В 117 кабинете	1	1	2025-04-09 13:15:00	3	47	62	\N	2025-04-09 13:07:28.388414+03	2025-04-09 13:16:36.272272+03	2025-04-09 12:57:31.50716+03	t	f	5	51	52
1321	Готовые детали	Нет	1	40	2025-04-09 09:30:00	3	16	60	AgACAgIAAxkBAAEBE2xn9hGiyh_OAlPOPeNwgAzIs0dP7AACafExGycasUsXdm3ArdWGGQEAAwIAA3kAAzYE	2025-04-09 09:46:44.211194+03	2025-04-09 13:29:30.235373+03	2025-04-09 09:20:26.00656+03	t	f	\N	34	31
1347	Детали	В 41 цех	4	6	2025-04-09 13:30:00	3	57	58	\N	2025-04-09 13:24:20.801345+03	2025-04-09 13:44:13.354478+03	2025-04-09 13:23:41.589318+03	f	f	5	39	24
1362	Колесо	Детали на 2 этаже	10	1	2025-04-09 14:45:00	3	20	58	\N	2025-04-09 14:39:37.316775+03	2025-04-09 15:35:30.908688+03	2025-04-09 14:37:55.851701+03	t	f	5	43	35
1331	2 шкафа инструментальных (всего 4 шкафа - будет заказана ещё одна кара) \nИз склада отдела оборудования в корпус 10.\nВремя критично - 12:30, будет ожидать кладовщица. Нужна погрузка и разгрузка. \nИз 75-93 в корпус 10	Шкафы	9	100	2025-04-09 12:30:00	3	9	8	AgACAgIAAxkBAAEBFmRn9i7h3-ls0NbTGsWAwLdFO3lAdAACFeoxG1gGsEuDOYd3QjsZTwEAAwIAA3kAAzYE	2025-04-09 11:25:42.003491+03	2025-04-09 12:41:03.776305+03	2025-04-09 11:25:17.547214+03	t	f	5	11	25
1343	Забрать детали с термички	Нет	1	10	2025-04-09 13:00:00	3	63	62	\N	2025-04-09 12:44:45.444137+03	2025-04-09 13:25:17.331782+03	2025-04-09 12:44:27.565879+03	t	f	\N	39	55
1361	Наконечник	Детали на 2 этаже	10	1	2025-04-09 14:45:00	3	20	58	\N	2025-04-09 14:39:51.844918+03	2025-04-09 15:35:35.855449+03	2025-04-09 14:37:15.056687+03	t	f	5	43	35
1373	41 цех	Ангар 73корп>деталан АЛ >60/2,3этаж,промывка	9	100	2025-04-10 09:30:00	3	42	40	\N	2025-04-10 08:42:20.345653+03	2025-04-10 10:11:56.422574+03	2025-04-09 15:47:53.621895+03	f	f	\N	12	24
1351	41-2 цех. Стружка СРОЧНО	Стружка СРОЧНО	6	300	2025-04-09 14:00:00	3	39	8	\N	2025-04-09 14:53:07.924628+03	2025-04-09 14:53:37.254573+03	2025-04-09 13:50:02.263537+03	t	f	5	25	57
1348	41-2 цех. Детали.	Развозка деталей	1	50	2025-04-09 14:00:00	3	39	8	\N	2025-04-09 13:48:10.978329+03	2025-04-09 14:53:48.011837+03	2025-04-09 13:47:54.222254+03	f	f	5	24	34
1387	Детали	Термообработка	1	2	2025-04-10 08:45:00	3	54	62	\N	2025-04-10 08:33:52.725414+03	2025-04-10 09:11:38.551212+03	2025-04-10 08:33:11.836029+03	t	f	\N	54	39
1353	Детали	Форма	1	5	2025-04-09 14:15:00	3	54	62	\N	2025-04-09 13:58:00.063779+03	2025-04-09 14:30:12.911496+03	2025-04-09 13:57:30.490584+03	t	f	\N	54	34
1379	Стружка	2 ящика со структурой отвезти на базу и пустую тару обратно	11	35	2025-04-10 09:30:00	3	64	8	\N	2025-04-10 08:31:07.939471+03	2025-04-10 09:30:14.062897+03	2025-04-10 08:08:46.942544+03	f	f	5	63	57
1381	Заготовки	В цех	4	1	2025-04-10 08:15:00	3	57	58	\N	2025-04-10 08:15:50.682461+03	2025-04-10 11:26:41.82326+03	2025-04-10 08:13:03.089816+03	f	f	\N	38	43
1355	41 цех	55корп, деталанАЛ>60-2,3 этаж,промывка	9	100	2025-04-09 14:30:00	3	42	8	\N	2025-04-09 14:54:12.086341+03	2025-04-09 14:54:22.596848+03	2025-04-09 14:00:49.501344+03	f	f	\N	8	24
1374	41/10 отправка деталей	Забрать детали из бтк 10корп.и отвезти в 41/60	1	20	2025-04-10 08:15:00	3	74	8	\N	2025-04-10 08:05:17.174495+03	2025-04-10 09:14:16.196386+03	2025-04-10 07:59:26.379901+03	f	f	5	25	24
1360	41-2 цех. Мусор	Мусор	7	50	2025-04-09 14:45:00	3	39	8	\N	2025-04-09 14:37:36.368819+03	2025-04-09 14:52:10.646006+03	2025-04-09 14:36:46.435533+03	f	f	\N	24	57
1349	46	46	10	4	2025-04-09 14:00:00	3	56	58	\N	2025-04-09 13:51:13.000789+03	2025-04-09 15:35:45.141779+03	2025-04-09 13:48:03.994613+03	f	f	\N	43	24
1358	Проф трубы 20х20   6м	7шт	4	30	2025-04-09 15:00:00	3	32	61	\N	2025-04-09 14:27:22.754379+03	2025-04-09 15:06:50.477911+03	2025-04-09 14:27:18.845401+03	t	f	5	34	14
1354	41 цех	55 корп, жидкость для промывки деталан ф-10, 180л, промывка, 10корп	9	180	2025-04-09 14:30:00	3	42	8	\N	2025-04-09 14:48:57.677896+03	2025-04-09 14:53:21.391602+03	2025-04-09 13:58:54.444503+03	f	f	\N	8	26
1350	46	46	10	2	2025-04-09 14:00:00	3	56	58	\N	2025-04-09 13:51:25.005541+03	2025-04-09 15:35:50.006652+03	2025-04-09 13:49:01.495316+03	f	f	\N	43	2
1356	Заготовка	В цех	4	1	2025-04-09 14:15:00	3	57	58	\N	2025-04-09 14:15:52.381119+03	2025-04-09 15:35:40.716252+03	2025-04-09 14:15:20.918143+03	f	f	5	38	43
1352	46	46	10	2	2025-04-09 14:00:00	3	56	58	\N	2025-04-09 13:51:31.613938+03	2025-04-09 15:35:54.455392+03	2025-04-09 13:50:23.461236+03	f	f	\N	43	35
1377	41	Перевозка мусора	7	150	2025-04-10 09:00:00	3	30	8	\N	2025-04-10 08:07:04.597813+03	2025-04-10 08:57:42.396767+03	2025-04-10 08:03:53.771202+03	f	f	5	26	54
1376	41/10 вывоз настроечных деталей	Вывезти из бтк 10 корп.настроечные детали в утильбазу	6	100	2025-04-10 08:30:00	3	74	8	\N	2025-04-10 08:05:34.22343+03	2025-04-10 13:13:11.880273+03	2025-04-10 08:03:17.788632+03	f	f	5	25	57
1363	Детали	С 43 цеха в 41 цех	1	6	2025-04-09 12:30:00	3	33	60	\N	2025-04-09 15:14:08.434023+03	2025-04-09 15:25:25.893861+03	2025-04-09 15:13:58.416825+03	f	f	\N	31	24
1364	Детали	С 43 цеха в 44 цех	1	5	2025-04-09 12:30:00	3	33	60	\N	2025-04-09 15:16:26.35555+03	2025-04-09 15:25:33.45361+03	2025-04-09 15:16:14.317089+03	f	f	\N	31	35
1365	Отборки	Со склада 6 отд ПДО в 43 цех	1	2	2025-04-09 13:00:00	3	33	60	\N	2025-04-09 15:18:00.326079+03	2025-04-09 15:25:40.203886+03	2025-04-09 15:17:52.65044+03	f	f	\N	2	31
1366	Изделия	2ка с 43 цеха на 40 участок	10	15	2025-04-09 13:30:00	3	33	60	\N	2025-04-09 15:20:04.660538+03	2025-04-09 15:25:47.276783+03	2025-04-09 15:19:58.412453+03	f	f	\N	31	23
1367	Утиль трубы	Нет	7	30	2025-04-09 14:00:00	3	33	60	\N	2025-04-09 15:22:36.743105+03	2025-04-09 15:25:53.606168+03	2025-04-09 15:22:30.28847+03	f	f	\N	31	57
1368	Макулатура	Нет	9	30	2025-04-09 14:00:00	3	33	60	\N	2025-04-09 15:25:10.600573+03	2025-04-09 15:26:02.200625+03	2025-04-09 15:25:04.693257+03	f	f	\N	31	57
1370	Изделия	С 43 цеха на 59 станцию	10	5	2025-04-09 15:15:00	3	33	60	\N	2025-04-09 15:39:52.323872+03	2025-04-09 15:41:16.516083+03	2025-04-09 15:39:45.980054+03	f	f	\N	31	53
1371	Сбыт	С 43 цеха в 79 отдел	10	5	2025-04-09 15:15:00	3	33	60	\N	2025-04-09 15:41:05.281034+03	2025-04-09 15:41:22.963195+03	2025-04-09 15:40:53.998519+03	f	f	\N	31	61
1357	Бытовые отходы,производственные отходы	Нет	7	100	2025-04-10 09:00:00	3	32	61	\N	2025-04-10 08:44:27.230752+03	2025-04-10 10:26:25.393441+03	2025-04-09 14:21:17.345738+03	f	f	5	36	57
1359	Трубы с трубного участка на сварку	Трубы с трубного участка на сварку	1	10	2025-04-09 14:45:00	3	19	58	\N	2025-04-09 14:33:19.376457+03	2025-04-09 15:35:25.154251+03	2025-04-09 14:32:14.704578+03	t	f	5	41	43
1388	41-2 цех. Стружка СРОЧНО	Стружка СРОЧНО	11	200	2025-04-10 09:00:00	3	39	8	\N	2025-04-10 10:16:50.995053+03	2025-04-10 13:12:56.487861+03	2025-04-10 08:33:30.044439+03	t	f	\N	25	57
1380	Мусор	Вывоз мусора 1 ящик , и обратно пустую тару	7	10	2025-04-10 09:30:00	3	64	8	\N	2025-04-10 08:31:48.720823+03	2025-04-10 09:29:57.781479+03	2025-04-10 08:12:37.305158+03	f	f	5	63	57
1382	41-2 цех. Детали	Развозка деталей	1	15	2025-04-10 09:00:00	3	39	8	\N	2025-04-10 08:32:01.180996+03	2025-04-10 09:12:59.039107+03	2025-04-10 08:18:38.624535+03	t	f	\N	24	2
1375	41	Отправка\n6т8315290-01\n6т8223024	1	1	2025-04-10 08:30:00	3	30	8	\N	2025-04-10 08:05:02.875728+03	2025-04-10 09:13:33.877214+03	2025-04-10 07:59:33.276636+03	f	f	5	25	35
1384	41	Межоперационка \n0131529\n0151777\nОт Тамары к Анны Игоревны	1	5	2025-04-10 10:30:00	3	30	8	\N	2025-04-10 08:31:21.243574+03	2025-04-10 09:12:43.010118+03	2025-04-10 08:25:34.81048+03	f	f	5	24	26
1544	Цех 45	Отвезти детали в 58 цех	1	2	2025-04-11 14:15:00	3	67	17	\N	2025-04-11 14:11:19.30712+03	2025-04-11 14:44:30.324251+03	2025-04-11 14:11:00.335535+03	f	f	5	37	51
1372	41 цех	Ангар 73корп> деталан ф-10> 10 корп промывка	9	180	2025-04-10 09:30:00	3	42	40	\N	2025-04-10 08:42:52.994261+03	2025-04-10 10:00:40.286382+03	2025-04-09 15:45:42.898132+03	f	f	\N	12	26
1385	41	Межоперационка \n0366729 \nИз кладовой на шлифовка к Травину	1	10	2025-04-10 12:00:00	3	30	8	\N	2025-04-10 08:31:37.360617+03	2025-04-10 09:12:28.692656+03	2025-04-10 08:27:19.226951+03	f	f	\N	24	28
1369	Готовые детали	Нет	1	1	2025-04-09 15:30:00	3	16	61	\N	2025-04-09 15:35:26.526987+03	2025-04-09 15:51:15.184235+03	2025-04-09 15:35:20.458472+03	t	f	5	34	2
1408	Карточка	Аварийно	9	1	2025-04-10 10:30:00	3	20	58	\N	2025-04-10 10:07:26.391043+03	2025-04-10 11:15:22.289831+03	2025-04-10 10:06:20.964702+03	t	f	5	44	38
1402	Штампы	Нет	8	3	2025-04-10 10:00:00	3	20	58	\N	2025-04-10 09:53:40.886226+03	2025-04-10 11:16:02.399397+03	2025-04-10 09:53:35.747477+03	t	f	5	44	55
1397	Шайба	Будет на 2 этаже	10	1	2025-04-10 09:00:00	3	20	58	\N	2025-04-10 08:54:19.714755+03	2025-04-10 10:05:31.886792+03	2025-04-10 08:53:18.485897+03	t	f	5	43	35
1396	Прокладки	На масло	1	2	2025-04-10 09:00:00	3	20	58	\N	2025-04-10 08:48:03.097943+03	2025-04-10 11:25:55.739568+03	2025-04-10 08:47:21.127507+03	t	f	5	44	37
1392	Панели	В термичку АВАРИЙНО	1	2	2025-04-10 09:00:00	3	20	58	\N	2025-04-10 08:46:00.213977+03	2025-04-10 11:26:17.48591+03	2025-04-10 08:45:22.469678+03	t	f	5	44	40
1403	41	Отправка	1	1	2025-04-10 10:00:00	3	30	8	\N	2025-04-10 09:59:37.17717+03	2025-04-10 10:11:52.670323+03	2025-04-10 09:58:44.447749+03	f	f	5	25	63
1378	41/10 детали	Забрать с загот.уч.детали 6т8057020 (1ящик) и отвезти 46/12 термичка	1	15	2025-04-10 08:30:00	3	74	8	\N	2025-04-10 08:07:24.17281+03	2025-04-10 09:13:55.620774+03	2025-04-10 08:05:02.834782+03	f	f	5	26	39
1390	172 корпуса	Аварийно!!!	1	20	2025-04-10 08:45:00	3	16	40	\N	2025-04-10 08:42:12.938542+03	2025-04-10 09:02:15.740742+03	2025-04-10 08:41:57.820877+03	t	f	5	34	52
1410	Вода	Забрать из 946 бутылки, обменять в к94. +уч 40 3 бутылки	5	200	2025-04-10 13:30:00	3	14	8	\N	2025-04-10 10:20:13.49447+03	2025-04-10 13:39:58.48439+03	2025-04-10 10:19:31.269175+03	t	f	5	66	66
1401	Вода	Забрать пустые бутыли и привезти полные с водой	5	160	2025-04-10 10:00:00	3	64	8	\N	2025-04-10 10:20:31.271064+03	2025-04-10 13:40:18.858889+03	2025-04-10 09:33:32.721517+03	f	f	5	63	62
1389	41-2 цех. Мусор СРОЧНО	Вывоз мусора из литейки срочно	7	200	2025-04-10 09:00:00	3	39	8	\N	2025-04-10 09:39:20.950987+03	2025-04-10 09:39:31.882796+03	2025-04-10 08:35:47.201288+03	t	f	\N	27	57
1391	46	46	10	2	2025-04-10 09:00:00	3	56	58	\N	2025-04-10 08:48:27.801033+03	2025-04-10 09:57:22.415665+03	2025-04-10 08:44:33.67545+03	f	f	\N	43	24
1394	46	46	10	2	2025-04-10 09:00:00	3	56	58	\N	2025-04-10 08:48:41.95351+03	2025-04-10 09:57:52.110527+03	2025-04-10 08:46:21.624292+03	f	f	\N	43	39
1400	Получить воду	Нет	5	100	2025-04-10 10:00:00	3	63	62	\N	2025-04-10 09:24:48.835528+03	2025-04-10 10:26:02.741484+03	2025-04-10 09:24:24.718907+03	t	f	\N	55	55
1399	Забрать трубы со склада	Нет	4	300	2025-04-10 09:30:00	3	63	62	\N	2025-04-10 09:25:40.444115+03	2025-04-10 10:09:53.278608+03	2025-04-10 09:23:38.489431+03	t	f	\N	55	55
1395	Панели	В термичку на 12 участок	1	3	2025-04-10 09:00:00	3	20	58	\N	2025-04-10 08:49:06.283681+03	2025-04-10 10:04:32.432766+03	2025-04-10 08:46:41.693308+03	t	f	5	44	39
1398	Ортофосфорная кислота	Канистры	4	550	2025-04-10 10:15:00	3	34	61	\N	2025-04-10 08:57:47.373557+03	2025-04-10 10:28:00.483132+03	2025-04-10 08:57:43.155791+03	t	f	5	12	34
1409	Приспособление	Оснастка	8	3	2025-04-10 10:30:00	3	54	58	\N	2025-04-10 10:16:24.813702+03	2025-04-10 11:13:47.883183+03	2025-04-10 10:16:22.869799+03	t	f	\N	54	43
1386	Детали с деревяшки	Забрать детали с деревянного цеха 52	1	0.1	2025-04-10 09:15:00	3	19	58	\N	2025-04-10 08:33:43.211029+03	2025-04-10 10:04:59.722221+03	2025-04-10 08:31:57.531204+03	f	f	5	48	43
1405	Кожух	В 117 кабинете	1	1	2025-04-10 10:30:00	3	47	40	\N	2025-04-10 10:01:41.201987+03	2025-04-10 10:11:47.346881+03	2025-04-10 10:01:13.524965+03	t	f	5	51	34
1383	Детали	Получить со склада 11-1 детали 6т8627003-1 6шт и привести в 41цех 60-2 на 3 этаж кладовая	1	3	2025-04-10 09:00:00	3	41	8	\N	2025-04-10 08:32:27.091808+03	2025-04-10 09:39:58.810469+03	2025-04-10 08:24:21.923748+03	f	f	5	2	24
1406	Детали	В цех	4	3	2025-04-10 10:15:00	3	57	58	\N	2025-04-10 10:09:39.948528+03	2025-04-10 11:14:23.732595+03	2025-04-10 10:04:40.889408+03	f	f	\N	39	43
1407	Детали	В цех	4	1	2025-04-10 10:15:00	3	57	58	\N	2025-04-10 10:09:30.017531+03	2025-04-10 11:14:40.998255+03	2025-04-10 10:05:27.492775+03	f	f	\N	40	43
1545	Цех 45	Отвезти детали в 41 цех	1	3	2025-04-11 14:30:00	3	67	17	\N	2025-04-11 14:12:42.722134+03	2025-04-11 14:44:47.40266+03	2025-04-11 14:12:27.628969+03	f	f	5	37	24
1404	Отвезти компьютер	Отвезти компьютер из 60-4-2 в 39 отдел администраторам	9	5	2025-04-10 10:00:00	3	19	58	\N	2025-04-10 10:02:13.955743+03	2025-04-10 11:15:35.484258+03	2025-04-10 09:59:57.700654+03	f	f	5	43	22
1411	Труб	Нет	1	10	2025-04-10 10:30:00	3	72	58	\N	2025-04-10 10:22:59.907477+03	2025-04-10 11:14:00.781746+03	2025-04-10 10:19:52.946663+03	t	f	5	41	24
1393	46	46	10	3	2025-04-10 09:00:00	3	56	58	\N	2025-04-10 08:48:34.575503+03	2025-04-10 11:26:51.413508+03	2025-04-10 08:45:31.474535+03	f	f	\N	43	35
1546	41-2 цех. Детали	Отвезти футорку в Техприбор ИС	1	20	2025-04-11 14:30:00	3	39	8	\N	2025-04-11 14:30:11.560587+03	2025-04-11 15:22:27.27515+03	2025-04-11 14:15:59.890208+03	f	f	\N	24	20
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.roles ("idRole", "roleName") FROM stdin;
1	Диспетчер
2	Водитель
3	Администратор
4	Тестовый объект роли пользователя
\.


--
-- Data for Name: time_coefficent; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.time_coefficent (time_coefficent_id, value, coefficent) FROM stdin;
1	60	1
\.


--
-- Data for Name: userLocations; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public."userLocations" (id, user_id, latitude, longitude, "timestamp", created_at) FROM stdin;
1	2	59.924219	30.498458	2025-03-26 20:09:55+03	2025-03-26 20:09:56.344021+03
2	2	59.924241	30.498484	2025-03-26 20:22:04+03	2025-03-26 20:22:05.241618+03
3	2	59.924184	30.498476	2025-03-26 20:23:37+03	2025-03-26 20:23:37.881585+03
4	2	59.924206	30.498502	2025-03-26 20:31:03+03	2025-03-26 20:31:03.717698+03
5	2	59.924171	30.49852	2025-03-26 20:32:03+03	2025-03-26 20:32:04.015506+03
6	2	59.924211	30.498497	2025-03-26 20:32:03+03	2025-03-26 20:32:40.287195+03
7	2	59.924176	30.498515	2025-03-26 20:35:49+03	2025-03-26 20:36:26.11881+03
8	2	59.92416	30.498675	2025-03-26 20:35:49+03	2025-03-26 20:36:56.829532+03
9	2	59.924177	30.498515	2025-03-26 20:35:49+03	2025-03-26 20:37:27.322571+03
10	2	59.924167	30.498446	2025-03-26 20:35:49+03	2025-03-26 20:37:58.232182+03
11	2	59.924146	30.49842	2025-03-26 20:35:49+03	2025-03-26 20:38:58.844366+03
12	2	59.924177	30.498515	2025-03-26 20:35:49+03	2025-03-26 20:39:29.379388+03
13	2	59.924199	30.498542	2025-03-26 20:35:49+03	2025-03-26 20:39:59.451404+03
14	2	59.92419	30.498473	2025-03-26 20:35:49+03	2025-03-26 20:40:30.184658+03
15	2	59.924189	30.498471	2025-03-26 20:35:49+03	2025-03-26 20:41:00.665817+03
16	2	59.924155	30.498489	2025-03-26 20:35:49+03	2025-03-26 20:41:31.389085+03
17	2	59.924167	30.498446	2025-03-26 20:35:49+03	2025-03-26 20:42:02.184651+03
18	2	59.924167	30.498446	2025-03-26 20:35:49+03	2025-03-26 20:42:14.521345+03
19	2	59.924254	30.49844	2025-03-27 23:01:13+03	2025-03-27 23:01:14.088851+03
20	3	27.175266	33.826034	2025-03-28 08:47:08+03	2025-03-28 08:47:11.527568+03
21	3	59.878928	30.305212	2025-04-03 09:59:47+03	2025-04-03 09:59:48.763759+03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.users ("idUser", "tgId", phone, fio, "roleId") FROM stdin;
4	420102502	79119511945	Шумай Богдан Шалвович	2
6	423009704	79818964746	Тестов Тест Тестович	1
8	7569260568	79990222515	Демин Павел Владимирович	2
9	1852093970	79819741865	Фёдоров Сергей Петрович	1
10	825263745	+79219462846	Корзун Юрий	1
11	1124935505	79046152783	Цветова Ольга Александровна	1
12	5642588423	79112947129	Наквасин Михаил Иванович	1
13	282299655	79216574781	Маслюк Андрей Александрович	1
14	5253233120	79500255126	Боголюбов Александр Васильевич	1
15	7614985625	79046068322	Киршин Александр Викторович	1
16	531726729	79218653779	Наконечная Ольга Валерьевна	1
17	7354034955	79990222887	Воробьев Сергей Анатольевич	2
18	411953346	79119072551	Куксов Александр Александрович	1
19	249383812	79811548733	Карасев Игорь Дмитриевич	1
20	1997625455	79006275935	Махно Алёна Алексеевна	1
21	479680725	79217605725	Бойков Дмитрий Александрович	1
22	5191804608	79112449025	Зайцева Татьяна Константиновна	1
23	779653032	79217521399	Зайцева Светлана Валерьевна	1
24	6301844864	79112808148	Виноградова Олеся Владимировна	1
25	5217931263	79526678692	Вагин Андрей Вячеславович	1
26	530534541	79213217155	Малофеева Светлана Николаевна	1
27	291381099	79052620300	Волошина Светлана Николаевна	1
28	7638364395	79213377664	Наконечный Валерий Леонидович	1
29	7855342297	79215777468	Степаноа Анатолий Александрович	1
30	1859825808	79817752735	Демина Ирина Николаевна	1
31	5184999278	79312263150	Касимова Эльмира Пакеддиновна	1
32	5831691192	79502244488	Колесов Кирилл Николаевич	1
33	1940962941	79046310283	Максимов Олег Владимирович	1
34	5155819196	79213648377	Ващенко Людмила Ивановна	1
35	408928754	79215060570	Протас Илья Сергеевич	1
36	5228487812	79219787133	Морозова Светлана Николаевна	1
37	7722138589	79818437185	Борисов Евгений Владимирович	1
38	7354318987	79650002283	Березина Татьяна Юрьевна	1
39	905458678	79112676557	Михайлова Елена Игоревна	1
40	7269237369	79990208343	Гожев Егор Дмитриевич	2
41	5145739560	79643836041	Донская Полина Станиславовна	1
42	5189588957	79213719121	Фролова Любовь Валерьевна	1
44	5307544683	79516496697	Паневская Вера Евгеньевна	1
45	713225576	79213066462	Шуркина Наталья Владимировна	1
46	448879883	79117541008	Ольст Игорь Александрович	1
47	636456431	79531658480	Кулешова Валентина Александровна	1
48	5588323042	79633216552	Волков Владимир Борисович	1
49	6473136554	79533731050	Гришечкина Ирина Васильевна	1
50	394765530	79052889905	Миронов Виталий Александрович	1
51	956789367	79379866071	Браун Юлия Сергеевна	1
52	5216639407	79818039740	Волкова Дарья Вячеславовна	1
53	1814993302	79319569611	Ялынычев Владимир Ильич	1
54	722468963	79013055758	Сюткина Татьяна Ивановна	1
55	8136327289	79118186613	Самофал Галина Александровна	1
56	7496334039	79523924918	Липовцева Наталья Валерьевна	1
57	1965040806	79818300254	Локтионова Оксана Петровна	1
58	7748518550	79990224950	Алексеев Никита Михайлович	2
59	1467012939	79633228747	Строганов Александр Михайлович	1
60	8127053220	79990207495	Каверин Андрей Анатольевич	2
61	7665452686	79990086368	Лузганов Василий Михайлович	2
62	6343676586	79990225102	Березовский Александр Викторович	2
63	5199106082	79117078108	Балясников Александр Михайлович	1
64	7315414519	79819988988	Солдатов Алексей Иванович	1
65	443191985	+79500468347	Тест Тест Тест	1
66	1617829467	79500250639	Николаева Ольга Леонидовна	1
67	560457642	79500191770	Старова Светлана Сергеевна	1
68	903983580	79111780018	Макаров Юрий Владимирович	1
69	1996287527	79520974385	Анисимов Павел Николаевич	1
70	5092282279	79312375850	Старкова Анна Игоревна	1
43	195932792	79643930942	Аминзода Фирдавси Шарифович	3
72	1593013582	79313607827	Сорокина Татьяна Александровна	1
73	5204935156	79213430157	Воронина Ирина Юрьевна	3
74	5118310811	79111640915	Паршина Анастасия Алексеевна	1
2	6529081779	79960739670	Имя Фамилия	2
3	423417342	+79234948500	Франц Алексей Дмитриевич	3
75	1122472730	79932191833	Иванов Владимир Серафимович	1
71	1893100360	+79118269902	Админ Админов Админович	3
77	1216449825	79219238224	Карасев Дмитрий Геннадьевич	1
78	403956089	79216300769	Папковский Дмитрий Михайлович	1
79	5173952158	79215779362	Иванова Светлана Николаевна	1
80	825311336	79675105855	Петухов Максим Александрович	1
81	1062324845	79533574692	Тарханова Ангелина Александровна	1
76	1809595270	79181981809	Лореш Глеб Александрович	3
82	456705043	79213376314	Гожев Егор Дмитриевич	1
\.


--
-- Data for Name: weight_coefficent; Type: TABLE DATA; Schema: public; Owner: tgBot
--

COPY public.weight_coefficent (weight_coefficent_id, value, coefficent) FROM stdin;
\.


--
-- Name: buildings_building_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public.buildings_building_id_seq', 53, true);


--
-- Name: cargoTypes_idCargoType_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public."cargoTypes_idCargoType_seq"', 11, true);


--
-- Name: department_buildings_department_building_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public.department_buildings_department_building_id_seq', 68, true);


--
-- Name: department_types_department_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public.department_types_department_type_id_seq', 2, true);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 32, true);


--
-- Name: orderStatuses_idOrderStatus_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public."orderStatuses_idOrderStatus_seq"', 4, true);


--
-- Name: orders_idOrder_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public."orders_idOrder_seq"', 1557, true);


--
-- Name: roles_idRole_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public."roles_idRole_seq"', 4, true);


--
-- Name: time_coefficent_time_coefficent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public.time_coefficent_time_coefficent_id_seq', 1, true);


--
-- Name: userLocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public."userLocations_id_seq"', 21, true);


--
-- Name: users_idUser_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public."users_idUser_seq"', 82, true);


--
-- Name: weight_coefficent_weight_coefficent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tgBot
--

SELECT pg_catalog.setval('public.weight_coefficent_weight_coefficent_id_seq', 1, false);


--
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_pkey PRIMARY KEY (building_id);


--
-- Name: cargoTypes cargoTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."cargoTypes"
    ADD CONSTRAINT "cargoTypes_pkey" PRIMARY KEY ("idCargoType");


--
-- Name: department_buildings department_buildings_department_id_building_id_key; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_buildings
    ADD CONSTRAINT department_buildings_department_id_building_id_key UNIQUE (department_id, building_id);


--
-- Name: department_buildings department_buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_buildings
    ADD CONSTRAINT department_buildings_pkey PRIMARY KEY (department_building_id);


--
-- Name: department_types department_types_department_type_name_key; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_types
    ADD CONSTRAINT department_types_department_type_name_key UNIQUE (department_type_name);


--
-- Name: department_types department_types_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_types
    ADD CONSTRAINT department_types_pkey PRIMARY KEY (department_type_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: orderStatuses orderStatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."orderStatuses"
    ADD CONSTRAINT "orderStatuses_pkey" PRIMARY KEY ("idOrderStatus");


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY ("idOrder");


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY ("idRole");


--
-- Name: time_coefficent time_coefficent_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.time_coefficent
    ADD CONSTRAINT time_coefficent_pkey PRIMARY KEY (time_coefficent_id);


--
-- Name: userLocations userLocations_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."userLocations"
    ADD CONSTRAINT "userLocations_pkey" PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY ("idUser");


--
-- Name: users users_tgId_key; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_tgId_key" UNIQUE ("tgId");


--
-- Name: weight_coefficent weight_coefficent_pkey; Type: CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.weight_coefficent
    ADD CONSTRAINT weight_coefficent_pkey PRIMARY KEY (weight_coefficent_id);


--
-- Name: idx_buildings_building_name; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX idx_buildings_building_name ON public.buildings USING btree (building_name);


--
-- Name: idx_department_buildings_building_id; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX idx_department_buildings_building_id ON public.department_buildings USING btree (building_id);


--
-- Name: idx_department_buildings_department_id; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX idx_department_buildings_department_id ON public.department_buildings USING btree (department_id);


--
-- Name: idx_departments_department_name; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX idx_departments_department_name ON public.departments USING btree (department_name);


--
-- Name: idx_user_locations_user_id_timestamp; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX idx_user_locations_user_id_timestamp ON public."userLocations" USING btree (user_id, "timestamp");


--
-- Name: idx_users_tg_id; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE UNIQUE INDEX idx_users_tg_id ON public.users USING btree ("tgId");


--
-- Name: ix_time_coefficent_value; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX ix_time_coefficent_value ON public.time_coefficent USING btree (value);


--
-- Name: ix_weight_coefficent_value; Type: INDEX; Schema: public; Owner: tgBot
--

CREATE INDEX ix_weight_coefficent_value ON public.weight_coefficent USING btree (value);


--
-- Name: department_buildings department_buildings_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_buildings
    ADD CONSTRAINT department_buildings_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(building_id);


--
-- Name: department_buildings department_buildings_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.department_buildings
    ADD CONSTRAINT department_buildings_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: departments departments_department_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_type_id_fkey FOREIGN KEY (department_type_id) REFERENCES public.department_types(department_type_id);


--
-- Name: orders orders_cargoTypeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_cargoTypeId_fkey" FOREIGN KEY ("cargoTypeId") REFERENCES public."cargoTypes"("idCargoType");


--
-- Name: orders orders_depart_loc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_depart_loc_fkey FOREIGN KEY (depart_loc) REFERENCES public.department_buildings(department_building_id);


--
-- Name: orders orders_dispatcherId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_dispatcherId_fkey" FOREIGN KEY ("dispatcherId") REFERENCES public.users("idUser");


--
-- Name: orders orders_driverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES public.users("idUser");


--
-- Name: orders orders_goal_loc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_goal_loc_fkey FOREIGN KEY (goal_loc) REFERENCES public.department_buildings(department_building_id);


--
-- Name: orders orders_orderStatusId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_orderStatusId_fkey" FOREIGN KEY ("orderStatusId") REFERENCES public."orderStatuses"("idOrderStatus");


--
-- Name: userLocations userLocations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public."userLocations"
    ADD CONSTRAINT "userLocations_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users("idUser");


--
-- Name: users users_roleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tgBot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES public.roles("idRole");


--
-- PostgreSQL database dump complete
--

