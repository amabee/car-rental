<?php
    include "headers.php";

    class Contacts  {
        function getCars($json){
            include "connection.php";
            $json = json_decode($json, true);
            
            $sql = "SELECT 
            *
            FROM cars
            ORDER BY car_model";
            $stmt = $conn->prepare($sql);
            $stmt->execute();
            $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

            return json_encode($returnValue);
        }
        function getContacts($json){
            include "connection.php";
            $json = json_decode($json, true);
            
            $sql = "SELECT 
            *
            FROM cars
            WHERE accountId = :accountId
            ORDER BY car_model";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(":accountId", $json['accountId']);
            $stmt->execute();
            $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

            return json_encode($returnValue);
        }
        function addContacts($json){
            include "connection.php";
            $json = json_decode($json, true);
            $image = "";

            $sql = "INSERT INTO cars(accountId , car_model, car_description, car_price, car_image) ";
            $sql .= "VALUES (:accountId, :model, :description, :price, :image) ";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(":accountId", $json['accountId']);
            $stmt->bindParam(":model", $json['model']);
            $stmt->bindParam(":description", $json['description']);
            $stmt->bindParam(":price", $json['price']);
            $stmt->bindParam(":image", $image);

            $stmt->execute();
            $returnValue = $stmt->rowCount() > 0 ? 1 : 0;
            unset($conn); unset($stmt);
            return json_encode($returnValue);
        }
        function search($json){
            include "connection.php";
            $json = json_decode($json, true);

            $searchKey = "%".$json['searchKey']."%";
            $sql = "SELECT 
            *
            FROM cars
            WHERE car_model LIKE :searchKey AND accountId = :accountId
            ORDER BY car_model";
            $stmt = $conn->prepare($sql);
            $stmt ->bindParam("searchKey", $searchKey);
            $stmt ->bindParam("accountId", $json['accountId']);
            $stmt->execute();
            $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode($returnValue);
        }
        function update($json){
            include "connection.php";
            $json = json_decode($json, true);

            $sql = "UPDATE cars
            SET car_model = :model, car_description = :description,
            car_price = :price
            WHERE car_id  = :id";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam("id", $json['id']);
            $stmt->bindParam("model", $json['model']);
            $stmt->bindParam("description", $json['description']);
            $stmt->bindParam("price", $json['price']);
            $stmt->execute();
            $returnValue = $stmt-> rowCount() > 0 ? 1 : 0;

            return json_encode($returnValue);
        }
        function delete($json){
            include "connection.php";
            $json = json_decode($json, true);

            $sql = "DELETE FROM cars
                WHERE car_id  = :id
            ";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam("id", $json['id']);
            $stmt->execute();
            $returnValue = $stmt-> rowCount() > 0 ? 1 : 0;

            return json_encode($returnValue);
        }
        
        function uploadImage($json){
            include 'connection.php';
            $jsonData = json_decode($json, true);

            $carId = $jsonData['carId'];
            $imageData = $jsonData['file'];

            $imageDataDecode = base64_decode($imageData);

            $targetDir = '../images/';

            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mime = $finfo->buffer($imageDataDecode);

            $extentions = [
                'image/jpeg' => '.jpg',
                'image/png' => '.png',
                'image/gif' => '.gif',
                'image/webp' => '.webp',
                'image/bmp' => '.bmp',
            ];

            $extention = isset($extentions[$mime]) ? $extentions[$mime] : '.jpg';

            $filename = $carId . $extention;

            $targetFile = $targetDir .$filename;

            if(file_put_contents($targetFile, $imageDataDecode)){
                $sql = "UPDATE cars SET car_image = :contactImage WHERE car_id  = :carId";
                $stmt = $conn->prepare($sql);
                $stmt ->bindParam(":contactImage", $filename);
                $stmt ->bindParam(":carId", $carId);
                $stmt->execute();
                $returnValue = 'Image upload successfully.';
            }else{
                $returnValue = 'Failed to upload image.';
            }
            return $returnValue;
        }
        function uploadCarImage($json) {
            include 'connection.php';
            $jsonData = json_decode($json, true);
        
            $carId = $jsonData['carId'];
            $imageData = $jsonData['files'];
        
            $imageDataDecode = base64_decode($imageData);
        
            $targetDir = '../cars_images/';
        
            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mime = $finfo->buffer($imageDataDecode);
        
            $extentions = [
                'image/jpeg' => '.jpg',
                'image/png' => '.png',
                'image/gif' => '.gif',
                'image/webp' => '.webp',
                'image/bmp' => '.bmp',
            ];
        
            $extention = isset($extentions[$mime]) ? $extentions[$mime] : '.jpg';
        
            // Generate a unique filename
            $filename = $carId . '_' . uniqid() . $extention;
        
            $targetFile = $targetDir . $filename;
        
            if (file_put_contents($targetFile, $imageDataDecode)) {
                $sql = "INSERT INTO cars_image(carsId, cars_image) VALUES (:carId, :cars_image)";
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(":cars_image", $filename);
                $stmt->bindParam(":carId", $carId);
                $stmt->execute();
                $returnValue = 'Image upload successfully.';
            } else {
                $returnValue = 'Failed to upload image.';
            }
            return $returnValue;
        }
        function getImages($json){
            include "connection.php";
            $json = json_decode($json, true);
            
            $sql = "SELECT 
            *
            FROM cars_image
            WHERE carsId = :carsId
            ORDER BY car_image_id";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(":carsId", $json['carsId']);
            $stmt->execute();
            $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

            return json_encode($returnValue);
        }
        
        
    }
    if($_SERVER['REQUEST_METHOD'] == 'GET'){
        $operation = $_GET['operation'];
        $json = $_GET['json'];
    }else if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $operation = $_POST['operation'];
        $json = $_POST['json'];
    }
    $contacts = new Contacts();
    switch($operation){
        case "getCar":
            echo $contacts->getCars($json);
            break;
        case "getContact":
            echo $contacts->getContacts($json);
            break;
        case "addContacts":
            echo $contacts->addContacts($json);
            break;
        case "search":
            echo $contacts->search($json);
            break;
        case "update":
            echo $contacts->update($json);
            break;
        case "delete":
            echo $contacts->delete($json);
            break;
        case "uploadImage":
            echo $contacts->uploadImage($json);
            break;
        case "uploadCarImage":
            echo $contacts->uploadCarImage($json);
            break;
        case "getImages":
            echo $contacts->getImages($json);
            break;
    }
?>