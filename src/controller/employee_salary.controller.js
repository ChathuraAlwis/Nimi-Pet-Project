const pool = require('../model/db.model')
const path = require('path')
const file_verify_util = require('../utils/file-verify.util')
const create_record_util = require('../utils/create-record.util')
const salary_PDF_service = require('../services/salary-pdf.service')

const uploadCSV = async(req, res) => {
    try {
        console.log("Uploading CSV...")
        /* csv file validation */
        const files = req.files
        file_verify_util(files) // will throw error if caught
        const csv_file = files.csv_file.data.toString('utf8') // select file using file key(csv_file)
        const lines = csv_file.split('\r\n')
        let uploaded_lines = 0
        for (line_str in lines){
            const line = parseInt(line_str)
            console.log(`Reading row: ${lines[line]}`)
            const record = create_record_util(lines[line], line) // validates row and returns a object
            console.log(`Created record: ${record}`)

            const sql = `INSERT INTO public.employee_salary(emp_id, emp_name, month, year, total_salary, epf, etf, tax_deduction, other_deduction, net_salary) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);`
            const values = [record.emp_id, record.emp_name, record.month, record.year, record.total_salary, record.epf, record.etf, record.tax_deduction, record.other_deduction, record.net_salary]
            const result = await pool.query(sql, values)

            uploaded_lines += result.rowCount
            console.log(sql, values)
        }

        // response
        const response = {
            rowCount: uploaded_lines
        }

        console.log(`Inserted total row count: ${uploaded_lines}`)
        res.send(response)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}
    
const updateRecord = async(req, res) => {
    try {
        const { id, ...rest } = req.body

        for (arg in rest){
            const sql = `UPDATE public.employee_salary SET ${arg}=$1 WHERE id=$2;`
            const result = await pool.query(sql, [rest[arg], id])
            console.log(sql, [rest[arg], id])
        }

        res.send(`Record updated`)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const deleteRecord = async(req, res) => {
    try {
        const { id } = req.params
        const sql = `DELETE from public.employee_salary WHERE id=$1;`
        const values = [id]
        const result = await pool.query(sql, values)
        console.log(sql, values)
        res.send(`Record ${id} deleted`)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const getArchived = async(req, res) => {
    try {
        const sql = `SELECT * FROM public.employee_salary WHERE archived=TRUE;`
        const result = await pool.query(sql)
        console.log(sql)
        res.send(result)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const getUnarchived = async(req, res) => {
    try {
        const sql = `SELECT * FROM public.employee_salary WHERE archived=FALSE;`
        const result = await pool.query(sql)
        console.log(sql)
        res.send(result)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const archiveRecord = async(req, res) => {
    try {
        const { id } = req.params
        const sql = `UPDATE public.employee_salary SET archived=TRUE WHERE id=$1;`
        const values = [id]
        const result = await pool.query(sql, values)
        console.log(sql, values)
        result.rowCount ? res.send(`Record ${id} archived`) : res.send("No record found to update")
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const unarchiveRecord = async(req, res) => {
    try {
        const { id } = req.params
        const sql = `UPDATE public.employee_salary SET archived=FALSE WHERE id=$1;`
        const values = [id]
        const result = await pool.query(sql, values)
        console.log(sql, values)
        result.rowCount ? res.send(`Record ${id} archived`) : res.send("No record found to update")
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const downloadSalaryPDF = async(req, res) => {
    try {
        const { id } = req.params
        const result = await pool.query(
            `SELECT * FROM public.employee_salary WHERE id=$1;`,
            [id]
        )
        const emp_data = result.rows[0]

        const stream = res.writeHead(200, {
            'Content-Type': 'application/pdf',
            'Content-Disposition': 'attachment;filename=salary-details.pdf'
        })
        salary_PDF_service.createPDF(
            emp_data, 
            (chunk) => stream.write(chunk),
            () => stream.end()
        )
        console.log("PDF downloaded")
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const getEmployee = async(req, res) => {
    try {
        const { id } = req.params
        const sql = `SELECT * FROM public.employee_salary WHERE emp_id=$1;`
        const values = [id]
        const result = await pool.query(sql, values)
        console.log(sql, values)
        res.send(result)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

const getMonth = async(req, res) => {
    try {
        const { month, year } = req.params
        const sql = `SELECT * FROM public.employee_salary WHERE month=$1 AND year=$2;`
        const values = [month, year]
        const result = await pool.query(sql, values)
        console.log(sql, values)
        res.send(result)
    } catch (error) {
        console.error(error)
        res.send(error.message)
    }
}

module.exports = {
    uploadCSV, 
    updateRecord, 
    deleteRecord, 
    archiveRecord, 
    unarchiveRecord, 
    getUnarchived, 
    getArchived, 
    downloadSalaryPDF, 
    getEmployee, 
    getMonth
}