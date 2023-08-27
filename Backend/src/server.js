const express = require("express");
const cors = require("cors");
const app = express();
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const multer = require("multer");
const fs = require("fs");

// xzbvjEnable CORS
app.use(cors());

// Connect to MongoDB
mongoose
  .connect(
    "mongodb+srv://Pankaj:Pankaj%4043145@cluster0.plgfikp.mongodb.net/?retryWrites=true&w=majority"
  )
  .then(() => {
    console.log("Connected to MongoDB");

    app.use(bodyParser.urlencoded({ extended: false }));
    app.use(bodyParser.json());

    // Set up Multer storage for handling file uploads
    const storage = multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, "uploads/");
      },
      filename: function (req, file, cb) {
        cb(null, Date.now() + "-" + file.originalname);
      },
    });

    const upload = multer({ storage: storage });

    // Set up a route for serving static files (uploaded images)
    app.use("/uploads", express.static("uploads"));

    // Import the Password model
    const Password = require("./models/password");

    // Import the Project model
    const { Project } = require("./models/Project");

    // Root endpoint
    app.get("/", function (req, res) {
      const response = { message: "API works" };
      res.json(response);
    });

    // API endpoint to check if the entered ID and password are present in the database
    app.post("/checkPassword", async (req, res) => {
      try {
        const { mobileno, password } = req.body;

        if (!mobileno || !password) {
          return res.status(400).json({ error: "Missing required fields" });
        }

        const foundPassword = await Password.findOne({ mobileno, password });

        if (foundPassword) {
          res.json({ message: "Password found in the database" });
        } else {
          res.json({ message: "Password not found in the database" });
        }
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    });

    // Endpoint for getting all projects

    app.get("/projects", async function (req, res) {
      try {
        const projectList = await Project.find();

        // Create an array to store modified project objects with image URLs
        const projectsWithImages = [];

        // Loop through each project object
        for (const project of projectList) {
          const projectWithImages = {
            ...project._doc,
            imageUrl1: project.imageUrl1
              ? `http://localhost:3000${project.imageUrl1}`
              : null,
            imageUrl2: project.imageUrl2
              ? `http://localhost:3000${project.imageUrl2}`
              : null,
          };
          projectsWithImages.push(projectWithImages); // Add the modified project object to the array
        }

        res.json(projectsWithImages); // Return the projects array with image URLs as JSON
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    });

    // Endpoint for adding a new project
    app.post(
      "/projects",
      upload.fields([
        { name: "image1", maxCount: 1 },
        { name: "image2", maxCount: 1 },
      ]),
      async (req, res) => {
        try {
          const { name, mobileNumber, date, description, totalBill } = req.body;
          let imageUrl1 = "";
          let imageUrl2 = "";

          // Check if image1 is present
          if (req.files && req.files["image1"]) {
            const image1 = req.files["image1"][0];
            imageUrl1 = `/uploads/${image1.filename}`;
          }

          // Check if image2 is present
          if (req.files && req.files["image2"]) {
            const image2 = req.files["image2"][0];
            imageUrl2 = `/uploads/${image2.filename}`;
          }

          if (!name || !mobileNumber || !date || !description) {
            return res.status(400).json({ error: "Missing required fields" });
          }

          const newProject = new Project({
            name,
            mobileNumber,
            date,
            description,
            totalBill,
            imageUrl1,
            imageUrl2,
          });

          const savedProject = await newProject.save();
          res.status(201).json(savedProject);
        } catch (error) {
          res.status(500).json({ error: error.message });
        }
      }
    );

    // Endpoint for deleting a project
    app.delete("/projects", async (req, res) => {
      try {
        const { name, mobileNumber, date, description, totalBill } = req.body;

        // Check if all required fields are present
        if (!name || !mobileNumber || !date || !description || !totalBill) {
          return res.status(400).json({ error: "Missing required fields" });
        }

        // Find the project with the provided details in the database
        const projectQuery = {
          name,
          mobileNumber,
          date,
          description,
          totalBill,
        };

        const project = await Project.findOneAndDelete(projectQuery);

        if (!project) {
          return res.status(404).json({ error: "Project not found" });
        }

        res.json({ message: "Project deleted successfully" });
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    });

    // Start the server
    const port = process.env.PORT || 3000;
    app.listen(port, () => {
      console.log(`Server is listening on port ${port}`);
    });
  })
  .catch((error) => {
    console.error("Failed to connect to MongoDB", error);
  });
