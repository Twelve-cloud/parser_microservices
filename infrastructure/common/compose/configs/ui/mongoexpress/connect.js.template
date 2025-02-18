import mongodb from 'mongodb';

// Function to connect to MongoDB and manage database connections and collections
const connect = async function (config) {

  // Object to hold connection data, including clients, collections, and connections
  const connectionData = {
    clients: [], // Array to store MongoDB client instances
    collections: {}, // Object to store collections for each database
    connections: {}, // Object to store database connections
  };

  // Method to update the list of collections for a given database connection
  connectionData.updateCollections = async function (dbConnection) {

    // Check if the dbConnection object has a fullName property
    if (!dbConnection.fullName) {
      console.error('Received db instead of db connection');

       // Return empty array if dbConnection is invalid
      return [];
    }

    // Fetch the list of collections from the database
    const collections = await dbConnection.db.listCollections().toArray();

    // Extract collection names and sort them
    const names = [];

     // Add each collection name to the array
    for (const collection of collections) {
      names.push(collection.name);
    }

    // Store sorted collection names in connectionData under the fullName key
    connectionData.collections[dbConnection.fullName] = names.sort();

    // Return the fetched collections
    return collections;
  };

  // Method to update the list of databases connected to
  connectionData.updateDatabases = async function () {

    // Reset connections and collections data
    connectionData.connections = {};
    connectionData.collections = {};

    // Iterate over all client connections to fetch databases
    await Promise.all(
      connectionData.clients.map(async (connectionInfo) => {

        // Helper function to add a new database connection to connectionData
        const addConnection = (db, dbName) => {

          // Construct a full name for the database based on the client count and name
          const fullName = connectionData.clients.length > 1
            ? `${connectionInfo.connectionName}_${dbName}`
            : dbName;

          const newConnection =  {
            info: connectionInfo, // Store connection info for reference
            dbName, // Store the name of the database
            fullName, // Store the constructed full name of the database
            db, // Store the actual database instance
          };

           // Add new connection to connections object
          connectionData.connections[fullName] = newConnection;

          // Return the newly created connection object
          return newConnection;
        };

        // If adminDb is available, list all databases using admin privileges
        if (connectionInfo.adminDb) {
          const allDbs = await connectionInfo.adminDb.listDatabases();

          for (let i = 0; i < allDbs.databases.length; ++i) {
            const dbName = allDbs.databases[i].name;

            // Check against whitelist and blacklist before adding the database
            if (dbName) {
              if (connectionInfo.info.whitelist.length > 0 && !connectionInfo.info.whitelist.includes(dbName)) {
                continue;
              }

              if (connectionInfo.info.blacklist.length > 0 && connectionInfo.info.blacklist.includes(dbName)) {
                continue;
              }

              // Add new database connection
              const connection = addConnection(connectionInfo.client.db(dbName), dbName);

              // Update collections for this new database connection
              await connectionData.updateCollections(connection);
            }
          }
        } else {

          // If no adminDb, access the 'admin' database and list databases using command
          const adminDbs = connectionInfo.client.db('admin');
          const allDbs = await adminDbs.command({ listDatabases: 1 });

          // Loop through databases
          for (let i = 0; i < allDbs.databases.length; ++i) {
            const dbName = allDbs.databases[i].name;

            if (dbName) {
              if (connectionInfo.info.whitelist.length > 0 && !connectionInfo.info.whitelist.includes(dbName)) {
                continue;
              }

              if (connectionInfo.info.blacklist.length > 0 && connectionInfo.info.blacklist.includes(dbName)) {
                continue;
              }

              // Add new database connection
              const connection = addConnection(connectionInfo.client.db(dbName), dbName);

              // Update collections for this DB
              await connectionData.updateCollections(connection);
            }
          }
        }
      }),
    );
  };

  // Method to retrieve sorted list of connected databases
  connectionData.getDatabases = () => Object.keys(connectionData.connections).sort();

  // Handle multiple MongoDB connections based on configuration
  const connections = Array.isArray(config.mongodb) ? config.mongodb : [config.mongodb];

  // Create MongoDB clients for each provided configuration
  connectionData.clients = await Promise.all(connections.map(async (connectionInfo, index) => {
    const {
      connectionString, connectionName, admin, connectionOptions,
    } = connectionInfo;
    try {

      // Connect to MongoDB using the provided connection string and options
      const client = await mongodb.MongoClient.connect(connectionString, connectionOptions);

      // Get admin database if requested in config
      const adminDb = admin ? client.db().admin() : null;

      return {
        connectionName: connectionName || `connection${index}`, // Default name if not provided in config
        client, // MongoDB client instance
        adminDb, // Admin DB instance (if applicable)
        info: connectionInfo, // Original configuration info
      };
    } catch (error) {
      console.error(`Could not connect to database using connectionString: ${connectionString.replace(/(mongo.*?:\/\/.*?:).*?@/, '$1****@')}"`);
      throw error;
    }
  }));

  // Set the main client if not already defined
  if (!connectionData.mainClient) {
    const client = connectionData.clients[0];
    connectionData.mainClient = client;
  }

  // Update the databases after establishing connections
  await connectionData.updateDatabases();

  // Return the populated connection data object
  return connectionData;
};

// Export the connect function for use in other modules
export default connect;
