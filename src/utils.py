import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def value_counts_per(df, column):
    '''Simple function used to get a value count with both the counts themselves and each counts percentages of the total.'''
    return df[column].value_counts().to_frame('count').assign(percentage = lambda x:  round(x['count'] / x['count'].sum() * 100, 2))

def duplication_check(df: pd.DataFrame, dup, key, x, y):

    dup_customers = df[df[dup].duplicated(keep=False)]

    dup_location_check = (
        dup_customers
        .groupby(dup)
        .agg(
            duplicate_count=(key, 'size'),
            unique_x=(x, 'nunique'),
            unique_y=(y, 'nunique')
        )
        .sort_values(by='duplicate_count', ascending=False)
    )

    return dup_location_check.head(10)

def find_outliers(df: pd.DataFrame, columns: list):
    """Simple function for finding how many outliers are in the numerical attribute(s).
    Defintion of outlier is based on 1.5 times the Interquantile Range below the first quartile or
    above the third quartile"""
    Q1 = df[columns].quantile(0.25)
    Q3 = df[columns].quantile(0.75)
    IQR = Q3 - Q1

    outliers = (df[columns] < (Q1 - 1.5 * IQR)) | \
           (df[columns] > (Q3 + 1.5 * IQR))

    return outliers

def count_density_plot(data: pd.DataFrame, x: str, remove_outliers: bool = True):

    if remove_outliers == True:
        data = data[~find_outliers(data, columns = ["price"])]

    fig, ax1 = plt.subplots()

    sns.kdeplot(data, x = x, linewidth = 2, ax = ax1, color = "Black", label = "Density")

    ax2 = ax1.twinx()

    sns.histplot(data, x = x, ax = ax2, alpha=0.3, stat = "count", color = "Blue", label = "count")

    ax1.set_ylabel("Density")
    ax2.set_ylabel("Count")
    ax1.set_xlabel(x)
    ax1.set_title(f"{x}: Density and Count in the Dataset {"(Outliers Removed)" if remove_outliers else ""}".title())
