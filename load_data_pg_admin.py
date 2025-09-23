import pandas as pd
import sqlalchemy as create_engine
import os

conn_string = 'postgresql://postgres:admin@localhost/bookstore'
db = create_engine(conn_string)
conn = db.connect()

files = ['books','customers','orders']
base_path = r"C:\Users\91852\Downloads\SQL projects\Bookstore project"

for file in files:
    file_path = os.path.join(base_path,f"{file}".csv)
    df = pd.read_csv(file_path)
    df.to_sql(file,con=conn, if_exists='replace',index=False)
    print(f'Loaded {file} into postgreSQL')




