-- triggers
CREATE TRIGGER data_migration_execution_updated_at
    BEFORE UPDATE ON cfg.data_migration_execution
    FOR EACH ROW
    EXECUTE PROCEDURE moddatetime(updated_at);
