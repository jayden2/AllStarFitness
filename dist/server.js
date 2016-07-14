var app, bodyparser, connection, express, morgan, port, router, routes, server, server_ip_address, server_port;

express = require('express');

bodyparser = require('body-parser');

morgan = require('morgan');

connection = require('./config/connection');

routes = require('./routes');

app = express();

app.use(bodyparser.urlencoded({
  extended: true
}));

app.use(bodyparser.json());

port = process.env.PORT || 8080;

server_port = process.env.OPENSHIFT_NODEJS_PORT || 8080;

server_ip_address = process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1';

app.use(function(req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization');
  return next();
});

app.use(morgan('dev'));

router = express.Router();

connection.init();

routes.configure(app, router);

server = app.listen(server_port, server_ip_address);

console.log("Listening on " + server_ip_address + ", server_port " + port);
