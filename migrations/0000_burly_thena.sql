CREATE SCHEMA "ach";
--> statement-breakpoint
CREATE SCHEMA "cfg";
--> statement-breakpoint
CREATE SCHEMA "iam";
--> statement-breakpoint
CREATE SCHEMA "usr";
--> statement-breakpoint
CREATE SCHEMA "wrk";
--> statement-breakpoint
CREATE TYPE "ach"."frequency_condition" AS ENUM('every');--> statement-breakpoint
CREATE TYPE "ach"."frequency" AS ENUM('day', 'week', 'month');--> statement-breakpoint
CREATE TYPE "ach"."workout_period_condition" AS ENUM('sameDay', 'sameWeek', 'sameMonth', 'samePeriod', 'singleSession');--> statement-breakpoint
CREATE TYPE "ach"."workout_type_condition" AS ENUM('anyOf', 'allOf', 'any', 'exclusiveAny', 'exclusiveAnyOf');--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."achievement" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "ach"."achievement_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(255) NOT NULL,
	"description" varchar(5000),
	"image_url" varchar(4000),
	"level_id" integer NOT NULL,
	"quantity_needed" integer NOT NULL,
	"quantity_unit_id" integer NOT NULL,
	"workout_type_condition" "ach"."workout_type_condition" NOT NULL,
	"period_condition" "ach"."workout_period_condition" NOT NULL,
	"frequency" "ach"."frequency",
	"frequency_condition" "ach"."frequency_condition",
	"has_progress_tracking" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."achievement_workout_type" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "ach"."achievement_workout_type_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"achievement_id" integer NOT NULL,
	"workout_type_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."ach_level" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "ach"."ach_level_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(255) NOT NULL,
	"image_url" varchar(4000)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "cfg"."period" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "cfg"."period_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"start_at" date NOT NULL,
	"end_at" date NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "cfg"."quantity_unit" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "cfg"."quantity_unit_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(10) NOT NULL,
	"description" varchar(255),
	CONSTRAINT "quantity_unit_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "iam"."api_key" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "iam"."api_key_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"key" varchar(1000) NOT NULL,
	"salt" varchar(50) NOT NULL,
	"user_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."usr_achievement" (
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"user_id" integer NOT NULL,
	"ach_achievement_id" integer NOT NULL,
	"achieved_at" timestamp DEFAULT now() NOT NULL,
	"period_id" integer NOT NULL,
	CONSTRAINT "usr_achievement_ach_achievement_id_user_id_period_id_pk" PRIMARY KEY("ach_achievement_id","user_id","period_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."achievement_progress" (
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"quantity" smallint NOT NULL,
	"ach_achievement_id" integer NOT NULL,
	"user_id" integer NOT NULL,
	"period_id" integer NOT NULL,
	CONSTRAINT "achievement_progress_ach_achievement_id_user_id_period_id_pk" PRIMARY KEY("ach_achievement_id","user_id","period_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."user" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "usr"."user_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"external_id" varchar(255),
	"name" varchar(255) NOT NULL,
	CONSTRAINT "user_externalId_unique" UNIQUE("external_id"),
	CONSTRAINT "user_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."usr_workout" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "usr"."usr_workout_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"user_id" integer NOT NULL,
	"workout_type_id" integer NOT NULL,
	"duration" double precision NOT NULL,
	"started_at" timestamp NOT NULL,
	"ended_at" timestamp NOT NULL,
	"external_id" varchar(255) NOT NULL,
	"distance" double precision,
	"energy_burned" double precision NOT NULL,
	"workout_name" varchar(255),
	"period_id" integer NOT NULL,
	"achievement_processed_at" timestamp,
	CONSTRAINT "usr_workout_externalId_unique" UNIQUE("external_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "wrk"."workout_type" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "wrk"."workout_type_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 4096 CACHE 1),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"inactivated_at" timestamp,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT "workout_type_name_unique" UNIQUE("name")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ach"."achievement" ADD CONSTRAINT "achievement_level_id_ach_level_id_fk" FOREIGN KEY ("level_id") REFERENCES "ach"."ach_level"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ach"."achievement" ADD CONSTRAINT "achievement_quantity_unit_id_quantity_unit_id_fk" FOREIGN KEY ("quantity_unit_id") REFERENCES "cfg"."quantity_unit"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ach"."achievement_workout_type" ADD CONSTRAINT "achievement_workout_type_achievement_id_achievement_id_fk" FOREIGN KEY ("achievement_id") REFERENCES "ach"."achievement"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ach"."achievement_workout_type" ADD CONSTRAINT "achievement_workout_type_workout_type_id_workout_type_id_fk" FOREIGN KEY ("workout_type_id") REFERENCES "wrk"."workout_type"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "iam"."api_key" ADD CONSTRAINT "api_key_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."usr_achievement" ADD CONSTRAINT "usr_achievement_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."usr_achievement" ADD CONSTRAINT "usr_achievement_ach_achievement_id_achievement_id_fk" FOREIGN KEY ("ach_achievement_id") REFERENCES "ach"."achievement"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."usr_achievement" ADD CONSTRAINT "usr_achievement_period_id_period_id_fk" FOREIGN KEY ("period_id") REFERENCES "cfg"."period"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."achievement_progress" ADD CONSTRAINT "achievement_progress_ach_achievement_id_achievement_id_fk" FOREIGN KEY ("ach_achievement_id") REFERENCES "ach"."achievement"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."achievement_progress" ADD CONSTRAINT "achievement_progress_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."achievement_progress" ADD CONSTRAINT "achievement_progress_period_id_period_id_fk" FOREIGN KEY ("period_id") REFERENCES "cfg"."period"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."usr_workout" ADD CONSTRAINT "usr_workout_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."usr_workout" ADD CONSTRAINT "usr_workout_workout_type_id_workout_type_id_fk" FOREIGN KEY ("workout_type_id") REFERENCES "wrk"."workout_type"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."usr_workout" ADD CONSTRAINT "usr_workout_period_id_period_id_fk" FOREIGN KEY ("period_id") REFERENCES "cfg"."period"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "achievement_workout_type_achievement_id_index" ON "ach"."achievement_workout_type" USING btree ("achievement_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "period_start_at_end_at_index" ON "cfg"."period" USING btree ("start_at","end_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "api_key_user_id_index" ON "iam"."api_key" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "api_key_key_index" ON "iam"."api_key" USING btree ("key");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_achievement_user_period_index" ON "usr"."usr_achievement" USING btree ("user_id","period_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_achievement_user_achievement_index" ON "usr"."usr_achievement" USING btree ("user_id","ach_achievement_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_achievement_progress_user_achievement_index" ON "usr"."achievement_progress" USING btree ("user_id","ach_achievement_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_workout_type_index" ON "usr"."usr_workout" USING btree ("user_id","period_id","workout_type_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_started_at_ended_at_index" ON "usr"."usr_workout" USING btree ("user_id","period_id","started_at","ended_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_workout_type_started_at_ended_at_index" ON "usr"."usr_workout" USING btree ("user_id","period_id","workout_type_id","started_at","ended_at");