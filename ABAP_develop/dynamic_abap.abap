DATA: lr_str TYPE REF TO data.
FIELD-SYMBOLS: <str> TYPE any.
FIELD-SYMBOLS: <data> TYPE any.
CREATE DATA lr_str TYPE mara.

ASSIGN lr_str->* TO <str>.
ASSIGN COMPONENT 'MATNR' OF STRUCTURE <str> TO <data>.
<data> = '112'.
...
..