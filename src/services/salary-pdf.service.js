const PDFDocument = require('pdfkit')
const fs = require('fs')

exports.createPDF = function(empData, dataCallback, endCallback){
    console.log(`creating PDF: emp_id=${empData.emp_id} month/year=${empData.month}/${empData.year}`)
    const dataX = 220
    const doc = new PDFDocument();

    doc.on('data', dataCallback);
    doc.on('end', endCallback);

    doc
    .fontSize(27)
    .text(`Salary Details of empId: ${empData.emp_id}`, 100, 100)
    .fontSize(15)
    .text('Name:', 100, 150)
    .text(empData.emp_name, dataX, 150)
    .text('Month:', 100, 200)
    .text(empData.month, dataX, 200)
    .text('Year:', 100, 250)
    .text(empData.year, dataX, 250)
    .text('Total Salary:', 100, 300)
    .text(empData.total_salary, dataX, 300)
    .text('EPF:', 100, 350)
    .text(empData.epf, dataX, 350)
    .text('ETF:', 100, 400)
    .text(empData.etf, dataX, 400)
    .text('Tax Deduction:', 100, 450)
    .text(empData.tax_deduction, dataX, 450)
    .text('Other Deduction:', 100, 500)
    .text(empData.other_deduction, dataX, 500)
    .text('Net Salary:', 100, 550)
    .text(empData.net_salary, dataX, 550)
    ;

    doc.end();
}
