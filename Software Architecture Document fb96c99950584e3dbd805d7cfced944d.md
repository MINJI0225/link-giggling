# Software Architecture Document

---

# 1. Introduction

---

## 1.1. Purpose

본 문서의 목적은 LinkGiggling 프로젝트가 진행되는 데 있어 각 분야의 개발자와 원활한 소통을 위해 설계 내용을 밝히는 것이다.

## 1.2. Terminologies and Definitions

- React :
- Node.js :
- MySQL : 데이터 베이스를 구축하기 위한 오픈 소스 관계형 데이터베이스 관리 시스템(RDBMS)이다.

# 2. System Context

---

LinkGiggling 프로젝트는 이용자에게 시각적인 서비스와 상호작용을 제공하는 프론트엔드(Frontend)와 영상 정보 처리 및 송출과 프론트엔드와 데이터베이스 사이에서 데이터 및 요청를 전달하는 벡엔드(Backend), 데이터 저장 및 전송을 담당하는  데이터베이스(Database)로 구분하여 구현한다.

# 3. Architecture Overview

---

## 3.1. Frontend Architecture

## 3.2. Backend Architecture

## 3.3. Database Architecture

### 3.3.1. Database Schema

- user : 이용자의 계정 정보를 저장한다.

| Field | DataType | Defalut | Attribute |
| --- | --- | --- | --- |
| userCode | INT | not null | 빠른 검색
PRIMARY KEY
UNSIGNED
AUTO_INCREMENT |
| userID | VARCHAR(45) | not null | UTF-8
최대 15자
UNIQUE |
| password | VARBINARY(64) | not null | SHA-256 |
| mail | VARCHAR(50) | null | UNIQUE |

- profile : 이용자의 계정 정보를 저장한다.

| Field | DataType | Defalut | Attribute |
| --- | --- | --- | --- |
| userCode | INT | not null | 빠른 검색
PRIMARY KEY
UNSIGNED |
| nickname | VARCHAR(30) | null | UTF-8
최대 10자 |
| userInfo | SET | null | (’male’, ‘female’) |
| birthYear | INT | null |  |
| nation | CHAR(2) | null | 국가 코드 (ex KR, JP, US) |

- URL : 동영상의 URL을 저장한다.

| Field | DataType | Defalut | Attribute |
| --- | --- | --- | --- |
| medID | INT | not null | 빠른 검색
PRIMARY KEY
UNSIGNED
AUTO_INCREMENT |
| URL | TEXT | not null |  |

- medInfo : 동영상 내용 정보를 저장한다.

| Field | DataType | Defalut | Attribute |
| --- | --- | --- | --- |
| medID | INT | not null | 빠른 검색
PRIMARY KEY
UNSIGNED |
| title | VARCHAR(255) | not null | media의 제목 |
| category | INT | null | 장르 코드
UNSIGNED |

- quality : 동영상 파일 정보를 저장한다.

| Field | DataType | Defalut | Attribute |
| --- | --- | --- | --- |
| medID | INT | not null | 빠른 검색
PRIMARY KEY
UNSIGNED |
| resolution | SET | not null | ('360', '720', '1080', 1440', '2160')
 세로 픽셀 기준 |
| length | TIME | 00:00:00 | 영상 길이 |

- history : 이용자의 영상 시청 기록을 저장한다.

| Field | DataType | Defalut | Attribute |
| --- | --- | --- | --- |
| usrCode | INT | not null | 빠른 검색
COMPOSIT KEY
UNSIGNED
UNIQUE |
| medID | INT | not null | 빠른 검색
COMPOSIT KEY
UNSIGNED
UNIQUE |
| bufferingStart | TIME | 00:00:00 | 영상 시작 시간 |

### 3.3.2. Procedure

- 여러 Query 문을 하나로 실행시켜 효율적으로 정보를 요청하도록 돕고 외래키(Foreign key) 대신 Procedure로 정보의 무결성을 만족시켜 테이블간 관계가 복잡해지지 않도록 한다.
- JSON 형식으로 정보를 출력한다.
- 데이터베이스로 정보를 전달 시, 제대로 정보가 저장되었으면 JSON 형식으로 완료되었음을 알린다.
- 데이터베이스에 요청이 있을 시 , 관련 정보를 JSON 형식으로 전달한다.

| Name | Parameter | Return | Attribute | Form |
| --- | --- | --- | --- | --- |
| ADD_USER | (userID, password, mail) | JSON | user  테이블에 새로운 튜플을 추가한다.
password는 SHA-256 해시 함수를 이용하여 변경한 후 저장한다.
성공 시 true(1)을 검색한다.
잘못된 입력 또는 userID나 mail이 중복될 경우 false(0)를 검색한다. | {"success":BOOLEAN} |
| DEL_USER | (userCode) | JSON | user, profile, history 테이블에서 상응하는 유저 튜플을 제거한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| LOGIN | (userID, password) | JSON | userID와 password가 일치하면 userCode, 아니면 -1 검색한다.
password는 SHA-256 해시 함수를 이용하여 변경한 후  DB에 저장된 비밀번호와 비교한다. | {"userCode":INT} |
| GET_USERID | (mail) | JSON | 인증된 mail을 통해 ID를 확인한다. | {"userID":VARCHAR(45)} |
| SET_USERID | (userCode, userID) | JSON | userCode에 상응하는 유저의 userID를 변경한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| SET_MAIL | (userCode, mail) | JSON | userCode에 상응하는 유저의 mail을 변경한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| SET_PASSWORD | (userID, password) | JSON | userID에 상응하는 유저의 password를 변경한다.
별도의 본인 인증 절차 이후에 진행하기를 추천한다.
성공시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| SET_PROFILE | (userCode, nickname, userInfo, birthYear, nation) | JSON | profile 테이블에 새로운 튜플을 추가한다.
userCode에 상응하는 유저의 profile을 변경한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(1)를 검색한다. | {"success":BOOLEAN} |
| GET_PROFILE | (userCode) | JSON | userCode에 상응하는 유저의 profile을 검색한다. | {"nickname":VARCHAR(30),
"userInfor":SET('male', 'female'),
"birthYear":INT,
"nation":CHAR(2)} |
| ADD_MEDIA | (URL, title, category, resolution, length) | JSON | URL, medIno, quality 테이블에 새로운 튜플을 추가한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(0)을 검색한다. | {"success":BOOLEAN} |
| DEL_MEDIA | (medID) | JSON | URL, medInfo quality 테이블에서 상응하는 영상의 튜플을 제거한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| GET_URL | (medID) | JSON | 상응하는 medID의 URL을 검색한다. | {"URL":TEXT} |
| SEAR_CATEGORY | (category) | JSON | 특정 category의 media의 정보를 검색한다. | [{"medID":INT,
    "title":VARCHAR(255),
    "category":INT}, …] |
| SEAR_TITLE | (title) | JSON | 관련 title의 media 정보를 검색한다. | [{"medID":INT,
    "title":VARCHAR(255),
    "category":INT}, …] |
| SET_MEDIA | (medID, URL, title, category, resolution, length) | JSON | URL, medInfo, quality 테이블에서 상응하는 medID의 튜플을 변경한다.
성공 시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| GET_QUALITY | (medID) | JSON | medID에 상응하는 영상의 quality 검색한다. | {"resolution":SET('360',
  '720', '1080', 1440', '2160'),
"length":TIME} |
| DEL_HISTORY | (userID, medID) | JSON | history테이블에서 복합 키(userID, medID)에 상응하는 튜플을 제거한다. 
성공 시 true(1)을 검색하고 오류 발생 시 false(0)를 검색한다. | {"success":BOOLEAN} |
| GET_HISTORY | (userID) | JSON | history테이블에서 userID에 상응하는 튜플을 검색한다. | {"medID":INT,
 "bufferingStart":TIME} |
| RESET |  |  | 모든 데이터를 제거하고 시작 상태로 돌아간다. |  |