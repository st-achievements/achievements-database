ALTER TABLE "ach"."achievement" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "ach"."achievement_workout_type" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "ach"."ach_level" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "cfg"."period" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "cfg"."quantity_unit" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "iam"."api_key" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "usr"."usr_achievement" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "usr"."achievement_progress" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "usr"."user" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "usr"."usr_workout" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint
ALTER TABLE "wrk"."workout_type" ADD COLUMN "inactivated_at" timestamp;--> statement-breakpoint

-- custom
update "ach"."achievement" set inactivated_at = now() where active = false;
update "ach"."achievement_workout_type" set inactivated_at = now() where active = false;
update "ach"."ach_level" set inactivated_at = now() where active = false;
update "cfg"."period" set inactivated_at = now() where active = false;
update "cfg"."quantity_unit" set inactivated_at = now() where active = false;
update "iam"."api_key" set inactivated_at = now() where active = false;
update "usr"."usr_achievement" set inactivated_at = now() where active = false;
update "usr"."achievement_progress" set inactivated_at = now() where active = false;
update "usr"."user" set inactivated_at = now() where active = false;
update "usr"."usr_workout" set inactivated_at = now() where active = false;
update "wrk"."workout_type" set inactivated_at = now() where active = false;
-- end custom

ALTER TABLE "ach"."achievement" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "ach"."achievement_workout_type" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "ach"."ach_level" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "cfg"."period" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "cfg"."quantity_unit" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "iam"."api_key" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "usr"."usr_achievement" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "usr"."achievement_progress" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "usr"."user" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "usr"."usr_workout" DROP COLUMN IF EXISTS "active";--> statement-breakpoint
ALTER TABLE "wrk"."workout_type" DROP COLUMN IF EXISTS "active";