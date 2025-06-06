const express = require("express")
const models = require('./models')
const { Op } = require('sequelize') //ID 중복 확인
const bcrypt = require('bcryptjs') // Password 해시 암호화
const cors = require('cors')
//const { body, validationResult } = require('express-validator')
const { errorMonitor } = require("pg/lib/query.js")
const authRoutes = require('./routes/auth')
const app = express()


// CORS
app.use(cors())
// JSON parser
app.use(express.json())
// register our rotuers
// /api/auth/login
// /api/auth/register
app.use('/api/auth', authRoutes) 

// サーバをstartすればこの機能を開始する
app.listen(8080, () => {
    console.log('Server is running.')
})