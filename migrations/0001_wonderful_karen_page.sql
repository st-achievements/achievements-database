ALTER TABLE "usr"."user" DROP CONSTRAINT "user_external_id_unique";--> statement-breakpoint
ALTER TABLE "usr"."usr_workout" DROP CONSTRAINT "usr_workout_external_id_unique";--> statement-breakpoint
ALTER TABLE "usr"."user" ADD CONSTRAINT "user_externalId_unique" UNIQUE("external_id");--> statement-breakpoint
ALTER TABLE "usr"."usr_workout" ADD CONSTRAINT "usr_workout_externalId_unique" UNIQUE("external_id");