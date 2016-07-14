var Doc, connection;

connection = require('../config/connection');

module.exports = Doc = (function() {
  function Doc() {}

  Doc.getAllDocuments = function(res) {
    connection.acquire(function(err, con) {
      con.query('SELECT * FROM documents', function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  Doc.getSingleDocument = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT * FROM documents WHERE id = ?', [id], function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  Doc.getSingleDocumentShort = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('SELECT id, title, collection, template FROM documents WHERE id = ?', [id], function(err, result) {
        con.release();
        res.send(result);
      });
    });
  };

  Doc.createDocument = function(doc, res) {
    connection.acquire(function(err, con) {
      con.query('INSERT INTO documents (title, collection, user_id, template, date_created) VALUES (?, ?, ?, ?, ?)', [doc.title, doc.collection, doc.user_id, doc.template, doc.date_created], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'failed creating document'
          });
        } else {
          res.send({
            success: true,
            message: 'document created successfully'
          });
        }
      });
    });
  };

  Doc.updateDocument = function(doc, id, res) {
    connection.acquire(function(err, con) {
      con.query('UPDATE documents SET title = ?, collection = ?, user_id = ?, template = ?, date_created = ? WHERE id = ?', [doc.title, doc.collection, doc.user_id, doc.template, doc.date_created, id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'document update failed'
          });
        } else {
          res.send({
            success: true,
            message: 'document updated successfully'
          });
        }
      });
    });
  };

  Doc.updateDocumentTemplate = function(doc, id, res) {
    connection.acquire(function(err, con) {
      con.query('UPDATE documents SET template = ? WHERE id = ?', [doc.template, id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'document update failed'
          });
        } else {
          res.send({
            success: true,
            message: 'document updated successfully'
          });
        }
      });
    });
  };

  Doc.deleteDocument = function(id, res) {
    connection.acquire(function(err, con) {
      con.query('DELETE FROM documents WHERE id = ?', [id], function(err, result) {
        con.release();
        if (err) {
          return res.status(403).send({
            success: false,
            message: 'failed deleting document'
          });
        } else {
          res.send({
            success: true,
            message: 'document deleted successfully'
          });
        }
      });
    });
  };

  return Doc;

})();
