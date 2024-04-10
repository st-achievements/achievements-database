ALTER TABLE "usr"."usr_achievement" DROP COLUMN IF EXISTS "id";
DROP INDEX IF EXISTS "usr_achievement_progress_achievement_user_period_index";--> statement-breakpoint
ALTER TABLE "usr"."usr_achievement" ADD CONSTRAINT "usr_achievement_ach_achievement_id_user_id_period_id_pk" PRIMARY KEY("ach_achievement_id","user_id","period_id");--> statement-breakpoint
