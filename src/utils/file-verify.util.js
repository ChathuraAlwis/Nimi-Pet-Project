const { files } = require('../config/files.config')

module.exports = function(uploaded_files){
    if(!uploaded_files) throw new Error("No file uploaded")
    if(uploaded_files.csv_file.mimetype != files.uploads.type) throw new Error("Invalid file type") 
    if(uploaded_files.csv_file.size > files.uploads.max_size) throw new Error("File too large")
}