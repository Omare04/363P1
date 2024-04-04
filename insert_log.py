import csv
import mysql.connector

# Connect to the MySQL database
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Qweasdzxc@123',
    database='amazon_order_reviews'
)

# Create a cursor object to execute SQL queries
cursor = conn.cursor()

# Open the CSV file and read data
with open('companies.csv', 'r', newline='', encoding='utf-8-sig') as file:  # 'utf-8-sig' is used to handle the BOM character
    csv_reader = csv.DictReader(file, fieldnames=['rank', 'profile', 'name', 'url', 'state', 'revenue', 'growth_%', 'industry', 'workers', 'previous_workers', 'founded', 'yrs_on_list', 'metro', 'city'])
    next(csv_reader)  # skip header row
    for row in csv_reader:
        # Replace empty strings with 0 for the workers column
        workers = row['workers'] if row['workers'].strip() != '' else '0'
        # Check if the company_id already exists in the log table
        cursor.execute("SELECT COUNT(*) FROM log WHERE company_id = %s", (row['rank'],))
        result = cursor.fetchone()[0]
        if result == 0:  # If the company_id does not exist, insert the data
            cursor.execute("INSERT INTO `log` (company_id, growth_percent, previous_workers, founded, workers, industry, revenue)  VALUES (%s, %s, %s, %s, %s, %s, %s)", (row['rank'], row['growth_%'], row['previous_workers'], row['founded'], workers, row['industry'], row['revenue']))

# Commit the transaction and close the cursor and connection
conn.commit()
cursor.close()
conn.close()
