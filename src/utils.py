import pandas as pd

def value_counts_per(df, column):
    '''Simple function used to get a value count with both the counts themselves and each counts percentages of the total.'''
    return df[column].value_counts().to_frame('count').assign(percentage = lambda x:  round(x['count'] / x['count'].sum() * 100, 2))

def duplication_check(df, dup, key, x, y):

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