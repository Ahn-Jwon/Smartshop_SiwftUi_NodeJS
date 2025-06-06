const express = require('express')
const router = express.Router()
const { body } = require('express-validator')
const authController = require('../controllers/authController')

// ゆうこうせいけんさき検査機
// 미들웨어
const registerValodator = [
    body('username', 'userame cannot be empty!').not().isEmpty(),
    body('password', 'password cannot be empty!').not().isEmpty()
]

const loginValodator = [
    body('username', 'userame cannot be empty!').not().isEmpty(),
    body('password', 'password cannot be empty!').not().isEmpty()
]

router.post('/register', registerValodator, authController.register)
router.post('/login', loginValodator, authController.login)

module.exports = router