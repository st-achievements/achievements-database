CREATE SCHEMA "iam";
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "iam"."api_key" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"key" varchar(1000),
	"salt" varchar(50),
	"user_id" integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "api_key_user_id_index" ON "iam"."api_key" ("user_id");--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "iam"."api_key" ADD CONSTRAINT "api_key_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "usr"."user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
