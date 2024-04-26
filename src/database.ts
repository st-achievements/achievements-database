import pg from 'pg';

const CONNECTION_TIMEOUT_MS =
  Number(process.env.DB_CONNECTION_TIMEOUT) || 10 * 1000;
const IDLE_TIMEOUT_MS =
  Number(process.env.DB_CONNECTION_IDLE_TIMEOUT) || 10 * 1000;
const QUERY_TIMEOUT_MS = Number(process.env.DB_QUERY_TIMEOUT) || 2 * 1000;

interface GetClientOptions {
  connectionString: string;
  applicationName?: string;
}

export function getClient(options: GetClientOptions) {
  return new pg.Pool({
    connectionString: options.connectionString,
    connectionTimeoutMillis: CONNECTION_TIMEOUT_MS,
    idleTimeoutMillis: IDLE_TIMEOUT_MS,
    query_timeout: QUERY_TIMEOUT_MS,
    application_name: options.applicationName,
  });
}
