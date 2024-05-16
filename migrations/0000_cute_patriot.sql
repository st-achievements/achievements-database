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
DO $$ BEGIN
 CREATE TYPE "ach"."frequency_condition" AS ENUM('every');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "ach"."frequency" AS ENUM('day', 'week', 'month');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "ach"."workout_period_condition" AS ENUM('sameDay', 'sameWeek', 'sameMonth', 'samePeriod', 'singleSession');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "ach"."workout_type_condition" AS ENUM('anyOf', 'allOf', 'any', 'exclusiveAny', 'exclusiveAnyOf');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."achievement" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
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
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"achievement_id" integer NOT NULL,
	"workout_type_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."level" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(255) NOT NULL,
	"image_url" varchar(4000)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "cfg"."period" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"start_at" date NOT NULL,
	"end_at" date NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "cfg"."quantity_unit" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(10) NOT NULL,
	"description" varchar(255),
	CONSTRAINT "quantity_unit_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "iam"."api_key" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"key" varchar(1000) NOT NULL,
	"salt" varchar(50) NOT NULL,
	"user_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."achievement" (
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"user_id" integer NOT NULL,
	"ach_achievement_id" integer NOT NULL,
	"achieved_at" timestamp DEFAULT now() NOT NULL,
	"period_id" integer NOT NULL,
	CONSTRAINT "achievement_ach_achievement_id_user_id_period_id_pk" PRIMARY KEY("ach_achievement_id","user_id","period_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."achievement_progress" (
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
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
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"external_id" varchar(255),
	"name" varchar(255) NOT NULL,
	CONSTRAINT "user_external_id_unique" UNIQUE("external_id"),
	CONSTRAINT "user_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."workout" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
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
	CONSTRAINT "workout_external_id_unique" UNIQUE("external_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "wrk"."workout_type" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_by" integer DEFAULT -1 NOT NULL,
	"updated_by" integer DEFAULT -1 NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT "workout_type_name_unique" UNIQUE("name")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ach"."achievement" ADD CONSTRAINT "achievement_level_id_level_id_fk" FOREIGN KEY ("level_id") REFERENCES "ach"."level"("id") ON DELETE no action ON UPDATE no action;
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
 ALTER TABLE "usr"."achievement" ADD CONSTRAINT "achievement_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."achievement" ADD CONSTRAINT "achievement_ach_achievement_id_achievement_id_fk" FOREIGN KEY ("ach_achievement_id") REFERENCES "ach"."achievement"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."achievement" ADD CONSTRAINT "achievement_period_id_period_id_fk" FOREIGN KEY ("period_id") REFERENCES "cfg"."period"("id") ON DELETE no action ON UPDATE no action;
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
 ALTER TABLE "usr"."workout" ADD CONSTRAINT "workout_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."workout" ADD CONSTRAINT "workout_workout_type_id_workout_type_id_fk" FOREIGN KEY ("workout_type_id") REFERENCES "wrk"."workout_type"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "usr"."workout" ADD CONSTRAINT "workout_period_id_period_id_fk" FOREIGN KEY ("period_id") REFERENCES "cfg"."period"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "achievement_workout_type_achievement_id_index" ON "ach"."achievement_workout_type" ("achievement_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "period_start_at_end_at_index" ON "cfg"."period" ("start_at","end_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "api_key_user_id_index" ON "iam"."api_key" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_achievement_user_period_index" ON "usr"."achievement" ("user_id","period_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_workout_type_index" ON "usr"."workout" ("user_id","period_id","workout_type_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_started_at_ended_at_index" ON "usr"."workout" ("user_id","period_id","started_at","ended_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_workout_type_started_at_ended_at_index" ON "usr"."workout" ("user_id","period_id","workout_type_id","started_at","ended_at");