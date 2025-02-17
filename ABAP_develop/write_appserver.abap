
class cl_appserver_writer definition.
    public section.
      class-methods: write importing
                             iv_filename  type string
                             it_data      type any table
                             write_header type abap_bool default space
                           exporting
                             ev_message   type string.
  endclass.
  
  class cl_appserver_writer implementation.
    method write.
      types: begin of ty_comp_detail,
               name  type abap_compname,
               descr type scrtext_m,
             end of ty_comp_detail.
      data: lo_type_def    type ref to cl_abap_typedescr.
      data: lo_struct_def  type ref to cl_abap_structdescr.
      data: lo_table_def   type ref to cl_abap_tabledescr.
      data: lo_data_def    type ref to cl_abap_datadescr.
      data: lo_element_def type ref to cl_abap_elemdescr.
      data: lt_components  type abap_compdescr_tab.
      data: wa_components  like line of lt_components.
      data: lv_str         type string.
      data: lv_filerow     type string.
      data: lv_counter     type i value 0.
      data: lw_field_info  type dfies.
      data: ls_comp_detail type ty_comp_detail.
      data: lt_comp_detail type table of ty_comp_detail.
  
      field-symbols: <row> type any.
      field-symbols: <field_value> type any.
  
  * Using RTTS to get the runtime type information of the internal table
      lo_type_def  = cl_abap_tabledescr=>describe_by_data( it_data ).
      lo_table_def ?= lo_type_def.
      lo_data_def = lo_table_def->get_table_line_type( ).
      lo_struct_def ?= lo_data_def.
      lt_components = lo_struct_def->components.
  
      clear: lo_data_def.
  
  * If the WRITE_HEADER is ABAP_TRUE then fetch the label
  * of data element associated to each component of the
  * line type structure of internal table, if no data element
  * is associated then use component name as the header text
      if write_header eq abap_true.
        loop at lt_components into wa_components.
          lo_data_def = lo_struct_def->get_component_type( wa_components-name ).
          lo_element_def ?= lo_data_def.
          lw_field_info = lo_element_def->get_ddic_field( ).
          ls_comp_detail-name = lw_field_info-rollname.
  
  * Calling FM to get data element text
          call function 'WCGW_DATA_ELEMENT_TEXT_GET'
            exporting
              i_data_element = lw_field_info-rollname
              i_language     = sy-langu
            importing
              e_scrtext_m    = ls_comp_detail-descr
            exceptions
              error          = 1.
          if ls_comp_detail-descr is initial.
            ls_comp_detail-descr = wa_components-name.
          endif.
          append ls_comp_detail to lt_comp_detail.
          clear: ls_comp_detail.
        endloop.
      endif.
  
  
      open dataset iv_filename for output in text mode encoding default.
      if sy-subrc eq 0.
  * Writing header text for each column separated by comma
        if write_header eq abap_true.
          loop at lt_comp_detail into ls_comp_detail.
            lv_counter = lv_counter + 1.
            if lv_counter eq 1.
              lv_filerow = ls_comp_detail-descr.
            else.
              concatenate lv_filerow ',' ls_comp_detail-descr into lv_filerow.
            endif.
          endloop.
          transfer lv_filerow to iv_filename.
          clear: lv_filerow, lv_counter.
        endif.
  
  * Writing internal table content separated by comma
        loop at it_data assigning <row>.
          loop at lt_components into wa_components.
            lv_counter = lv_counter + 1.
            assign component wa_components-name of structure <row> to <field_value>.
            if <field_value> is assigned.
              lv_str = <field_value>.
              if lv_counter eq 1.
                lv_filerow = lv_str.
              else.
                concatenate lv_filerow ',' lv_str into lv_filerow.
              endif.
              unassign <field_value>.
            endif.
          endloop.
          transfer lv_filerow to iv_filename.
          clear: lv_filerow, lv_counter.
        endloop.
        close dataset iv_filename.
        ev_message = 'Success'.
      else.
        ev_message = 'Failure'.
      endif.
    endmethod.
  endclass.
  
  
  start-of-selection.
    data: lt_data  type standard table of mara.
    data: lv_filename type string.
    data: lv_message  type string.
  
    select * from mara into table lt_data up to 5 rows.
  
    cl_appserver_writer=>write(
      exporting
        iv_filename  = 'D:\usr\sap\testdata.csv'
        it_data      = lt_data
        write_header = abap_true
      importing
        ev_message   = lv_message
    ).
  
    write: / lv_message.