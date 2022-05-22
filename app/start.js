const app = require('./server');
const config = require('./config');
const { app: { port } } = config;

const server = app.listen(port, () => console.log(`listening on port ${port}`));
module.exports = server;