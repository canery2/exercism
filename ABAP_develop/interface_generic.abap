report zcyp_dynamic_program.
class zcl_utilities definition.
    public section.
      class-methods: generic_data importing fs_data type ref to data.
  endclass.
  
  class zcl_utilities implementation.
    method generic_data.
        field symbols: <fs_table> type any table,
                       <fs_line> type any,
                       <fs_field> type simple.

        assign im_table->* to <fs_table>.

        loop at <fs_table> assigning <fs_line>.
            do.
                assign component sy-index of STRUCTURE <fs_line> to <fs_field>.
                if sy-subrc eq 0.
                    write : / <fs_field>.
                else.
                    exit.
                endif.
            enddo.
        endloop.

    endmethod.
  endclass.
  
  start-of-selection.
    types: begin of ty_employee,
             no   type i,
             name type char20,
             age  type i,
           end of ty_employee.
    data: it_employee type standard table of ty_employee,
          wa_employee type ty_employee,
          lr_data     type ref to data.
  
    wa_employee-no = 1.
    wa_employee-name = 'Henk'.
    wa_employee-age = 44.
  
    append wa_employee to it_employee.
  
    wa_employee-no = 2.
    wa_employee-name = 'Tom'.
    wa_employee-age = 35.
  
    append wa_employee to it_employee.
  
    get reference of it_employee into lr_data.
  
    call method zcl_utilities=>generic_data( lr_data ).