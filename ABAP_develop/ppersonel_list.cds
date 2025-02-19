@AbapCatalog.sqlViewName: 'ZPSDDL_PPERS'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pasif personel listesi'
define view zcdsv_pasif_personel
  with parameters 
      p_datum : abap.dats
    as select distinct from zpst_personel as pers 
     left outer join zcdsv_aktif_personel( p_datum : $parameters.p_datum ) as aktif
       on aktif.samsperid = pers.samsperid {
        key pers.samsperid,
            pers.pernr,
            pers.vorna,
            pers.nachn
}