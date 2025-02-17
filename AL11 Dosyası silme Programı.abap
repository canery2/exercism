report zfip_al11_cji3n_file_delete.

data: lt_list     type table of ocs_file,
      lv_dirname  type ocs_file-name,
      lv_dirname1 type epsf-epsdirnam,
      lv_filename type epsf-epsfilnam.

select single dirname from user_dir into lv_dirname
   where aliass eq 'DIR_ZXCJI3N'.

lv_dirname1 = lv_dirname.
call function 'OCS_GET_FILE_INFO'
  exporting
    dir_name  = lv_dirname
    file_name = '*'
  tables
    dir_list  = lt_list.
if sy-subrc eq 0.

  data: lo_calisma_log type ref to zcl_genel_class,
        lv_proje       type char24..

  create object lo_calisma_log.

  loop at lt_list assigning field-symbol(<fs>).
    "Dosyalar Günlük olarak silinir. Bu programda Job ile çalıştırılır.
    check sy-datum - <fs>-mod_date ge 0.
    check <fs>-name ne '.' and <fs>-name ne '..'.

    lv_filename = <fs>-name.


    call function 'EPS_DELETE_FILE'
      exporting
        file_name              = lv_filename
        dir_name               = lv_dirname1
      exceptions
        invalid_eps_subdir     = 1
        sapgparam_failed       = 2
        build_directory_failed = 3
        no_authorization       = 4
        build_path_failed      = 5
        delete_failed          = 6
        others                 = 7.
    if sy-subrc <> 0.
      lo_calisma_log->insert_calisma_logu( is_calisma_log = value #(
                                                              tcode = ''
                                                              parameter1 = 'DIR_ZXCJI3N'
                                                              parameter2 = lv_filename
                                                              parameter3 = 'Dosyası silinemedi.'
                                                               ) ).
    else.

      lo_calisma_log->insert_calisma_logu( is_calisma_log = value #(
                                                              tcode = ''
                                                              parameter1 = 'DIR_ZXCJI3N'
                                                              parameter2 = lv_filename
                                                              parameter3 = 'Dosyası silindi.'
                                                               ) ).
    endif.

  endloop.
endif.