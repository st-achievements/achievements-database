CREATE SCHEMA "ach";
--> statement-breakpoint
CREATE SCHEMA "usr";
--> statement-breakpoint
CREATE SCHEMA "wrk";
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."achievement" (
	"name" varchar(255) NOT NULL,
	"description" varchar(5000),
	"level_id" integer NOT NULL,
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ach"."level" (
	"name" varchar(255) NOT NULL,
	"image_url" varchar(4000),
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."usr_achievement" (
	"user_id" integer NOT NULL,
	"ach_achievement_id" integer NOT NULL,
	"achieved_at" timestamp DEFAULT now() NOT NULL,
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."user" (
	"external_id" varchar(255),
	"name" varchar(255) NOT NULL,
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "user_external_id_unique" UNIQUE("external_id"),
	CONSTRAINT "user_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "usr"."workout" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"user_id" integer NOT NULL,
	"workout_type_id" integer NOT NULL,
	"duration" numeric(6, 2) NOT NULL,
	"started_at" timestamp NOT NULL,
	"ended_at" timestamp NOT NULL,
	"external_id" varchar(255) NOT NULL,
	"distance" numeric(6, 2),
	"energy_burned" numeric(6, 2),
	CONSTRAINT "workout_external_id_unique" UNIQUE("external_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "wrk"."workout_type" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT "workout_type_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "achievement_level_id_index" ON "ach"."achievement" ("level_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "achievement_ach_achievement_id_index" ON "usr"."usr_achievement" ("ach_achievement_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "achievement_user_id_index" ON "usr"."usr_achievement" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "workout_workout_type_id_index" ON "usr"."workout" ("workout_type_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "workout_external_id_index" ON "usr"."workout" ("external_id");--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ach"."achievement" ADD CONSTRAINT "achievement_level_id_level_id_fk" FOREIGN KEY ("level_id") REFERENCES "ach"."level"("id") ON DELETE no action ON UPDATE no action;
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
