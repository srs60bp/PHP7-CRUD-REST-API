/* You can also use an installer.php script which gets called one time to execute a SQL script 
** that creates a database and create the database tables.
**
** If you want to take this approach, create config/data/database.sql then copy the following code 
** plus the previous SQL CREATE statements to create the tables
*/
CREATE DATABASE mydb;

use mydb;

/* COPY THE PREVIOUS STATEMENTS HERE*/

CREATE TABLE `Product` (
  `id` int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
  `sku` varchar(255),
  `barcode` varchar(255),
  `name` varchar(100),
  `price` float,
  `unit` varchar(20),
  `quantity` float,
  `minquantity` float,
  `createdAt` datetime NOT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `familyid` int(11) NOT NULL,
  `locationid` int(11) NOT NULL
);

CREATE TABLE `Family` (
  `id` int(11)  UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
  `reference` varchar(50),
  `name` varchar(100),
  `createdAt` datetime NOT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `Transaction` (
  `id` int(11)  UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
  `comment` text,
  `price` float,
  `quantity` float,
  `reason` enum('New Stock','Usable Return','Unusable Return'),
  `createdAt` datetime NOT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `productid` int(11) NOT NULL
);

CREATE TABLE `Location` (
  `id` int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
  `reference` varchar(50),
  `description` text,
  `createdAt` datetime NOT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
