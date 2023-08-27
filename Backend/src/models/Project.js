// const mongoose = require('mongoose');
// const multer = require('multer');

// // Set up Multer storage
// const storage = multer.diskStorage({
//     destination: function(req, file, cb) {
//         cb(null, 'uploads/'); // Specify the folder where the uploaded files will be stored
//     },
//     filename: function(req, file, cb) {
//         cb(null, Date.now() + '-' + file.originalname); // Set the filename to be unique using the current timestamp
//     },
// });

// // File filter function to restrict file types if needed
// const fileFilter = (req, file, cb) => {
//     if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
//         cb(null, true);
//     } else {
//         cb(new Error('Only JPEG and PNG file types are allowed.'), false);
//     }
// };

// // Create a Multer instance with the defined storage and file filter
// const upload = multer({
//     storage: storage,
//     fileFilter: fileFilter,
// });

// const projectSchema = mongoose.Schema({
//     name: {
//         type: String,
//         required: true,
//     },
//     mobileNumber: {
//         type: String,
//         required: true,
//     },
//     date: {
//         type: String,
//         required: true,
//     },
//     description: {
//         type: String,
//         required: true,
//     },
//     totalBill: {
//         type: Number,
//         required: true,
//     },
//     image1: {
//         data: Buffer,
//         contentType: String,
//     },
//     image2: {
//         data: Buffer,
//         contentType: String,
//     },
// });

// const Project = mongoose.model('Project', projectSchema);

// module.exports = {
//     Project: Project,
//     upload: upload,
// };
const mongoose = require("mongoose");
const multer = require("multer");

// Set up Multer storage
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/"); // Specify the folder where the uploaded files will be stored
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname); // Set the filename to be unique using the current timestamp
  },
});

// File filter function to restrict file types if needed
const fileFilter = (req, file, cb) => {
  if (file.mimetype === "image/jpeg" || file.mimetype === "image/png") {
    cb(null, true);
  } else {
    cb(new Error("Only JPEG and PNG file types are allowed."), false);
  }
};

// Create a Multer instance with the defined storage and file filter
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
});

const projectSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  mobileNumber: {
    type: String,
    required: true,
  },
  date: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  totalBill: {
    type: Number,
    required: true,
  },
  imageUrl1: {
    type: String,
  },
  imageUrl2: {
    type: String,
  },
});

const Project = mongoose.model("Project", projectSchema);

module.exports = {
  Project: Project,
  upload: upload,
};
