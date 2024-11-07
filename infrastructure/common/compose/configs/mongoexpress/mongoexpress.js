import * as dotenv from 'dotenv';

dotenv.config();

export default {
  mongodb: [
    {
      // If set to true to remove the limit of 100 MB of RAM on each aggregation pipeline stage
      allowDiskUse: false,

      // If a connection string options such as server/port/etc are ignored
      connectionString: `mongodb://Twelve:${process.env.PARSER_MONGO_PASSWORD}@parser-mongo:27017/Twitch?authSource=admin`,

      connectionName: 'TwitchParser #1',

      connectionOptions: {
        // Enable ssl
        ssl: true,

        // Enable tls
        tls: true,

        // Validate mongod server certificate against CA
        tlsAllowInvalidCertificates: false,

        // Single PEM file on disk
        tlsCAFile: '/etc/ssl/ca/server-ca.pem',

        // Client key PEM file on disk
        tlsCertificateKeyFile: '/etc/ssl/mongoexpress/server.pem',

        // Size of connection pool (number of connections to use)
        //maxPoolSize: 4,
      },

      // Set admin to true if you want to turn on admin features
      admin: true,

      // Hide all databases except the ones in this list  (empty list for no whitelist)
      whitelist: [],

      // Hide databases listed in the blacklist (empty list for no blacklist)
      blacklist: [],
    }
  ],

  site: {
    // The URL that mongo express will be located at
    baseUrl: '/',

    // The name of the cookie that mongo express will use
    cookieKeyName: 'mongo-express',

    // The cookie secret
    cookieSecret: process.env.MONGO_EXPRESS_COOKIE_SECRET,

    // The host that mongo express will listen
    host: '0.0.0.0',

    // The port that mongo express will use
    port: 8081,

    // Size of requests
    requestSizeLimit: '50mb',

    // The session secret
    sessionSecret: process.env.MONGO_EXPRESS_SESSION_SECRET,

    // SSL certificate
    sslCert: '/etc/ssl/mongoexpress/server.crt',

    // If true the use SSL for site
    sslEnabled: true,

    // SSL key
    sslKey: '/etc/ssl/mongoexpress/server.key',
  },

  healthCheck: {
    // The Path that mongo express healthcheck will be serve
    path: '/health',
  },

  // Set useBasicAuth to true if you want to authenticate mongo-express logins
  useBasicAuth: true,

  basicAuth: {
    // Username for basic auth
    username: process.env.MONGO_EXPRESS_DEFAULT_EMAIL,

    // Password for basic auth
    password: process.env.MONGO_EXPRESS_DEFAULT_PASSWORD,
  },

  options: {
    // Display startup text on console
    console: true,

    // How many documents you want to see at once in collection view
    documentsPerPage: 10,

    // Maximum size of a single property
    maxPropSize: (100 * 1000),

    // Maximum size of a single row
    maxRowSize: (1000 * 1000),

    // The type of command line you want mongo express to run
    cmdType: 'eval',

    // Number of seconds of non-interaction before a subprocess is shut down
    subprocessTimeout: 300,

    // If readOnly is true, components of writing are not visible
    readOnly: false,

    // If set to true, remain on same page after clicked on Save button
    persistEditMode: false,

    // If set to true, jsons will be displayed collapsible
    collapsibleJSON: true,

    // If set to true, this defines default level to which JSONs are displayed unfolded
    collapsibleJSONDefaultUnfold: 1,

    // If set to true, you will be able to manage uploaded files
    gridFSEnabled: false,

    // This object will be used to initialize router logger (morgan)
    logger: {},

    // If set to true, a modal for confirming deletion is displayed before deleting a document/collection
    confirmDelete: false,

    // If set to true, we won't show export buttons
    noExport: false,

    // If set to true an alternative page layout is used utilizing full window width
    fullwidthLayout: false,

    // If set to true, we won't show delete buttons
    noDelete: false,
  },
};
