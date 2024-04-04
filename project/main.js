import express from "express";
import mysql from "mysql2";

const PORT = 3000;
const dbport = 3301;
const dbhost = "localhost";
const dbname = "SOEN363Project1";
const dbuser = "root";
const dbpass = "";

const app = express();

export const dbPool = mysql.createPool({
  host: dbhost,
  port: dbport,
  user: dbuser,
  database: dbname,
  password: dbpass,
});

app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});

app.get("/", function (req, res) {
  res.send("heelloo");
});

app.get("/add", function (req, res) {

  dbPool.query('SELECT * FROM Admin', function (error, results, fields) {
    if (error) {
      console.error('Error executing test query:', error);
      res.status(500).send('Internal Server Error');
    } else {
      console.log('Result of test query:', results[0]);
      res.send('Test query executed successfully!');
    }
  });
});