const express = require('express')
const router = express.Router()
const { body } = require('express-validator')

// ゆうこうせいけんさき検査機
// 미들웨어
const registerValodator = [
    body('username', 'userame cannot be empty!').not().isEmpty(),
    body('password', 'password cannot be empty!').not().isEmpty()
]


router.post('/register', registerValodator, authController.register)

module.exports = router