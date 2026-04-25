<?php 
header('Content-Type: application/json');

$host = getenv('MYSQL_HOST') ?: 'mariadb'; 
$user = getenv('MYSQL_USER') ?: 'kimchi'; 
$pass = getenv('MYSQL_PASSWORD') ?: 'haribo249A@'; 
$db   = getenv('MYSQL_DATABASE') ?: 'wordpress';
$mysqli = new mysqli($host, $user, $pass, $db);     #make MySQL tunnel to connect to mariadb.
if ($mysqli->connect_error)
{
    http_response_code(500); 
    echo json_encode([ "status" => "fail", "db" => "fail" ]); 
    exit;
}
echo json_encode([ "status" => "ok", "db" => "ok" ]);
?>