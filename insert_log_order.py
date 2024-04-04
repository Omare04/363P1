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

# Open and read data from orders.csv file
with open('orders.csv', 'r') as file:
    reader = csv.reader(file)
    next(reader)  # Skip header row
    customer_orders = {}  # Dictionary to store customer orders count

    # Iterate over each row in the CSV file
    for row in reader:
        customer_id = row[0]  # Assuming customer_id is the first column
        # Increment total orders placed count for the customer
        customer_orders[customer_id] = customer_orders.get(customer_id, 0) + 1

# Insert data into the Log table
for customer_id, total_orders_placed in customer_orders.items():
    try:
        cursor.execute("INSERT INTO Log_order (customer_id, total_orders_placed) VALUES (%s, %s)", (customer_id, total_orders_placed))
        conn.commit()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# Close database connection
cursor.close()
conn.close()