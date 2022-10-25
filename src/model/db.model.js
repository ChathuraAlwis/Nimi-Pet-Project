const { Pool } = require("pg");

const { db } = require('../config/db.config')

const pool = new Pool(db) //create db instance

module.exports = pool