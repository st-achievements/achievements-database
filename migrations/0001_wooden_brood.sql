DROP INDEX IF EXISTS "achievement_level_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "achievement_quantity_unit_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "achievement_workout_type_workout_type_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "period_start_at_index";--> statement-breakpoint
DROP INDEX IF EXISTS "period_end_at_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_achievement_ach_achievement_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_achievement_user_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_achievement_period_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_achievement_progress_ach_achievement_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_achievement_progress_user_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_achievement_progress_period_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_workout_workout_type_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_workout_user_id_index";--> statement-breakpoint
DROP INDEX IF EXISTS "usr_workout_period_id_index";--> statement-breakpoint
ALTER TABLE "ach"."achievement" ADD COLUMN "has_progress_tracking" boolean DEFAULT false NOT NULL;--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "period_start_at_end_at_index" ON "cfg"."period" ("start_at","end_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_achievement_user_period_index" ON "usr"."usr_achievement" ("user_id","period_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_achievement_progress_achievement_user_period_index" ON "usr"."usr_achievement_progress" ("ach_achievement_id","user_id","period_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_workout_type_index" ON "usr"."usr_workout" ("user_id","period_id","workout_type_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_started_at_ended_at_index" ON "usr"."usr_workout" ("user_id","period_id","started_at","ended_at");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "usr_workout_user_period_workout_type_started_at_ended_at_index" ON "usr"."usr_workout" ("user_id","period_id","workout_type_id","started_at","ended_at");--> statement-breakpoint
ALTER TABLE "ach"."achievement" DROP COLUMN IF EXISTS "frequency_quantity";