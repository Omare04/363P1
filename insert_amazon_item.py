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

# Set to store seen product_id values
seen_product_ids = set()

# Open and read amazon.csv
with open('amazon.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        item_id = row['product_id']
        item_name = row['product_name']
        item_quantity = 1
        # Check if item_id already exists in Item table
        cursor.execute("SELECT item_id FROM Item WHERE item_id = %s", (item_id,))
        result = cursor.fetchone()
        if not result:
            # Insert data into Item table
            cursor.execute("INSERT INTO Item (item_id, item_name, item_quantity) VALUES (%s, %s, %s)",
                           (item_id, item_name, item_quantity))
            # Add product_id to seen set
            seen_product_ids.add(item_id)

# Commit changes and close connection
conn.commit()
conn.close()
