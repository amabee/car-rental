<?php
include "headers.php";

class User {
    //login
    function login($json){
        include "connection.php";

        $json = json_decode($json, true);

        $username = $json['username'];
        $password = $json['password']; 

        $sql = "SELECT accounts_id , accounts_complete_name, accounts_username, accounts_password FROM accounts WHERE accounts_username = :username AND accounts_password = :password";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(":username", $username);
        $stmt->bindParam(":password", $password);
        $stmt->execute();
        $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);
        unset($conn); unset($stmt);
        return json_encode($returnValue);
    }

    //register
    function register($json){
        include "connection.php";
        
        $json = json_decode($json, true);

        $username = $json['username'];
        $password = $json['password'];
        $fullname = $json['fullname'];

        $sql = "INSERT INTO accounts(accounts_complete_name, accounts_username, accounts_password) ";
        $sql .= "VALUES (:fullname, :username, :password) "; 
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(":username", $username);
        $stmt->bindParam(":password", $password);
        $stmt->bindParam(":fullname", $fullname);
        $stmt->execute();
        $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
        unset($conn); unset($stmt);
        return json_encode($returnValue);
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $operation = $_GET['operation'];
    $json = $_GET['json'];
} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $operation = $_POST['operation'];
    $json = $_POST['json'];
}

$user = new User();
switch ($operation) {
    case "login":
        echo $user->login($json);
        break;
    case "register":
        echo $user->register($json);
        break;
}
?>
