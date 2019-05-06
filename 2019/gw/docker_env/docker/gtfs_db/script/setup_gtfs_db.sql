-- GTFSデータ格納用のDBを作成する。

-- 外部からの接続を許可する設定。
-- MySQL Workbench等からTCP/IP経由でDBに接続できるようにする。
CREATE USER 'gtfs'@'%' IDENTIFIED BY 'gtfs' ;

-- DBを作成
CREATE DATABASE gtfs_db CHARACTER SET UTF8 ;
CREATE DATABASE gtfs_db_reference CHARACTER SET UTF8 ;

GRANT ALL PRIVILEGES ON gtfs_db.* TO 'gtfs'@'%' ;
GRANT ALL PRIVILEGES ON gtfs_db_reference.* TO 'gtfs'@'%' ;


