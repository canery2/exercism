PARAMETERS: p_tname TYPE tabname.
DATA: lr_tab TYPE REF TO data.
FIELD-SYMBOLS: <tab> TYPE ANY TABLE.

CREATE DATA lr_tab TYPE TABLE OF (p_tname).
ASSIGN lr_tab->* TO <tab>.
IF sy-subrc EQ 0.
  SELECT * FROM (p_tname) INTO TABLE <tab> UP TO 10 ROWS.
  cl_demo_output=>display( <tab> ).
ENDIF.
