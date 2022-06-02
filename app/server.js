const express = require("express");
const cors = require("cors");
const bodyParser = require('body-parser');
const config = require('./config.js');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const rewardRoutes = require("./routes/reward");

const url = config.db.url;
const app = express();
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(cors());
app.use('/api/reward', rewardRoutes);

module.exports = app;