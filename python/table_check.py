import pandas as pd
import os

raw_data_path = "data/raw/"

csv_files = [f for f in os.listdir(raw_data_path) if f.endswith('.csv')]

for csv_file in csv_files:
    file_path = os.path.join(raw_data_path, csv_file)
    print(f"\n{'='*50}\nInspecting File: {csv_file}\n{'='*50}")

    df = pd.read_csv(file_path)

    print("Dataframe Info: ")
    print(df.info(), "\n")

    print("Dataframe Head: ")
    print(df.head(), "\n")

