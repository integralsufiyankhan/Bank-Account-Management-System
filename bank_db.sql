/*
SQLyog Ultimate v8.82 
MySQL - 5.1.45-community : Database - bank_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bank_db` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `bank_db`;

/*Table structure for table `accounts` */

DROP TABLE IF EXISTS `accounts`;

CREATE TABLE `accounts` (
  `account_no` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `account_type` varchar(20) DEFAULT 'Savings',
  `balance` decimal(10,0) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_no`),
  KEY `FK_accounts` (`user_id`),
  CONSTRAINT `FK_accounts` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `accounts` */

insert  into `accounts`(`account_no`,`user_id`,`account_type`,`balance`,`created_at`) values (1,1,'Savings','0','2026-10-17 00:24:45'),(2,2,'Savings','100000','2026-10-17 00:47:18'),(3,3,'Savings','0','2026-10-17 01:31:49'),(4,4,'Savings','0','2026-10-17 01:34:16'),(5,5,'Savings','0','2026-10-17 01:38:16');

/*Table structure for table `transactions` */

DROP TABLE IF EXISTS `transactions`;

CREATE TABLE `transactions` (
  `txn_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_no` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) NOT NULL,
  `description` varchar(255) DEFAULT 'Transaction',
  `txn_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`txn_id`),
  KEY `FK_transactions` (`account_no`),
  CONSTRAINT `FK_transactions` FOREIGN KEY (`account_no`) REFERENCES `accounts` (`account_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

/*Data for the table `transactions` */

insert  into `transactions`(`txn_id`,`account_no`,`type`,`amount`,`balance_after`,`description`,`txn_date`) values (1,1,'DEPOSIT','5000.00','5000.00','Cash Deposit','2026-10-17 00:29:55'),(2,1,'WITHDRAW','200.00','4800.00','Cash Withdrawal','2026-10-17 00:31:16'),(3,1,'WITHDRAW','4000.00','800.00','Cash Withdrawal','2026-10-17 00:32:02'),(4,1,'WITHDRAW','200.00','600.00','Cash Withdrawal','2026-10-17 00:36:56'),(5,1,'WITHDRAW','200.00','400.00','Cash Withdrawal','2026-10-17 00:40:51'),(6,1,'WITHDRAW','200.00','200.00','Cash Withdrawal','2026-10-17 00:45:09'),(7,1,'WITHDRAW','200.00','0.00','Cash Withdrawal','2026-10-17 00:45:18'),(8,2,'DEPOSIT','100000.00','100000.00','Cash Deposit','2026-10-17 00:51:40');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `photo` varchar(255) NOT NULL DEFAULT 'avtar.png',
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `users` */

insert  into `users`(`id`,`photo`,`name`,`email`,`password`,`phone`,`created_at`) values (1,'avtar.png','Sufiyan Khan','khansufiyan@gmail.com','123456','9120603389','2026-10-17 00:24:45'),(2,'avtar.png','Kapil','khan@1234gmail.com','kapil@123','7309028858','2026-10-17 00:47:18'),(3,'_1792180909028.jpeg','sufiyan','khan@134gmail.com','123456','7309028858','2026-10-17 01:31:49'),(4,'_1792181056802.jpg','Prince','khan@124gmail.com','kapil@123','7309028858','2026-10-17 01:34:16'),(5,'_1792181296243.jpg','aaaaa','khan@123gmail.com','kapil@123','7309028858','2026-10-17 01:38:16');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
