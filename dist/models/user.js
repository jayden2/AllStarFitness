var User, bcrypt, connection, jwt, secretPassword;

jwt = require('jsonwebtoken');

bcrypt = require('bcrypt-nodejs');

connection = require('../config/connection');

secretPassword = 'superSpecialSecretPasswordThatNooneWouldEverGuess123@#$%^&^$';

module.exports = User = (function() {
  var hashPassword;

  function User() {}

  User.getAllUsers = function(res) {
    connection.acquire(function(err, con) {
      con.query('SELECT id, first_name, last_name, email, user_type, gender, age, date_created, date_updated FROM users', function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  User.getSingleUser = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT id, first_name, last_name, email, user_type, gender, age, date_created, date_updated FROM users WHERE id = ?', [id], function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  User.checkValidEmail = function(email, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT COUNT(id) AS user_count FROM users WHERE email = ?', [email], function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  User.checkValidUser = function(app, user, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT *, COUNT(id) AS user_count FROM users WHERE email = ?', [user.email], function(err, result) {
        var token;
        con.release();
        if (result[0].user_count !== 1) {
          res.send({
            success: false,
            message: 'Authentication failed. User not found.'
          });
        } else if (result[0].user_count === 1) {
          if (!bcrypt.compareSync(user.password, result[0].password)) {
            res.send({
              success: false,
              message: 'Authentication failed. Wrong password.'
            });
          } else {
            token = jwt.sign(user, secretPassword, {
              expiresIn: '7 days'
            });
            res.send({
              success: true,
              message: 'Token Get!',
              id: result[0].id,
              email: result[0].email,
              username: result[0].username,
              token: token
            });
          }
        }
      });
    });
  };

  User.verifyUser = function(req, res, next) {
    var token;
    console.log('API Accessed.');
    token = req.body.token || req.query.token || req.headers['x-access-token'];
    if (token) {
      jwt.verify(token, secretPassword, function(err, decode) {
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'Failed to authenticate token.'
          });
        } else {
          req.decode = decode;
          next();
        }
      });
    } else {
      return res.status(403).send({
        success: false,
        message: 'No token given. Please send request with a token.'
      });
    }
  };

  User.createUser = function(user, res) {
    var pwd;
    pwd = hashPassword(user.password);
    connection.acquire(function(err, con) {
      con.query('INSERT INTO users (first_name, last_name, email, user_type, password, gender, age, date_created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', [user.first_name, user.last_name, user.email, user.user_type, pwd, user.gender, user.age, user.date_created], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'failed creating user'
          });
        } else {
          res.send({
            success: true,
            message: 'user created successfully'
          });
        }
      });
    });
  };

  User.updateUser = function(user, id, res) {
    var pwd;
    pwd = hashPassword(user.password);
    connection.acquire(function(err, con) {
      con.query('UPDATE users SET first_name = ?, last_name = ?, email = ?, user_type = ?, password = ?, gender = ?, age = ? WHERE id = ?', [user.first_name, user.last_name, user.email, user.user_type, pwd, user.gender, user.age, id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'user update failed'
          });
        } else {
          res.send({
            success: true,
            message: 'user updated successfully'
          });
        }
      });
    });
  };

  User.deleteUser = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('DELETE FROM users WHERE id = ?', [id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'failed deleting user'
          });
        } else {
          res.send({
            success: true,
            message: 'user deleted successfully'
          });
        }
      });
    });
  };

  hashPassword = function(pwd) {
    var hash;
    hash = bcrypt.hashSync(pwd);
    return hash;
  };

  return User;

})();
