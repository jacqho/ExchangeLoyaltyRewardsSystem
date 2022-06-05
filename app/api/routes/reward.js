const express = require("express");
const controller = require("../controllers/reward");
const validator = require("../validators/reward");

const router = express.Router();

router.post('/generate', validator.generate, controller.generate);
router.post('/transfer', validator.transfer, controller.transfer);
router.get('/', validator.view, controller.view);

module.exports = router;