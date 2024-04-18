#!/usr/bin/env python3

import os
import sys
import argparse
import pandas as pd

def main():
    args = parse_args()

    if (args):
        input_csv = args.input_csv
        output_csv = args.output_csv

    # Read the CSV file
    df = pd.read_csv(input_csv)

    # Remove columns
    columns_to_remove = ['Account Number', 'Account Name','Last Price','Last Price Change','Today\'s Gain/Loss Dollar','Today\'s Gain/Loss Percent','Type']
    df.drop(columns=columns_to_remove, inplace=True)

    # Reorder columns
    desired_column_order = ['Symbol','Description','Quantity','Average Cost Basis','Cost Basis Total','Current Value','Total Gain/Loss Dollar','Total Gain/Loss Percent','Percent Of Account']
    df = df[desired_column_order]

    # Insert an empty column at index 6
    df.insert(6, '', '')

    # Write the modified DataFrame back to a CSV file
    df.to_csv(output_csv, index=False)

def parse_args():
    parser = argparse.ArgumentParser(description='Simplify Fidelity Portfolio CSV for Import.')

    parser.add_argument('input_csv', help='Portfolio CSV')
    parser.add_argument('output_csv', help='Output CSV')

    args = parser.parse_args()

    if not os.path.exists(args.input_csv):
        print("input_csv doesn't exist.")
        sys.exit()

    if (args.input_csv == args.output_csv):
        print("output_csv should be different from input_csv.")
        sys.exit()

    return args

if __name__ == '__main__':
    main()
