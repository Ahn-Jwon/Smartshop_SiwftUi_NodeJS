const express = require("express")
const cors = require('cors')
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