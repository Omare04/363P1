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

# Open and read Orders.csv
with open('Orders.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        customer_id = row['Customer ID']
        
        # Check if customer_id exists in the Person table
        cursor.execute("SELECT id FROM Person WHERE id = %s", (customer_id,))
        person_result = cursor.fetchone()
        
        if person_result:
            # Check if customer_id already exists in Customers table
            cursor.execute("SELECT customer_id FROM Customer WHERE customer_id = %s", (customer_id,))
            result = cursor.fetchone()
            if not result:
                # If customer_id does not exist, insert into Customers table
                cursor.execute("INSERT INTO Customer (customer_id, person_id) VALUES (%s, %s)", (customer_id, customer_id))
        else:
            print(f"User with ID {customer_id} not found in the Person table.")

# Commit changes and close connection
conn.commit()
conn.close()
