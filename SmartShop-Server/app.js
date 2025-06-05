const express = require("express")
const models = require('./models')
const { Op } = require('sequelize') //ID 중복 확인
const bcrypt = require('bcryptjs') // Password 해시 암호화
const cors = require('cors')
const { body, validationResult } = require('express-validator')
const { errorMonitor } = require("pg/lib/query.js")
const app = express()

// CORS
app.use(cors())
// JSON parser
app.use(express.json())

// ゆうこうせいけんさき検査機
const registerValodator = [
    body('username', 'userame cannot be empty!').not().isEmpty(),
    body('password', 'password cannot be empty!').not().isEmpty()
]

app.post('/api/auth/register', registerValodator, async (req, res) => {
    // ID 패스워드 회원가입 검증 현재는 Id와 비밀번호가 비어있으면 안되는 로직
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ success: false, message: msg })
    }

    const { username, password } = req.body
    // ID 중복 확인
    const existingUser = await models.User.findOne({
        where: {
            username: { [Op.iLike]: username }
        }
    })
    try {
        if (existingUser) {
            return res.json({ message: "Username taken!", success: false })
        }
        // 신규 비밀번호를 해쉬로 변환 (암호화)
        const salt = await bcrypt.genSalt(10)
        const hash = await bcrypt.hash(password, salt)
        // 신규등록
        const _ = models.User.create({
            username: username,
            password: hash
        })
        res.status(201).json({ success: true })
    } catch (error) {
        res.status(500).json({ message: "Internal server error.", success: false })
    }
})

// サーバをstartすればこの機能を開始する
app.listen(8080, () => {
    console.log('Server is running.')
})