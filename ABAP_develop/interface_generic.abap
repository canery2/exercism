
parameters: p_table type dd021-tabname.

data : lr_table type ref to data,
      lr_alv type ref to cl_Salv_table.

      field-symbols: <fs_table> type any table.

      create data lr_table type standard of table (p_table).
      assign lr_table->* to <fs_table>.

      select * into table <fs_table> from(p_table) up to 10 rows.

      call method cl_Salv_table=>factoyr 
      importing r_salv_table = lr_alv 
      changing t_table = <fs_table>.

      lr_alv->display( ).