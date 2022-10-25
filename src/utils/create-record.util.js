module.exports = function(row, row_number){
    let str_arr = row.split(',');
    const row_length = str_arr.length   // number of comma seperated data

    // compulsory data
    const record = {
        emp_id :            parseInt(str_arr[0]),
        emp_name:           str_arr[1],
        month :             parseInt(str_arr[2]),
        year :              parseInt(str_arr[3]),
        total_salary :      parseFloat(str_arr[4])  
    }

    // optional data
    record.epf = row_length>=6 ? parseFloat(str_arr[5]) : 0
    record.etf = row_length>=7 ? parseFloat(str_arr[6]) : 0
    record.tax_deduction = row_length>=8 ? parseFloat(str_arr[7]) : 0
    record.other_deduction = row_length>=9 ? parseFloat(str_arr[8]) : 0

    // net_salary calculation
    const calclulated_net_salary = record.total_salary - (
        record.epf + record.etf + record.tax_deduction + record.other_deduction
    )

    record.net_salary = row_length>=10 ? parseFloat(str_arr[9]) : calclulated_net_salary

    // invalid data format found in csv
    for (key in record){
        if (record[key] !== record[key]) throw new Error(`Invalid data found in CSV file in line: ${row_number+1}`)
    }

    return record
}