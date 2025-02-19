@AbapCatalog.sqlViewName: 'ZCDSV_MATNR_S'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Matnr Search Help'
define view zcdsv_matnr_sh111  as select distinct from  mara as mm 
                                             
                                             inner join marc on mm.mandt = marc.mandt 
                                                            and mm.matnr = marc.matnr
                                             inner join mard on marc.mandt = mard.mandt
                                                            and marc.matnr = mard.matnr  
                                                            and marc.werks = mard.werks
                                            
  {                             
        mm.matnr , 
        marc.werks,
        mtart,
        zz_mlz_um, 
        labst      ,
         lgort,
        dismm                  
     
  } 
//  group by mm.matnr, mard.werks, mtart, zz_mlz_um
// group by mm.matnr,werks,mtart,zz_mlz_um, lgort