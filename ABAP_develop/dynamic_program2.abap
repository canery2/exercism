data: lr_data type ref to data.
data lr_name type char30 value 'SFLIGHT'.

create data lr_data type standard table of (lr_name).

assign lr_data->* to field-symbol(<fs>).

write <fs>.
break-point.