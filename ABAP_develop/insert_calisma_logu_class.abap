class ZCL_GENEL_CLASS definition
  public
  final
  create public .

public section.

  data:
    begin of ty_sonuc,
        sonuc type boolean,
        rows  type spo_value,
      end of ty_sonuc .
  data GS_SONUC like TY_SONUC .

  methods GET_MAX_ROWS
    returning
      value(RV_SONUC) like TY_SONUC .
  methods GET_CURRENCY_VALUE
    importing
      value(I_IMPORT_CURR) type WAERS
      value(I_EXPORT_CURR) type WAERS
      value(I_IMPORT_CURR_VAL) type WRBTR
      value(I_BLDAT) type BLDAT
    returning
      value(E_EXPORT_CURR_VAL) type DMBTR .
  methods INSERT_CALISMA_LOGU
    importing
      value(IS_CALISMA_LOG) type ZSGT_CALISMA_LOG .