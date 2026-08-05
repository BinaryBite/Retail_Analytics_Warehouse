import os
import pandas as pd
from sqlalchemy import create_engine

db_user = "postgres"
db_password = "your_password"
db_host = 'localhost'
db_port = '5432'
db_name = 'retail_dw'

engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}")

raw_data_path = "data/raw/"

csv_files = [f for f in os.listdir(raw_data_path) if f.endswith('.csv')]

for csv_file in csv_files:
    file_path = os.path.join(raw_data_path, csv_file)

    table_name = f"{os.path.splitext(csv_file)[0]}"
    table_name = table_name.replace("olist_", "")
    table_name = table_name.replace("_dataset", "")

    print(f"loading {csv_file} into {table_name}...")

    df = pd.read_csv(file_path)

    df.to_sql(table_name, 
              engine, schema = "staging", 
              if_exists = "append", 
              index = False, 
              chunksize = 500,
              method = 'multi')

    print("Done!")