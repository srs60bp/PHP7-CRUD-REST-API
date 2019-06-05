// The PHP Family Class
//
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
