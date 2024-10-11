ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin1234';
SELECT user, host, plugin FROM mysql.user;