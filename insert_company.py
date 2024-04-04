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

# Open and read companies.csv
with open('companies.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        company_name = row['name']
        company_id = row['\ufeffrank']
        # Check if company_id already exists in Company table
        cursor.execute("SELECT company_id FROM Company WHERE company_id = %s", (company_id,))
        result = cursor.fetchone()
        if not result:
            # If company_id does not exist, insert into Company table
            cursor.execute("INSERT INTO Company (company_id, company_name) VALUES (%s, %s)", (company_id, company_name))

# Commit changes and close connection
conn.commit()
conn.close()
