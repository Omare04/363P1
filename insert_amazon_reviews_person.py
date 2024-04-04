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

# Set to store seen user_id values
seen_user_ids = set()

# Open and read amazon.csv
with open('amazon.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    
    for row in reader:
        # Split user_id and user_name by commas if they contain multiple values
        user_ids = row['user_id'].split(',')
        user_names = row['user_name'].split(',')
        
        for user_id, user_name in zip(user_ids, user_names):
            # Check if id exists in Person table
            cursor.execute("SELECT id FROM Person WHERE TRIM(id) = %s", (user_id.strip(),))
            result = cursor.fetchone()
            if not result:
                cursor.execute("INSERT INTO Person (id, name) VALUES (%s, %s)",
                               (user_id.strip(), user_name.strip()))  # Strip whitespace
                # Add user_id to seen set
                seen_user_ids.add(user_id.strip())

# Commit changes and close connection
conn.commit()
conn.close()
