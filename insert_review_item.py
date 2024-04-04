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
        # Extract data from CSV
        product_id = row['product_id']
        actual_price = row['actual_price'].replace('₹', '').replace(',', '')  # Remove '₹' symbol and commas
        reviewer_ids = row['user_id'].split(',')

        # Check if product_id exists in item table
        for reviewer_id in reviewer_ids:
            reviewer_id = reviewer_id.strip()  # Strip whitespace
            cursor.execute("SELECT reviewers_id FROM reviewers WHERE reviewers_id = %s", (reviewer_id,))
            reviewer_result = cursor.fetchone()
            if reviewer_result:
                # Check if reviewer_id exists in reviewers table
                cursor.execute("SELECT item_id FROM item WHERE item_id = %s", (product_id,))
                item_result = cursor.fetchone()
                if item_result:
                    # Insert data into review_item table
                    cursor.execute("INSERT INTO review_item (item_id, unit_price, reviewer_id) VALUES (%s, %s, %s)",
                                   (product_id, actual_price, reviewer_id))

# Commit changes and close connection
conn.commit()
conn.close()
