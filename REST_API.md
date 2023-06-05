# Media Contents Player Backend REST API

## 1. 이용자 관리

### 1.1 이용자 계정 추가하기
사용자에게 입력받은 값들로 이용자 계정을 backend 서버의 데이터베이스에 추가하는 API이다.

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-1 | /signin | http://localhost:3000 | POST   |

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userID | VARCHAR(45) | 이용자 ID | TRUE |
| password | VARBINARY(64) | 해시 함수 처리 된 이용자 비밀번호 | TRUE |
| password2 | VARBINARY(64) | 해시 함수 처리 된 이용자 비밀번호 확인용 | TRUE |
| mail | VARCHAR(50) | 이용자 메일 | FALSE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| success | BOOLEAN | 데이터베이스에 해당 요청 성공 여부 |


### 1.2 로그인

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-2 | /login | http://localhost:3000 | POST    |

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| userID | VARCHAR(45) | 이용자 ID | TRUE |
| password | VARBINARY(64) | 해시 함수 처리 된 이용자 비밀번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| success | BOOLEAN | 데이터베이스에 해당 요청 성공 여부 |


### 1.3 로그아웃

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA01-3 | /logout | http://localhost:3000 | GET    |
<!-- 수정필요 -->

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |


## 2. 동영상 관리
### 2.1 동영상 검색하기

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA02-1 | /search | http://localhost:3000 | POST    |

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| title | VARCHAR(255) | 동영상 제목 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| URL | TEXT | 동영상 주소 |
| title | VARCHAR(255) | 동영상 제목 |
| category | INT | 동영상 카테고리(장르) |
| medID | INT | 동영상 고유번호 |


### 2.2 카테고리 해당 동영상 요청

#### Request
| ID     | URL                        | HOST                        | METHOD |
| ------ | -------------------------- | --------------------------- | ------ |
| BA02-2 | /category | http://localhost:3000 | POST    |

#### Parameter
| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| category | INT | 동영상 장르 고유번호 | TRUE |

#### Response
| Name | Type | Description |
| ---- | ---- | ----------- |
| URL | TEXT | 동영상 주소 |
| title | VARCHAR(255) | 동영상 제목 |
| category | INT | 동영상 카테고리(장르) |
| medID | INT | 동영상 고유번호 |
