
method insert_calisma_logu.

    data: lo_logid       type ref to zcl_get_number_range,
          ls_calisma_log type zsgt_calisma_log.

    create object lo_logid.

    lo_logid->get_number(
      exporting
        i_obj      = 'ZSG_CLS_LG'
        i_nr_num   = '01'
        i_quantity = 1
      receiving
        r_number   = data(lv_logid)
    ).

    ls_calisma_log = corresponding #( is_calisma_log ).

    ls_calisma_log-uname = sy-uname.
    ls_calisma_log-datum = sy-datum.
    ls_calisma_log-uzeit = sy-uzeit.
    ls_calisma_log-logid = lv_logid.

    insert zsgt_calisma_log from ls_calisma_log.

    if sy-subrc eq 0.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.
    endif.


  endmethod.