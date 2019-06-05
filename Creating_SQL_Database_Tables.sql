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
