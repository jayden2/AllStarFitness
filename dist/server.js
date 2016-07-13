var app, bodyparser, connection, express, morgan, port, router, routes, server;

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

port = process.env.PORT || 1199;

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

server = app.listen(port);

console.log('Server started on port ' + port);
