var Connection, mysql;

mysql = require('mysql');

module.exports = Connection = (function() {
  function Connection() {}

  Connection.pool = null;

  Connection.init = function() {
    return this.pool = mysql.createPool({
      connectionLimit: 10,
      host: 'localhost',
      port: '3306',
      user: 'admindEJ2fyi',
      password: 'NeduHQFdnB6k',
      database: 'allstarfitness'
    });
  };

  Connection.acquire = function(callback) {
    return this.pool.getConnection(function(err, connection) {
      return callback(err, connection);
    });
  };

  return Connection;

})();
