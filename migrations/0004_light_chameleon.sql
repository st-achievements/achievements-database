CREATE TRIGGER iam_api_key_updated_at
BEFORE UPDATE ON iam.api_key
FOR EACH ROW
EXECUTE PROCEDURE moddatetime(updated_at);
