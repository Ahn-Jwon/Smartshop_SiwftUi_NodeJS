const jwt = require('jsonwebtoken')
const bcrypt = require('bcryptjs')
const models = require('../models')
const { Op, where } = require('sequelize');
const { validationResult } = require('express-validator');


// *Login*
exports.login = async (req, res) => {
    try {
    // validate Input
    const errors = validationResult(req);
    if (!errors.isEmpty()) {

        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ message: msg, success: false });
    }
    
    const { username, password } = req.body

    // check if user exists
    const existingUser = await models.User.findOne({
        where: {
            username: { [Op.iLike]: username }
        }
    })

    if(!existingUser) {
        res.status(401).json({ message: "Username or password is incorrect", success: false })
    }

    // Check the passwod
    const isPasswordValid = await bcrypt.compare(password, existingUser.password)
    if(!isPasswordValid) {
        res.status(401).json({ message: "Username or password is incorrect", success: false })
    }

    // generate JWT token
    const token = jwt.sign({ userId: existingUser.id }, 'SECRETKEY', {
        expiresIn: '1h'
    })

    return res.status(200).json({ userId: existingUser.id, username: existingUser.username, token, success: true })
    } catch(error) {
        res.status(500).json({ message: "Internal server error.", success: false })
    }
}

// *회원가입 Sign Up*
exports.register = async (req, res) => {

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
}