import './App.css';
import { useState } from 'react';
import { useEffect } from 'react';
import { Fragment } from 'react';
import { BrowserRouter as Router, Link, Route, Routes } from 'react-router-dom';
import VideoPlayer from './components/VideoPlayer';

function Login(props) {
  const [id, setId] = useState("");
  const [password, setPassword] = useState("");
  
  return <>
    <h2>로그인</h2>

    <div className="form">
      <p><input className="login" type="text" name="username" placeholder="아이디" onChange={event => {
        setId(event.target.value);
      }} /></p>
      <p><input className="login" type="password" name="pwd" placeholder="비밀번호" onChange={event => {
        setPassword(event.target.value);
      }} /></p>

      <p><input className="btn" type="submit" value="로그인" onClick={() => {
        const userData = {
          userId: id,
          userPassword: password,
        };
        fetch("http://localhost:3000/login", { //auth 주소에서 받을 예정
          method: "post", // method :통신방법
          headers: {      // headers: API 응답에 대한 정보를 담음
            "content-type": "application/json",
          },
          body: JSON.stringify(userData), //userData라는 객체를 보냄
        })
          .then((res) => res.json())
          .then((json) => {            
            if(json.isLogin==="True"){
              props.setMode("MAIN");
            }
            else {
              alert(json.isLogin)
            }
          });
      }} /></p>
    </div>

    <p>계정이 없으신가요?  <button onClick={() => {
      props.setMode("SIGNIN");
    }}>회원가입</button></p>
  </> 
}


function Signin(props) {
  const [id, setId] = useState("");
  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [email, setEmail] = useState("");

  return <>
    <h2>회원가입</h2>

    <div className="form">
      <p><input className="login" type="text" placeholder="아이디" onChange={event => {
        setId(event.target.value);
      }} /></p>
      <p><input className="login" type="password" placeholder="비밀번호" onChange={event => {
        setPassword(event.target.value);
      }} /></p>
      <p><input className="login" type="password" placeholder="비밀번호 확인" onChange={event => {
        setPassword2(event.target.value);
      }} /></p>
      <p><input className="login" type="email" placeholder="이메일" onChange={event => {
        setEmail(event.target.value);
      }} /></p>

      <p><input className="btn" type="submit" value="회원가입" onClick={() => {
        const userData = {
          userId: id,
          userPassword: password,
          userPassword2: password2,
          userEmail: email
        };
        fetch("http://localhost:3000/signin", { //signin 주소에서 받을 예정
          method: "post", // method :통신방법
          headers: {      // headers: API 응답에 대한 정보를 담음
            "content-type": "application/json",
          },
          body: JSON.stringify(userData), //userData라는 객체를 보냄
        })
          .then((res) => res.json())
          .then((json) => {
            if(json.isSuccess==="True"){
              alert('회원가입이 완료되었습니다!')
              props.setMode("LOGIN");
            }
            else{
              alert(json.isSuccess)
            }
          });
      }} /></p>
    </div>

    <p>로그인화면으로 돌아가기  <button onClick={() => {
      props.setMode("LOGIN");
    }}>로그인</button></p>
  </> 
}

function Search(props) {
  const medData = {
    title: props.title
  };

  var lst = null;

  useEffect(() => {
    fetch("http://localhost:3000/search", { //search 주소에서 받을 예정
    method: "post", // method :통신방법
    headers: {      // headers: API 응답에 대한 정보를 담음
      "content-type": "application/json",
    },
    body: JSON.stringify(medData), //userData라는 객체를 보냄
  })
    .then((res) => res.json())
    .then((json) => {
      if(json.isSuccess==="True"){
        
      }
      else{
        alert(json.isSuccess)
      }
    });
  }); 

  return <>
    <div clasName="form">
      <ul>
        <p>{props.list}</p>
      </ul>
    </div>
    <p>로그인화면으로 돌아가기  <button onClick={() => {
      props.setMode("MAIN");
    }}>로그인</button></p>
  </> 
}

function Video(props) {
  return <>
    <h2>Video Name</h2>
    <Fragment>
      <Router>
        <div>
          <Link to='/video' className='link'>Video</Link>
        </div>
        <Routes>
          <Route exact path='/video' element={<VideoPlayer src={props.media} />} />
        </Routes>
      </Router>
    </Fragment>
    <p>메인화면으로 돌아가기  <button onClick={() => {
      props.setMode("MAIN");
    }}>HOME</button></p>
  </>
}

function App() {
  const [mode, setMode] = useState("");
  const [title, setTitle] = useState("");
  const [media, setMedia] = useState("");
  const [medList, setList] = useState("");

  useEffect(() => {
    fetch("http://localhost:3000/authcheck")
      .then((res) => res.json())
      .then((json) => {        
        if (json.isLogin === "True") {
          setMode("MAIN");
        }
        else {
          setMode("LOGIN");
        }
      });
  }, []); 

  let content = null;  

  if(mode==="LOGIN"){
    content = <>
      <div className="background">
        <Login setMode={setMode}></Login> 
      </div>
    </>
  }
  else if (mode === 'SIGNIN') {
    content = <Signin setMode={setMode}></Signin> 
  }
  else if (mode === 'MAIN') {
    content = <>
      <div>
      <h2>LinkGiggling</h2>
      <p><input className="search" type="text" placeholder="제목을 입력하세요" onChange={event => {
            setTitle(event.target.value);
          }} /></p>
      <p><input className="btn" type="submit" value="검색" onClick={() => {
        setMode('SEARCH');
      }} /></p>
      <p><input className="btn" type="submit" value="비디오" onClick={() => {
        setMedia("https://cdn.jwplayer.com/manifests/pZxWPRg4.m3u8");
        setMode('VIDEO');
      }} /></p>
      <a href="/logout">로그아웃</a> 
      </div>  
    </>
  } else if (mode === 'SEARCH') {
    content = <>
      <div>
      <h2>LinkGiggling</h2>
      <Search title={title} setMode={setMode} setList={setList}></Search>
      <a href="/logout">로그아웃</a> 
      </div>  
    </>
  } else if (mode === 'VIDEO') {
    content = <>
      <div>
      <h2>LinkGiggling</h2>
      <Video media={media} setMode={setMode}></Video>
      <a href="/logout">로그아웃</a> 
      </div>  
    </>
  }

  return (
    <>
      {content}
    </>
  );

}

export default App;