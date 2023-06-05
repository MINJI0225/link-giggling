# Install node.js
https://nodejs.org/en/download

After installation, you can verify it by checking the version of Node.js and npm:
```
PS D:\Downloads\termproject\backend> node --version
v19.8.1
PS D:\Downloads\termproject\backend> npm --version
9.5.1
```

# Install MySQL

Restore the DB to local
```
mysql -u [사용자 계정] -p [패스워드] [복원할 DB] < [백업된 DB].sql
```


# Running the BACKEND server and FRONTEND React app

Install the dependency node modules first (Only required to do once).

Run the server
```
PS D:\Downloads\link-giggling\myapp> node server.js
```
