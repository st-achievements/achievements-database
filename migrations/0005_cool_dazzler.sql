ALTER TABLE "iam"."api_key" ALTER COLUMN "key" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "iam"."api_key" ALTER COLUMN "salt" SET NOT NULL;