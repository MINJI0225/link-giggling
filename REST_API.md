# Media Contents Player Backend REST API

## 1. 이용자 관리

### 1.1 이용자 계정 추가하기
사용자에게 입력받은 값들로 이용자 계정을 backend 서버의 데이터베이스에 추가하는 API이다.

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userID | INT | 이용자 ID | TRUE |
| password | VARBINARY(64) | 해시 함수 처리 된 이용자 비밀번호 | TRUE |
| mail | VARCHAR(50) | 이용자 메일 | FALSE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| success | BOOLEAN | 데이터베이스에 해당 요청 성공 여부 |


### 1.2 이용자 계정, 프로필 및 시청 기록 제거하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userCode | INT | 이용자 고유 번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| success | BOOLEAN | 데이터베이스에 해당 요청 성공 여부 |


### 1.3 userCode 요청하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userID | INT | 이용자 ID | TRUE |
| password | VARBINARY(64) | 해시 함수 처리 된 이용자 비밀번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| userCode | INT | 이용자 고유 번호 |


### 1.4 이용자 프로필 요청하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userCode | INT | 이용자 고유 번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| nickname | VARCHAR(30) | 이용자 프로필 이름(닉네임) |
| usrInfo | SET | 이용자 정보(성별) |
| birthYear | INT | 이용자가 태어난 해 |
| nation | CHAR(2) | 이용 국가 코드 (ex KR, JP, US) |


## 2. 동영상 관리
### 2.1 동영상 주소, 내용 정보, 파일 정보 추가하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| URL | TEXT | 동영상 주소 | TRUE |
| title | VARCHAR(255) | 동영상 제목 | TRUE |
| category | INT | 동영상 카테고리(장르) | TRUE |
| resolution | SET | 동영상 해상도 | TRUE |
| length | TIME | 동영상 길이 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| success | BOOLEAN | 데이터베이스에 해당 요청 성공 여부 |


### 2.2 동영상 주소 요청하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| medID | INT | 동영상 고유 번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| URL | TEXT | 동영상 주소 |


### 2.2 동영상 파일 정보 요청하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| medID | INT | 동영상 고유 번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| resolution | SET | 동영상 해상도 |
| length | TIME | 동영상 길이 |


## 3. 시청 동영상 관리
### 3.1 동영상 시청 기록 요청하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /session-info/session-list | http://tvmedia.lge.com:5000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userID | INT | 이용자 고유 번호, 벡엔드에서 이용 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| medID | INT | 동영상 고유 번호 |
| bufferingStart | TIME | 시청하다 멈춘 시간 |
