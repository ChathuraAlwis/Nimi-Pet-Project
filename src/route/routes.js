const express = require('express')
const router = express.Router()
const upload = require('express-fileupload')
const { 
    uploadCSV, 
    updateRecord, 
    deleteRecord, 
    archiveRecord, 
    unarchiveRecord , 
    getUnarchived, 
    getArchived, 
    downloadSalaryPDF ,
    getEmployee,
    getMonth
} = require('../controller/employee_salary.controller')


// middleware
router.use(express.json())
router.use(upload())



// employee_salary table handling

router.post('/', uploadCSV) // Upload

router.put('/', updateRecord)// Update

router.delete('/:id', deleteRecord) // Delete

router.put('/archive/:id', archiveRecord) // Archive

router.put('/unarchive/:id', unarchiveRecord) // Unarchive

router.get('/unarchived', getUnarchived) // List data that aren't archived

router.get('/archived', getArchived) // List data that are archived

router.get('/employee/:id', getEmployee) // List data by employee id

router.get('/month/:month/:year', getMonth) // List data by month/year


// salary PDF download

router.get('/download/:id', downloadSalaryPDF) // download salary pdf by employee_salary.id column


module.exports = router