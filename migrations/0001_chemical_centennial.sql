DO $$ BEGIN
  CREATE EXTENSION moddatetime;
EXCEPTION
  WHEN OTHERS THEN null;
END $$;

CREATE TRIGGER ach_ach_level_updated_at
BEFORE UPDATE ON ach.ach_level
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER ach_achievement_updated_at
BEFORE UPDATE ON ach.achievement
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER ach_achievement_workout_type_updated_at
BEFORE UPDATE ON ach.achievement_workout_type
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER cfg_period_updated_at
BEFORE UPDATE ON cfg.period
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER cfg_quantity_unit_updated_at
BEFORE UPDATE ON cfg.quantity_unit
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER usr_user_updated_at
BEFORE UPDATE ON usr.user
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER usr_usr_achievement_updated_at
BEFORE UPDATE ON usr.usr_achievement
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER usr_usr_achievement_progress_updated_at
BEFORE UPDATE ON usr.usr_achievement_progress
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER usr_usr_workout_updated_at
BEFORE UPDATE ON usr.usr_workout
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
CREATE TRIGGER wrk_workout_type_updated_at
BEFORE UPDATE ON wrk.workout_type
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
