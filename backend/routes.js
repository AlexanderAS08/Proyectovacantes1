const express = require("express");
const api = express.Router();
const Controllers = require('./controllers');

const multer = require('multer');
const path = require('path');
const filepath = path.join(__dirname, 'documents');
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, filepath)
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}${path.extname(file.originalname)}`)
  }
});

const upload = multer({storage: storage});

api.post("/:entity/by", Controllers.getEntitiesBy);
api.post("/:entity/create", Controllers.createEntities);
api.put("/:entity/update", Controllers.updateEntities);

api.post("/upload-document", upload.single('file'), Controllers.uploadDocument)

module.exports = api;