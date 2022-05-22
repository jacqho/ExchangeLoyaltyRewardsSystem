const express = require("express");
const cors = require("cors");
const config = require('./config.js');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const database = require('./helpers/database');
const rewardRoutes = require("./routes/reward");

const url = config.db.url;
const app = express();
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use(express.raw({ limit: '1kb' , type: "application/xml" }));
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use('/api/reward', rewardRoutes);
database.connectDB(url);

module.exports = app;