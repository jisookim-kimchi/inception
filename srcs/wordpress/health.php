<?php 
header('Content-Type: application/json');

$host = "mariadb";                                  #address of Destination.
$user = getenv('MYSQL_USER'); 
$pass = getenv('MYSQL_PASSWORD'); 
$db = getenv('MYSQL_DATABASE');
$mysqli = new mysqli($host, $user, $pass, $db);     #make MySQL tunnel to connect to mariadb.
if ($mysqli->connect_error)
{
    http_response_code(500); 
    echo json_encode([ "status" => "fail", "db" => "fail" ]); 
    exit;
}
echo json_encode([ "status" => "ok", "db" => "ok" ]);
?>