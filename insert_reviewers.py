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
        # Split user_id, review_title, review_content, and user_name by commas if they contain multiple values
        user_ids = row['user_id'].split(',')
        review_titles = row['review_title'].split(',')
        review_contents = row['review_content'].split(',')
        user_names = row['user_name'].split(',')
        
        for user_id, review_title, review_content, user_name in zip(user_ids, review_titles, review_contents, user_names):
            # Truncate review_content to 255 characters
            review_content = review_content[:255]

            # Trim any leading or trailing whitespace from user_id
            user_id = user_id.strip()
            
            # Check if user_id exists in Person table
            cursor.execute("SELECT id FROM Person WHERE id = %s", (user_id,))
            result = cursor.fetchone()
            if not result:
                continue
            
            # Check if user_id exists in Person table
            cursor.execute("SELECT reviewers_id FROM Reviewers WHERE reviewers_id = %s", (user_id,))
            result = cursor.fetchone()
            if not result:
              # Insert data into Reviewers table
              cursor.execute("INSERT INTO Reviewers (reviewers_id, person_id, review_title, review_content) VALUES (%s, %s, %s, %s)",
                            (user_id, user_id, review_title.strip(), review_content.strip()))

            # Add user_id to seen set
            seen_user_ids.add(user_id)

# Commit changes and close connection
conn.commit()
conn.close()
