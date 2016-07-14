connection = require '../config/connection'

module.exports = class Doc
	#get all workouts
	#do connection, select all from workouts
	@getAllDocuments = (res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM documents', (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one document
	#do connection, select one workout from database
	@getSingleDocument = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT * FROM documents WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#get one document --SHORT
	#do connection, select one workout from database
	@getSingleDocumentShort = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'SELECT id, title, collection, template FROM documents WHERE id = ?', [id], (err, result) ->
				con.release()
				res.send result
				return
			return
		return

	#do connection, insert workout data into database
	@createDocument = (doc, res) ->
		connection.acquire (err, con) ->
			con.query 'INSERT INTO documents (title, collection, user_id, template, date_created) VALUES (?, ?, ?, ?, ?)',
			[doc.title, doc.collection, doc.user_id, doc.template, doc.date_created], (err, result) ->
				con.release()
				#error check if succesful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed creating document')
				else
					res.send
						success: true
						message: 'document created successfully'
				return
			return
		return

	#update
	#do connection, update document data item with id
	@updateDocument = (doc, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE documents SET title = ?, collection = ?, user_id = ?, template = ?, date_created = ? WHERE id = ?',
			[doc.title, doc.collection, doc.user_id, doc.template, doc.date_created, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'document update failed')
				else
					res.send
						success: true
						message: 'document updated successfully'
				return
			return
		return

	#update
	#do connection, update document data item with id
	@updateDocumentTemplate = (doc, id, res) ->
		connection.acquire (err, con) ->
			con.query 'UPDATE documents SET template = ? WHERE id = ?',
			[doc.template, id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'document update failed')
				else
					res.send
						success: true
						message: 'document updated successfully'
				return
			return
		return

	#delete
	#do connection, delete document data with id
	@deleteDocument = (id, res) ->
		connection.acquire (err, con) ->
			con.query 'DELETE FROM documents WHERE id = ?', [id], (err, result) ->
				con.release()
				#error check if successful query or not
				if err
					return res.status(403).send(
						success: false
						message: 'failed deleting document')
				else
					res.send
						success: true
						message: 'document deleted successfully'
				return
			return
		return