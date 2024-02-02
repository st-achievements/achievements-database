export function getConnectionString(): string {
  const connectionString = process.env.DATABASE_CONNECTION_STRING;
  if (!connectionString) {
    throw new Error('Connection string not found');
  }
  return connectionString;
}
