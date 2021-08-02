function [ row, column ] = extract_row_and_column_from_id( ID )

global no_of_cols;
global no_of_rows;

column = rem(ID, no_of_cols);
row = mod(ID, no_of_cols) + 1;

if (column == 0)
    column = no_of_cols;
    row = row - 1;
end

assert(row <= no_of_rows, 'row should be less than no_of_rows');
end