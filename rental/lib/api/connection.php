<?php
 header('Content-Type: application/json');
 header("Access-Control-Allow-Origin: *");
 
 $host = 'localhost';
 $dbusername = 'root';
 $dbpassword = '';
 $dbname = 'rental';

  try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $dbusername, $dbpassword);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Connection Successful!";
  } catch(PDOException $e) {
    die("Error: " . $e->getMessage());
  }
?>