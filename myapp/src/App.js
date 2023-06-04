import './App.css';
import { useState } from 'react';
import { useEffect } from 'react';
import { Fragment } from 'react';
import { BrowserRouter as Router, Link, Route, Routes } from 'react-router-dom';
import VideoPlayer from './components/VideoPlayer';
import ImageButtonList from './components/ImageButtonList';
import ButtonList from './components/ButtonList';

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
        alert(json.med);
        props.setList(json.med);
      }
      else{
        alert(json.isSuccess)
      }
    });
  }); 

  props.setMode("MAIN");

  return;
}

function Category(props) {
  const medData = {
    category: props.category
  };

  useEffect(() => {
    fetch("http://localhost:3000/category", { //search 주소에서 받을 예정
    method: "post", // method :통신방법
    headers: {      // headers: API 응답에 대한 정보를 담음
      "content-type": "application/json",
    },
    body: JSON.stringify(medData), //userData라는 객체를 보냄
  })
    .then((res) => res.json())
    .then((json) => {
      if(json.isSuccess==="True"){
        alert(json.med);
        props.setsecList(json.med);
      }
      else{
        alert(json.isSuccess)
      }
    });
  }); 

  props.setMode("MAIN");

  return;
}

function Video(props) {
  return <>
    <Fragment>
      <Router>
        <div>
          <Link to='/video' className='link'>Show Video</Link>
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
  const [category, setCategory] = useState("");
  const [media, setMedia] = useState("");
  const [images, setList] = useState([]);
  const [secimages, setsecList] = useState([]);

  const buttons = [
    { label: '애니메이션' },
    { label: '드라마' },
    { label: '로맨스' },
    { label: '코미디' },
    { label: '재난' },
    { label: '스릴러' },
    { label: '액션' },
    { label: '스포츠' },
    { label: '광고' },
  ];

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
    content = <>
    <div className="background">
      <Signin setMode={setMode}></Signin> 
    </div>
  </>
  }
  else if (mode === 'MAIN') {
    content = <>
      <div>
      <h2>LinkGiggling</h2>
      <div className="search">
        <div className="searchRow">
          <p><input className="searchText" type="text" placeholder="제목을 입력하세요" onChange={event => {
              setTitle(event.target.value);
          }} /></p>
          <p><input className="searchBtn" type="submit" value="검색" onClick={() => {
            setMode('SEARCH');
          }} /></p>
        </div>
        <ImageButtonList images={images} onClick={(image) => {
          const url = JSON.parse(JSON.stringify(image, ['URL'])).URL;
          setMedia(url);
          setMode('VIDEO');
        }} />
        <ButtonList buttons={buttons} onClick={(button, index) => {
          setCategory(index);
          setMode("CATEGORY");
        }} />
        <ImageButtonList images={secimages} onClick={(image) => {
          const url = JSON.parse(JSON.stringify(image, ['URL'])).URL;
          setMedia(url);
          setMode('VIDEO');
        }} />
      </div>
      <a href="/logout">로그아웃</a> 
      </div>  
    </>
  } else if (mode === 'SEARCH') {
    content = <>
      <div>
      <h2>LinkGiggling</h2>
      <Search title={title} setMode={setMode} setList={setList}></Search>
      <a className="done" href="/logout">로그아웃</a> 
      </div>  
    </>
  } else if (mode === 'CATEGORY') {
    content = <>
      <div>
      <h2>LinkGiggling</h2>
      <Category category={category} setMode={setMode} setsecList={setsecList}></Category>
      <a className="done" href="/logout">로그아웃</a> 
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