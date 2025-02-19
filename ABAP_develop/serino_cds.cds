@AbapCatalog.sqlViewName: 'zmmt_deneme_sql'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Stok Deneme CDS'
define view zmmt_deneme_cds as select from mchb {
    matnr,
    werks,
    lgort,
    charg,
    '000000000000000000' as sernr,
     clabs + cinsm + cspem as mik
} union select matnr,
               b_werk as werks,
               b_lager as lgort,
               '000000000' as charg ,
               sernr,
               1 as mik from v_equi_eqbs_sml 
    union select matnr, werks,lgort,'000000000' as charg ,
           '000000000000000000' as sernr, mikt as mik from zmmt_partisiz_serisiz_stok