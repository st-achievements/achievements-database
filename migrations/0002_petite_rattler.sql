CREATE SCHEMA "cfg";
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "cfg"."data_migration_execution" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"object_name" varchar(255) NOT NULL,
	"object_content" jsonb NOT NULL
);
--> statement-breakpoint
ALTER TABLE "usr"."workout" ALTER COLUMN "energy_burned" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "ach"."achievement" ADD COLUMN "image_url" varchar(4000);--> statement-breakpoint
ALTER TABLE "usr"."workout" ADD COLUMN "workout_name" varchar(255);