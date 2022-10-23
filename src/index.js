const express = require('express')
const app = express()

const { server } = require('./config/server.config')
const port = server.port

// import routes
const routes = require('./route/routes')
app.use('/employee_salary', routes)

app.listen(port, () => console.log(`Server started listening on port ${port}!`))

