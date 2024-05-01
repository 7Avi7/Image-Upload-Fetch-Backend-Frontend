const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");
const path = require("path");

const app = express();
const port = 3000;

// Multer configuration
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const upload = multer({
  storage: storage,
  fileFilter: (req, file, cb) => {
    if (!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)) {
      return cb(new Error("Only image files are allowed!"), false);
    }
    cb(null, true);
  },
});

// MongoDB configuration
mongoose
  .connect("mongodb://localhost:27017/my_database")
  .then(() => console.log("database connection successful!"))
  .catch((err) => console.log(err));
const db = mongoose.connection;
db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", function () {
  console.log("MongoDB connected successfully");
});

const ImageSchema = new mongoose.Schema({
  path: String,
});

const ImageModel = mongoose.model("Image", ImageSchema);

// Serve uploaded images statically
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Serve image "avi.png" from the "images" folder
app.get("/avi-image", (req, res) => {
  const imagePath = path.join(__dirname, "uploads", "images", "avi.png");
  res.sendFile(imagePath);
});

// Route for image upload
app.post("/upload", upload.single("image"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send("No file uploaded.");
    }

    const image = new ImageModel({ path: req.file.path });
    await image.save();

    // Construct the URL of the uploaded image
    const imageUrl = `/uploads/${req.file.filename}`; // Changed to relative URL
    res.status(200).json({ imageUrl: imageUrl });
  } catch (error) {
    console.error(error);
    res.status(500).send("Error uploading image");
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send("Something broke!");
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
