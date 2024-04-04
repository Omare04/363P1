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

# Open and read data from amazon.csv file
with open('amazon.csv', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    item_reviews = {}  # Dictionary to store item reviews count

    # Iterate over each row in the CSV file
    for row in reader:
        item_id = row['product_id']  # Assuming product_id is the column name
        user_ids = row['user_id'].split(',')  # Split user_ids by comma
        num_reviews = len(user_ids)  # Count the number of user_ids

        # Increment the number of reviews for the item
        if item_id in item_reviews:
            item_reviews[item_id] += num_reviews
        else:
            item_reviews[item_id] = num_reviews

# Insert data into the Log_Review table
for item_id, num_reviews in item_reviews.items():
    try:
        cursor.execute("INSERT INTO Log_Review (item_id, num_reviews) VALUES (%s, %s)", (item_id, num_reviews))
        conn.commit()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# Close database connection
cursor.close()
conn.close()