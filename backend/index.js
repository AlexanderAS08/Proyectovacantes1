const express = require("express");
const cors = require("cors");
const helmet = require("helmet");

let app = express();
let host = "localhost";
let port = "9000";

app.use(cors());
app.use(helmet());
app.use(express.json());

app.use('/api', require("./routes"));

app.listen((host, port), () => {
  console.log(`Corriendo en http://${host}:${port}`)
})