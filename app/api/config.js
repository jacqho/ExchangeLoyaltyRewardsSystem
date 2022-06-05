const dotenv = require('dotenv');
dotenv.config();

const env = process.env.NODE_ENV;

const general = {
    third_parties: {
        fabric: {
            
        }
    }
}

const prod = {
    app: {
        port: parseInt(process.env.PROD_APP_PORT)
    },
    db: {
        url: process.env.PROD_DB
    },
    third_parties: {
        fabric: {
            
        }
    }
};

const dev = {
    app: {
        port: parseInt(process.env.DEV_APP_PORT) || 5000
    },
    db: {
        url: process.env.DEV_DB
    },
    third_parties: {
        fabric: {
            
        }
    }
};

const test = {
    app: {
        port: parseInt(process.env.TEST_APP_PORT) || 5000
    },
    db: {
        url: process.env.TEST_DB
    },
    third_parties: {
        fabric: {
            
        }
    }
};

const config = {
    prod,
    dev,
    test
};

module.exports = config[env];