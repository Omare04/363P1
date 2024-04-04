import csv
import mysql.connector
from datetime import datetime

# Connect to MySQL database
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Qweasdzxc@123',
    database='amazon_order_reviews'
)
cursor = conn.cursor()

# Open and read Orders.csv
with open('Orders.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        order_id = row['Order ID']
        date_str = row['Order Date']
        customer_id = row['Customer ID']
        price = row['Sales']
        
        # Convert date string to YYYY-MM-DD format
        date = datetime.strptime(date_str, '%m/%d/%Y').strftime('%Y-%m-%d')
        
        # Check if customer_id exists in the Customer table
        cursor.execute("SELECT customer_id FROM Customer WHERE customer_id = %s", (customer_id,))
        customer_result = cursor.fetchone()
        
        if customer_result:
            # Check if order_id already exists in Orders table
            cursor.execute("SELECT order_id FROM `Order` WHERE order_id = %s", (order_id,))
            result = cursor.fetchone()
            
            if not result:
                # If order_id does not exist, insert into Orders table
                cursor.execute("INSERT INTO `Order` (order_id, date, customer_id, price) VALUES (%s, %s, %s, %s)", (order_id, date, customer_id, price))

# Commit changes and close connection
conn.commit()
conn.close()
