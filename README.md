# PHP7-CRUD-REST-API
PHP 7 Tutorial with MySQL: CRUD REST API
This tutorial aims to give you an in-depth introduction to PHP (PHP 7 version) by building a simple CRUD REST API.

    Also read: How to implement JWT authentication and access the Authorization header in PHP

You'll also learn about important concepts such as CRUD operations and PHP PDOs etc.

In this PHP 7 tutorial, we're going to learn by example how to create a REST API with PHP 7 and MySQL. We'll see example implementations for HTTP GET and HTTP POST methods and we'll use json_encode() to return data in JSON format.

The REST API, we'll be creating in this tutorial, will be the basis of the next tutorials for adding JWT-based authentication and building your front-ends with modern JavaScript/TypeScript frameworks and libraries such as Angular, React.js and Vue.js etc.

In this tutorial we'll create an example CRUD (Create, Read, Update and Delete) PHP application that implements the equivalent HTTP API methods i.e GET, POST, PUT and DELETE.

PHP and MySQL REST API Tutorial: Create a RESTful API (HTTP POST and GET Examples) Step by Step

    What is an API?
    What is REST API?
    MySQL Database
    Design with Entity-Relationship Diagram
    Creating SQL Database Tables
    PHP 7 REST Project File Structure
    Connecting to A MySQL Database in PHP 7
    What is PHP PDO?
    The PHP Product Class
    The PHP Transaction Class
    The PHP Family Class
    The PHP Location Class
    Creating the PHP API Endpoints
    HTTP GET API Example: Implementing products/read.php
    HTTP POST API Example: Implementing product/create.php
    Conclusion

Throughout the tutorial we'll create a simple API (but in the same time it's a real-world API. In fact you can use it to build a small stock tracking app) with the most straightforward and simplest architecture (and file structure) i.e we are not going to cover advanced concepts such as MVC, routing or template languages (we will use PHP 7 itself as the template language. I know it's a bad practice but this is how you do things when you first get started using PHP 7 also if you are looking for these concepts you better use a PHP framework, most of them are built around these advanced concepts) so this tutorial can be as beginners-friendly as possible. 

For the database you'll use MySQL, the most pouplar database for PHP applications.

CRUD stands for Create, Read, Update and Delete and it refers to a set of operations that are common in most data-driven web applications in which you need to access a database to create and manipulate data.

    Also read PHP Image/File Upload Tutorial and Example [FormData and Angular 7 Front-End]

What is an API?

API stands for Application Programming Interface . It's an interface that allows applications to communicate with each other. In case of the web it refers to the interface (a set of URLs that allows you to exchange data with a web application via a set of operations commonly known as CRUD - -Create, Read, Update and Delete operations by sending HTTP requests such as POST, GET, PUT and DELETE etc. 

What is REST API?

REST stands for REpresentational State Transfer". It's a set of rules that define how to exchange resources in a distributed system such as stateleness i.e the server doesn't keep any information about the previous requests which means the current request should include every information the server needs for fulfilling the desired operation. Data is usually exchanged in JSON (JavaScript Object Notation) format.

So REST API refers to the interface that allows mobile devices and web browsers (or also other web servers) to create, read, update and delete resources in the server respecting the REST rules (such as being stateless).

Using REST you can build one back-end and then build different client apps or front-ends for web browsers and mobile devices (iOS and Android etc.) because the back-end is decoupled from the front-end--the communication between the client and the server apps takes place via the REST interface. You can offer your users another app or you can build more apps to support the other mobile platforms without touching the back-end code.
MySQL Database Design with Entity-Relationship Diagram

In order to build a web API, you need a way to store data, behind the scene, in your server's database. For this tutorial we'll use MySQL RDMS (Relational Database Management System) which is the most used database system in the PHP world.

The first step is to design our database so we'll use the Entity-Relationship Diagram

An entity relationship diagram, or also an entity-relationship model, is a graphical representation of entities and how they relate to each other. They are used to model relational databases. In ER diagrams you use entities (boxes) to represent real world concepts or objects and relationships (arrows) to represent a relation between two entities.

There are three types of relationships: One-to-One, One-to-Many and Many-to-Many.

Here is a screenshot of an example ER model for our database

PHP 7 MySQL database design

We have four entities that are related with each other: A product has a family, belongs to a location and can have many related transactions.

After creating an ER model you can easily write SQL CREATE statements to create the SQL tables in the MySQL database. You can simply map each entity to a SQL table and relationships to foreign keys.

    Any decent ER diagramming tool will include an export button that can help you generate the SQL script from your ER model without having to write it manually.

Creating SQL Database Tables

Now let's create SQL for our database

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

    You can PhpMyAdmin or the MySQL CLI-based client to create a new database then copy and run the previous SQL queries to create the new tables.

You can also use an installer.php script which gets called one time to execute a SQL script that creates a database and create the database tables.

If you want to take this approach, create config/data/database.sql then copy the following code plus the previous SQL CREATE statements to create the tables

CREATE DATABASE mydb;

use mydb;

/* COPY THE PREVIOUS STATEMENTS HERE*/

Now we need to execute this script from PHP 7. So go ahead and create a file config/install.php then copy the following code:

include_once './dbclass.php';
try 
{
  $dbclass = new DBClass(); 
  $connection = $dbclass.getConnection();
  $sql = file_get_contents("data/database.sql"); 
  $connection->exec($sql);
  echo "Database and tables created successfully!";
}
catch(PDOException $e)
{
    echo $e->getMessage();
}

We’ll be placing the contents of the config/data/database.sql file into a variable using the filegetcontents() function, and executing it with the exec() function.

You can see the implementation of the DBClass below.
PHP 7 REST Project File Structure

Our API project's file structure will be simple. We'll use a config folder for storing the configuration file(s), an entities folder for storing PHP classes that encapsulate the entities used by our API i.e products, locations, families and transactions.
Connecting to A MySQL Database in PHP

Inside the the config folder add a dbclass.php file that contains the following code to connect your API back-end to the underlying MySQL database.

<?php
class DBClass {

    private $host = "localhost";
    private $username = "root";
    private $password = "<YOUR_DB_PASSWORD>";
    private $database = "<YOUR_DB_NAME>";

    public $connection;

    // get the database connection
    public function getConnection(){

        $this->connection = null;

        try{
            $this->connection = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->database, $this->username, $this->password);
            $this->connection->exec("set names utf8");
        }catch(PDOException $exception){
            echo "Error: " . $exception->getMessage();
        }

        return $this->connection;
    }
}
?>

What is PHP PDO?

    The PHP Data Objects (PDO) extension defines a lightweight, consistent interface for accessing databases in PHP. Each database driver that implements the PDO interface can expose database-specific features as regular extension functions. Note that you cannot perform any database functions using the PDO extension by itself; you must use a database-specific PDO driver to access a database server. Source.

The PDO object will ask for four parameters:

DSN (data source name), which includes type of database, host name, database name (optional) Username to connect to host Password to connect to host Additional options

Next we'll create the PHP classes that encapsulate the entities (or database tables). Each class will contain a hard-coded string storing the name of the corresponding SQL table, a member variable that will be holding an instance of the Connection class which will be passed via the class constructor and other fields mapping to the table columns. Each entity class will also encapsulate the CRUD operations needed for creating, reading, updating and deleting the corresponding table rows.
The PHP Product Class

<?php
class Product{

    // Connection instance
    private $connection;

    // table name
    private $table_name = "Product";

    // table columns
    public $id;
    public $sku;
    public $barcode;
    public $name;
    public $price;
    public $unit;
    public $quantity;
    public $minquantity;
    public $createdAt; 
    public $updatedAt;
    public $family_id;
    public $location_id;

    public function __construct($connection){
        $this->connection = $connection;
    }

    //C
    public function create(){
    }
    //R
    public function read(){
        $query = "SELECT c.name as family_name, p.id, p.sku, p.barcode, p.name, p.price, p.unit, p.quantity , p.minquantity, p.createdAt, p.updatedAt FROM" . $this->table_name . " p LEFT JOIN Family c ON p.family_id = c.id ORDER BY p.createdAt DESC";

        $stmt = $this->connection->prepare($query);

        $stmt->execute();

        return $stmt;
    }
    //U
    public function update(){}
    //D
    public function delete(){}
}

The PHP Transaction Class

<?php
class Transaction{

    // Connection instance
    private $connection;

    // table name
    private $table_name = "Transaction";

    // table columns
    public $id;
    public $comment;
    public $price;
    public $quantity;
    public $reason;
    public $createdAt; 
    public $updatedAt;
    public $product_id;

    public function __construct($connection){
        $this->connection = $connection;
    }
    //C
    public function create(){}
    //R
    public function read(){}
    //U
    public function update(){}
    //D
    public function delete(){}    
}

The PHP Family Class

<?php
class Family{

    // Connection instance
    private $connection;

    // table name
    private $table_name = "Family";

    // table columns
    public $id;
    public $reference;
    public $name;
    public $createdAt; 
    public $updatedAt;

    public function __construct($connection){
        $this->connection = $connection;
    }
    //C
    public function create(){}
    //R
    public function read(){}
    //U
    public function update(){}
    //D
    public function delete(){}    
}

The PHP Location Class

<?php
class Location{

    // Connection instance
    private $connection;

    // table name
    private $table_name = "Location";

    // table columns
    public $id;
    public $reference;
    public $description;
    public $createdAt; 
    public $updatedAt;

    public function __construct($connection){
        $this->connection = $connection;
    }
    //C
    public function create(){}
    //R
    public function read(){}
    //U
    public function update(){}
    //D
    public function delete(){}    
}

Creating the PHP API Endpoints

We have four entities that we want to CRUD with our API so create four folders products, transactions, families and locations and then in each folder create create.php, read.php, update.php, delete.php.
HTTP GET API Example: Implementing products/read.php

HTTP POST API Example: Implementing product/create.php Open the products/read.php file then add the following code:

header("Content-Type: application/json; charset=UTF-8");

include_once '../config/dbclass.php';
include_once '../entities/product.php';

$dbclass = new DBClass();
$connection = $dbclass->getConnection();

$product = new Product($connection);

$stmt = $product->read();
$count = $stmt->rowCount();

if($count > 0){


    $products = array();
    $products["body"] = array();
    $products["count"] = $count;

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){

        extract($row);

        $p  = array(
              "id" => $id,
              "sku" => $sku,
              "barcode" => $barcode,
              "name" => $name,
              "price" => $price,
              "unit" => $unit,
              "quantity" => $quantity,
              "minquantity" => $minquantity,
              "createdAt" => $createdAt,
              "createdAt" => $createdAt,
              "updatedAt" => $updatedAt,
              "family_id" => $family_id,
              "location_id" => $location_id
        );

        array_push($products["body"], $p);
    }

    echo json_encode($products);
}

else {

    echo json_encode(
        array("body" => array(), "count" => 0);
    );
}
?>

HTTP POST API Example: Implementing product/create.php

<?php

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/dbclass.php';

include_once '../entities/product.php';

$dbclass = new DBClass();
$connection = $dbclass->getConnection();

$product = new Product($connection);

$data = json_decode(file_get_contents("php://input"));

$product->name = $data->name;
$product->price = $data->price;
$product->description = $data->description;
$product->category_id = $data->category_id;
$product->created = date('Y-m-d H:i:s');

if($product->create()){
    echo '{';
        echo '"message": "Product was created."';
    echo '}';
}
else{
    echo '{';
        echo '"message": "Unable to create product."';
    echo '}';
}
?>

Conclusion

In this PHP 7 tutorial:

    We've built a CRUD RESTful API with PHP and MySQL.
    We've also used the Entity-Relationship diagram to design our MySQL database.
    We've used PHP functions like json_encode() to create an API in JSON.
