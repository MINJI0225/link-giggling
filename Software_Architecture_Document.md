# Software Architecture Document
<!-- __문서 작성 시 가장 중요한 것은 UML을 얼마나 잘 썼는지, 얼마나 많이 썼는지 등 보다는, 읽는 사람에게 얼마나 쉽게 의미가 잘 전달 되었는지다.__ -->
## 1. Introduction
### 1.1 문서 목적
<!-- 문서가 작성되는 이유와 달성하고자 하는 목표 -->
본 문서의 목적은 미디어 콘텐츠 재생 프로그램의 Architecture Design와 이의 요구사항을 기술하는  것이다.

### 1.2 시스템 범위
<!-- 개발 하는 시스템의 간략한 개요 및 주요 기능 -->
본 문서의 범위는 미디어 콘텐츠 재생 프로그램의 서버와 데이터베이스의 요구사항으로 한정한다.

### 1.3 용어 정의
* React: 사용자 인터페이스를 위한 자바스크립트 라이브러리 중 하나이다. 
* Node.js: 확장성 있는 네트워크 애플리케이션 개발에 사용되는 소프트웨어 플랫폼이다.
* MySQL: 데이터 베이스를 구축하기 위한 오픈 소스 관계형 데이터베이스 관리 시스템(RDBMS)이다.

## 2. Architecture Overview
### 시스템 컨텍스트 (System Context)
LinkGiggling 프로젝트는 이용자에게 시각적인 서비스와 상호작용을 제공하는 프론트엔드(Frontend)와 영상 정보 처리 및 송출과 프론트엔드와 데이터베이스 사이에서 데이터 및 요청를 전달하는 벡엔드(Backend), 데이터 저장 및 전송을 담당하는  데이터베이스(Database)로 구분하여 구현한다.


## 3. 요구사항(Requirements)
<!-- * 주어진 과제의 성공을 위해 개발하는 시스템이 만족해야하는 기능과 비기능 요구사항 작성 -->
### 3.1. 기능 요구사항 (Functional Requirements)
<!-- * 시스템이 제공해야 하는 모든 기능을 명확하게 기술하며, 명세 내용은 모두가 이해하기 쉽고 간결하게 작성한다.
* 외부모듈로부터의 특정 입력에 대한 요구사항
* 특정 상황에서 제품이 제공해야하는 동작 기능에 대한 요구사항 -->

### 3.1.1 로그인 이전
1. `FR01`: 이용자 추가하기
   -   `FR01-1`: 사용자가 회원가입 요청이 있을 때, 사용자 정보를 입력 받은 후 데이터베이스에 추가한다.

2. `FR02`: 로그인
   -  `FR02-1`: 사용자가 로그인 요청을 할 경우 userID를 입력받은 후 서버의 데이터베이스에 비교하고 등록되어있는 아이디라면 로그인을 수행한다.

### 3.1.2 로그인 이후
1. `FR03`: 미디어 재생
   -  `FR03-1`: 사용자가 원하는 미디어를 재생 요청할 경우, 그 미디어 파일 재생한다. 
   -  `FR03-2`: 미디어 재생 과정에서 재생/일시 정지 기능을 지원한다.

2. `FR04`: 로그아웃
   -  `FR04-1`: 사용자에게 로그아웃 요청이 있을 경우, 로그인 이전 상태로 돌아간다.

## 4. Data Design
본 절에서는 Database Schema에 대해 기술한다.
### 4.1 user
이용자의 계정 정보 저장한다.
| Field | DataType | Default | Attribute |
| ----- | -------- | ------- | --------- |
| userCode | INT | not null | 빠른 검색, PRIMARY KEY, UNSIGNED, AUTO_INCREMENT |
| userID | VARCHAR(45) | not null | UTF-8, 최대 15자, UNIQUE |
| password | VARBINARY(64) | not null | SHA-256 |
| mail | VARCHAR(50) | null | UNIQUE |
 

### 4.2 profile
이용자의 계정 정보 저장한다.
| Field | DataType | Default | Attribute |
| ----- | -------- | ------- | --------- |
| userCode | INT | not null | 빠른 검색, PRIMARY KEY, UNSIGNED, AUTO_INCREMENT |
| nickname | VARCHAR(30) | null | UTF-8, 최대 10자 |
| userInfo | SET | null | (’male’, ‘female’) |
| birthYear | INT | null | |
| nation | CHAR(2) | null | 국가 코드 (ex KR, JP, US) |


### 4.3 medInfo
동영상 내용 정보를 저장한다.
| Field | DataType | Default | Attribute |
| ----- | -------- | ------- | --------- |
| medID | INT | not null | 빠른 검색, PRIMARY KEY, UNSIGNED |
| title | VARCHAR(255) | not null | media의 제목 |
| category | INT | null | 장르 코드 UNSIGNED |
| URL | TEXT | null | 장르 코드 UNSIGNED |


### 4.4 quality
동영상 파일 정보를 저장한다.
| Field | DataType | Default | Attribute |
| ----- | -------- | ------- | --------- |
| medID | INT | not null | 빠른 검색, PRIMARY KEY, UNSIGNED |
| resolution | SET | not null | ('360', '720', '1080', 1440', '2160') 세로 픽셀 기준 |
| length | TIME | 00:00:00 | 영상 길이 |


### 4.5 history
이용자의 영상 시청 기록을 저장한다.
| Field | DataType | Default | Attribute |
| ----- | -------- | ------- | --------- |
| usrCode | INT | not null | 빠른 검색, COMPOSIT KEY, UNSIGNED, UNIQUE |
| medID | INT | not null | 빠른 검색, COMPOSIT KEY, UNSIGNED, UNIQUE |
| bufferingStart | TIME | 00:00:00 | 영상 시작 시간 |
