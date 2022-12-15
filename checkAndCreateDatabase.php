<?php
if (isset($_SERVER['HOTCRP_SHORT_NAME']) && isset($_SERVER['MYSQL_HOST'])) {
    // Try to connect to the database
    try {
        $mysqli = new mysqli($_SERVER['MYSQL_HOST'], 'root', $_SERVER['MYSQL_ROOT_PASSWORD'], $_SERVER['HOTCRP_SHORT_NAME'], $_SERVER['MYSQL_PORT'] ? $_SERVER['MYSQL_PORT'] : 3306);
        $mysqli->close();
    } catch (Exception $e) {
        //Create the database
        $mysqli = new mysqli($_SERVER['MYSQL_HOST'], 'root', $_SERVER['MYSQL_ROOT_PASSWORD'], null, $_SERVER['MYSQL_PORT'] ? $_SERVER['MYSQL_PORT'] : 3306);
        $mysqli->query("CREATE DATABASE IF NOT EXISTS " . $_SERVER['HOTCRP_SHORT_NAME']);
        $mysqli->query("use " . $_SERVER['HOTCRP_SHORT_NAME']);
        $schema = file_get_contents("/var/www/html/src/schema.sql");
        $mysqli->multi_query($schema);
        $mysqli->close();
    }
}
