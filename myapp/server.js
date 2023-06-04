const express = require('express')
const session = require('express-session')
const path = require('path');
const app = express()
const port = 3000

const db = require('./lib/dbconfig.js');
const bodyParser = require('body-parser');

app.use(express.static(path.join(__dirname, '/build')));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const FileStore = require('session-file-store')(session)

var authCheck = require('./auth/authCheck.js');

app.use(session({
  key: 'session_cookie_name',
  secret: '~',
	resave: false,
	saveUninitialized: false,
  store: new FileStore()
}))

app.get('/', (req, res) => {    
  req.sendFile(path.join(__dirname, '/build/index.html'));
})

app.get('/authcheck', (req, res) => {
  const sendData = {isLogin: ""}
  if (!authCheck.isOwner(req, res)) {  // 로그인 안되어있으면 로그인 페이지로 이동시킴
    sendData.isLogin = "False"
  } else {                                      // 로그인 되어있으면 메인 페이지로 이동시킴
    sendData.isLogin = "True"
  }
  authCheck.statusUI(req, res);
  res.send(sendData);
})

// 로그인 프로세스
app.post('/login', (req, res) => {
  const username = req.body.userId;
  const password = req.body.userPassword;

  console.log(password);

  const sendData = {isLogin: "" };

  if (username && password) {             // id와 pw가 입력되었는지 확인
      db.query('CALL LOGIN(?,?)', [username, password], function(error, row, fields) {
          const result = JSON.parse(JSON.parse(JSON.stringify(row[0]))[0].LOGIN).userCode;
          console.log(result);
          if (error) throw error;
          if (result != "-1") {       // 비밀번호가 일치하면
              req.session.is_logined = true;      // 세션 정보 갱신 
              req.session.nickname = username;
              console.log('success');  
              req.session.save(function () {
                  sendData.isLogin = "True"
                  res.send(sendData);
              });
          }
          else{                                   // 비밀번호가 다른 경우
              sendData.isLogin = "로그인 정보가 일치하지 않습니다."
              res.send(sendData);
          }            
      });

  } else {
      sendData.isLogin = "아이디와 비밀번호를 입력하세요!"
      res.send(sendData);
  }
});

// 로그아웃
app.get('/logout', function (req, res) {
  req.session.destroy(function (err) {
      res.redirect('/');
  });
});

// 회원가입
app.post('/signin', function(req, res) {    
  const username = req.body.userId;
  const password = req.body.userPassword;    
  const password2 = req.body.userPassword2;
  const email = req.body.userEmail;

  const sendData = {isSuccess: ""};

  if (username && password && password2 && email) {
      
      db.query('SELECT * FROM user WHERE userID = ?', [username], function(error, results, fields) { // DB에 같은 이름의 회원아이디가 있는지 확인
          if (error) throw error;
          if (results.length <= 0 && password === password2) {     // DB에 같은 이름의 회원아이디가 없고, 비밀번호가 올바르게 입력된 경우 
              db.query('CALL ADD_USER(?,?,?)', [username, password, email], function (error, row) {
                const result = JSON.parse(JSON.parse(JSON.stringify(row[0]))[0].ADD_USER).success;
                console.log(result);
                  if (error) throw error;
                  if (result == true) {
                    req.session.save(function () {                        
                      sendData.isSuccess = "True"
                      res.send(sendData);
                  });
                  } else {
                    sendData.isSuccess = "이미 존재하는 이메일입니다!"
                    res.send(sendData);
                  }
              });
          } else if (password != password2) {                     // 비밀번호가 올바르게 입력되지 않은 경우
              sendData.isSuccess = "입력된 비밀번호가 서로 다릅니다."
              res.send(sendData);
          }
          else {                                                  // DB에 같은 이름의 회원아이디가 있는 경우
              sendData.isSuccess = "이미 존재하는 아이디입니다!"
              res.send(sendData); 
          }            
      });

  } else {        // 입력되지 않은 정보가 있는 경우
      sendData.isSuccess = "아이디,비밀번호와 이메일을 입력하세요!"
      res.send(sendData);  
  }
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
