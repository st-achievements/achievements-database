ALTER TABLE "usr"."usr_achievement_progress" DROP COLUMN IF EXISTS "id";
ALTER TABLE "usr"."usr_achievement_progress" ADD CONSTRAINT "usr_achievement_progress_ach_achievement_id_user_id_period_id_pk" PRIMARY KEY("ach_achievement_id","user_id","period_id");--> statement-breakpoint
