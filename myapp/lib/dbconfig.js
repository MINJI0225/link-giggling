var mysql = require('mysql');

var db = mysql.createConnection({
  host: '127.0.0.1',
  port: '3306',
  user: 'root',
  password: '0225',
  database: 'LinkGiggling'
});

db.connect();

module.exports = db;