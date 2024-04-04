import csv
import mysql.connector

# Connect to MySQL database
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Qweasdzxc@123',
    database='amazon_order_reviews'
)
cursor = conn.cursor()

# Open and read User.csv
with open('Users_csv.csv', newline='',encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Check if id exists in Person table
        cursor.execute("SELECT id FROM Person WHERE id = %s", (row['Id'],))
        result = cursor.fetchone()
        if not result:
            # If id does not exist, insert into Person table
            cursor.execute("INSERT INTO Person (id, name) VALUES (%s, %s)",
                           (row['Id'], row['ProfileName']))

# Open and read Orders.csv
with open('Orders.csv', newline='',encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Check if id exists in Person table
        cursor.execute("SELECT id FROM Person WHERE id = %s", (row['Customer ID'],))
        result = cursor.fetchone()
        if not result:
            # If id does not exist, insert into Person table
            cursor.execute("INSERT INTO Person (id, name) VALUES (%s, %s)",
                           (row['Customer ID'], row['Customer Name']))

# Commit changes and close connection
conn.commit()
conn.close()
