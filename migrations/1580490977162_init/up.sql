-- Create PostGIS extensions if they don't exist
CREATE EXTENSION
IF NOT EXISTS postgis;
CREATE EXTENSION
IF NOT EXISTS postgis_topology;

CREATE FUNCTION public."set_current_timestamp_updatedAt"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updatedAt" = NOW
();
RETURN _new;
END;
$$;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW
();
RETURN _new;
END;
$$;
CREATE TABLE public.appointments
(
    "appointmentId" uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "firstName" character varying,
    "lastName" character varying,
    email character varying,
    phone character varying(15),
    status integer DEFAULT 1 NOT NULL,
    "scheduledAt" timestamp
    without time zone,
    "createdAt" timestamp
    with time zone DEFAULT now
    (),
    "updatedAt" timestamp
    with time zone DEFAULT now
    (),
    location character varying NOT NULL,
    vin text,
    description text,
    userid text,
    "repId" text
);
    CREATE TABLE public."appointmentsStatus"
    (
        "appointmentStatusId" integer NOT NULL,
        status character varying
    );
    CREATE TABLE public.locations
    (
        id integer NOT NULL,
        name character varying(64),
        polygon
        public.geometry
);
        CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
        ALTER SEQUENCE public.locations_id_seq
        OWNED BY public.locations.id;
        ALTER TABLE ONLY public.locations
        ALTER COLUMN id
        SET
        DEFAULT nextval
        ('public.locations_id_seq'::regclass);
        ALTER TABLE ONLY public."appointmentsStatus"
        ADD CONSTRAINT "appointmentsStatus_pkey" PRIMARY KEY
        ("appointmentStatusId");
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT "appointments_appointmentId_key" UNIQUE
        ("appointmentId");
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT appointments_pkey PRIMARY KEY
        ("appointmentId");
        ALTER TABLE ONLY public.locations
        ADD CONSTRAINT locations_pkey PRIMARY KEY
        (id);
        CREATE INDEX locations_polygon_idx ON public.locations USING gist
        (polygon);
        CREATE TRIGGER "set_public_appointments_updatedAt" BEFORE
        UPDATE ON public.appointments FOR EACH ROW
        EXECUTE PROCEDURE
        public."set_current_timestamp_updatedAt"
        ();
COMMENT ON TRIGGER "set_public_appointments_updatedAt" ON public.appointments IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT appointments_status_fkey FOREIGN KEY
        (status) REFERENCES public."appointmentsStatus"
        ("appointmentStatusId");
