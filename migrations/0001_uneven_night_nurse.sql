-- triggers
CREATE EXTENSION moddatetime;

CREATE TRIGGER achievement_updated_at
    BEFORE UPDATE ON ach.achievement
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);

CREATE TRIGGER level_updated_at
    BEFORE UPDATE ON ach.level
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);

CREATE TRIGGER user_updated_at
    BEFORE UPDATE ON usr."user"
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);

CREATE TRIGGER achievement_updated_at
    BEFORE UPDATE ON usr.usr_achievement
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);

CREATE TRIGGER workout_updated_at
    BEFORE UPDATE ON usr.workout
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);

CREATE TRIGGER workout_type_updated_at
    BEFORE UPDATE ON wrk.workout_type
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);
