function zpsf_pyp_statu_degistirme.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(PSPID) TYPE  PS_PSPID OPTIONAL
*"     VALUE(WBS_ELEMENT) TYPE  PS_POSID OPTIONAL
*"     VALUE(UNDO_SYSTEM_STATUS) TYPE  BAPI_UNDO_SYSTEM_STATUS OPTIONAL
*"     VALUE(SET_SYSTEM_STATUS) TYPE  BAPI_SET_SYSTEM_STATUS OPTIONAL
*"  EXPORTING
*"     VALUE(DURUM) TYPE  CHAR100
*"  TABLES
*"      E_RESULT STRUCTURE  BAPI_STATUS_RESULT OPTIONAL
*"----------------------------------------------------------------------

  if undo_system_status is initial and set_system_status is initial.
    durum = 'HATA:Sistem durumlarından birisini doldurmalısınız'.
    return.
  endif.

  select count(*) from prps
                where posid = wbs_element.
  if sy-subrc <> 0.
    durum = 'HATA:Girdiğiniz PYP kodu sistemde tanımlı değildir.'.
    return.
  endif.

  data lv_projn type proj-pspnr.
  data: gt_out like table of zpss_statu_guncelleme_alv,
        gs_out like zpss_statu_guncelleme_alv.
  data lt_wbs_elem type table of bapi_wbs_mnt_system_status.
  data: lt_return like table of bapiret2,
        ls_return	type bapireturn1 ##NEEDED,
        lt_result type table of bapi_status_result,
        ls_result type bapi_status_result.

  call function 'CONVERSION_EXIT_KONPD_INPUT'
    exporting
      input  = pspid
    importing
      output = lv_projn.

  select proj~pspid,
       proj~post1 as post1_pr,
       prps~objnr,
       prps~posid,
       prps~post1 as post1_pyp,
       prps~ernam,
       prps~erdat,
       prps~aedat,
       prps~pgsbr,
       prps~werks
   from prps inner join proj
    on prps~psphi eq proj~pspnr
    into table @data(lt_view)
  where proj~pspnr eq @lv_projn
    and prps~posid eq @wbs_element.

  data lv_pyp type ps_posid.

  call function 'CONVERSION_EXIT_ABPSP_INPUT'
    exporting
      input  = wbs_element
    importing
      output = lv_pyp.

  select * from zpsv_afvc_afko_p into table @data(lt_pyp)
                   where projn eq @lv_pyp.

  select * from jest into table @data(lt_jest)
    for all entries in @lt_view
    where objnr eq @lt_view-objnr
      and stat in ('I0001','I0002','I0045','I0046','I0076')
      and inact eq ''.

*  select * from tj02t into table @data(lt_tj02t)
*    for all entries in @lt_jest
*    where istat eq @lt_jest-stat
*      and spras eq 'T'.

  sort lt_jest by stat descending.

  loop at lt_view assigning field-symbol(<fs>).

    gs_out-stat = value #( lt_jest[ objnr = <fs>-objnr ]-stat optional ).
*    gs_out-txt30 = value #( lt_tj02t[ istat = gs_out-stat ]-txt30 optional ).
    gs_out = corresponding #( base ( gs_out ) <fs> ).

    append gs_out to gt_out.
  endloop.

************************

  loop at gt_out assigning field-symbol(<fs1>).
    if set_system_status = 'TECO'.
      if <fs1>-stat eq 'I0002'.

        append value #( wbs_element = <fs1>-posid
                       "UNDO_SYSTEM_STATUS = <f
                        set_system_status = 'TECO' ) to lt_wbs_elem.
      elseif <fs1>-stat eq 'I0045'.
        durum = 'HATA-Statü halihazırda TECO durumundadır.'.
        return.
      else.
        durum = 'HATA-Statü TECO yapmak için uygun değildir. Kontrol ediniz.'.
        return.
      endif.
    elseif undo_system_status = 'TECO'.
      if <fs1>-stat eq 'I0045'.
        append value #( wbs_element = <fs1>-posid
                      undo_system_status = 'TECO'
                       ) to lt_wbs_elem.
      elseif <fs1>-stat eq 'I0002'.
        durum = 'HATA-Statü halihazırda TECO değildir.'.
        return.
      else.
        durum = 'HATA-Statü TECO geri almak için uygun değildir. Kontrol ediniz.'.
        return.
      endif.
    endif.


  endloop.

************************************************************************************
  data : p_number             type bapi_network_list-network,
         p_undo_system_status type bapi_system_status-system_status,
         p_undo_user_status   type bapi_user_status-user_status,
         p_set_system_status  type bapi_system_status-system_status,
         p_set_user_status    type bapi_user_status-user_status,
         o_undo_system_status type bapi_system_status-system_status,
         o_undo_user_status   type bapi_user_status-user_status,
         o_set_system_status  type bapi_system_status-system_status,
         o_set_user_status    type bapi_user_status-user_status.
*****NETWORK TECO işlemleri **************************
  data : lt_network type table of bapi_act_mnt_system_status,
         ot_network type table of bapi_act_mnt_system_status,
         ut_network type table of bapi_act_mnt_system_status.
  data : ls_network type bapi_act_mnt_system_status,
         et_result  type table of bapi_status_result,
         et_return  type bapireturn1.

  if set_system_status = 'TECO'.
    loop at lt_pyp assigning field-symbol(<fsp>).
      append value #( activity = <fsp>-vornr
                      set_system_status = 'TECO' ) to lt_network.
      append value #( activity = <fsp>-vornr
                      set_system_status = 'REL' ) to ot_network.
    endloop.
    p_number = value #( lt_pyp[ 1 ]-aufnr optional ).
    p_set_system_status = 'TECO'.
    o_set_system_status = 'TECO'.
  endif.

  if undo_system_status = 'TECO'.
    loop at lt_pyp assigning <fsp>.
      append value #( activity = <fsp>-vornr
                      undo_system_status = 'TECO' ) to ut_network.
    endloop.
    p_number = value #( lt_pyp[ 1 ]-aufnr optional ).
    p_undo_system_status = 'TECO'.
    o_undo_system_status = 'TECO'.


  endif.

  refresh: et_result, lt_network.
  call function 'BAPI_PS_INITIALIZATION'.
  if set_system_status = 'TECO'.
    call function 'BAPI_BUS2002_SET_STATUS'
      exporting
        number                   = p_number
*       UNDO_SYSTEM_STATUS       =
*       UNDO_USER_STATUS         =
        set_system_status        = o_set_system_status
*       SET_USER_STATUS          =
      importing
        return                   = et_return
      tables
        i_activity_system_status = ot_network
        e_result                 = et_result.

    if et_return-type ne 'E'.

      call function 'BAPI_PS_PRECOMMIT'.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.
    endif.
  endif.

  wait up to 1 seconds.
*************************************************************************

  call function 'BAPI_PS_INITIALIZATION'.

  clear : ls_return,ls_result,lt_result[].
  call function 'BAPI_BUS2054_SET_STATUS'
    importing
      return              = ls_return
    tables
      i_wbs_system_status = lt_wbs_elem
      e_result            = e_result.
  clear ls_result.
  loop at e_result into ls_result where message_type ca 'EAX'.
    ls_return-type = ls_result-message_type.
    ls_return-message = ls_result-message_text.
    durum = |HATA-{ ls_result-message_type }:{ ls_return-message }|.
    append ls_return to lt_return.
  endloop.
  if sy-subrc <> 0.
    durum = 'OK'.

    call function 'BAPI_PS_PRECOMMIT'.
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.

  else.
    call function 'BAPI_TRANSACTION_ROLLBACK'.
    return.
  endif.
  wait up to 1 seconds.

  clear : et_return, et_result.
  refresh: et_result, lt_network.

  call function 'BAPI_PS_INITIALIZATION'.

  if set_system_status = 'TECO'.

    call function 'BAPI_BUS2002_SET_STATUS'
      exporting
        number                   = p_number
*       UNDO_SYSTEM_STATUS       =
*       UNDO_USER_STATUS         =
        set_system_status        = p_set_system_status
*       SET_USER_STATUS          =
      importing
        return                   = et_return
      tables
        i_activity_system_status = lt_network
        e_result                 = et_result.

    loop at et_result into ls_result where message_type ca 'EAX'.
      ls_return-type = ls_result-message_type.
      ls_return-message = ls_result-message_text.
      durum = |HATA-{ ls_result-message_type }:{ ls_return-message }|.
      append ls_return to lt_return.
    endloop.

    if sy-subrc <> 0.
      durum = 'OK'.

      call function 'BAPI_PS_PRECOMMIT'.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.

    else.
      call function 'BAPI_TRANSACTION_ROLLBACK'.
    endif.
  else. "TECO GEri al ise.

    call function 'BAPI_BUS2002_SET_STATUS'
      exporting
        number                   = p_number
        undo_system_status       = o_undo_system_status
*       UNDO_USER_STATUS         =
*       set_system_status        = o
*       SET_USER_STATUS          =
      importing
        return                   = et_return
      tables
        i_activity_system_status = ut_network
        e_result                 = et_result.

    if et_return-type ne 'E'.

      call function 'BAPI_PS_PRECOMMIT'.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.
      durum = 'OK'.
    else.
      loop at et_result assigning field-symbol(<fs2>) where message_type ca 'AEX'.
        ls_return-type = <fs2>-message_type.
        ls_return-message = <fs2>-message_text.

        durum = |HATA-{ ls_result-message_type }:{ ls_return-message }|.
      endloop.
    endif.
  endif.






endfunction.