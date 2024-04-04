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

# Open and read amazon.csv
with open('amazon.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Split user_id column at ','
        user_ids = row['user_id'].split(',')
        for user_id in user_ids:
            user_id = user_id.strip()  # Remove whitespace
            # Check if user_id exists in Person table
            cursor.execute("SELECT id FROM Person WHERE id = %s", (user_id,))
            person_result = cursor.fetchone()
            if person_result:
                # Check if customer_id already exists in Customer table
                cursor.execute("SELECT customer_id FROM Customer WHERE customer_id = %s", (user_id,))
                result = cursor.fetchone()
                if not result:
                    # If customer_id does not exist, insert into Customer table
                    cursor.execute("INSERT INTO Customer (customer_id, person_id) VALUES (%s, %s)", (user_id, user_id))

# Commit changes and close connection
conn.commit()
conn.close()
