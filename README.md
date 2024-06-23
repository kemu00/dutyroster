javaのインストール
java21

任意のディレクトリで下記を実行
yum install https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.rpm

tomcatのインストール
tomcat10

curl -O http://ftp.riken.jp/net/apache/tomcat/tomcat-10/v10.1.25/bin/apache-tomcat-10.1.25.tar.gz
 tar zxvf apache-tomcat-10.1.25.tar.gz

mySQLのインストール
mySQL8.0

yum localinstall https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
yum -y install mysql-community-server

systemctl start mysqld
cat /var/log/mysqld.log | grep root

mysql -uroot -p

LTER USER 'root'@'localhost' IDENTIFIED BY 'Newpassword';

root
P@ssw0rd
aC%CE:s-m1Ht

SQL

create database dutyroster;
use dutyroster;

CREATE TABLE users
(id INT NOT NULL AUTO_INCREMENT, name TEXT, PRIMARY KEY (id));

INSERT INTO users (name) VALUES ('staff1');
