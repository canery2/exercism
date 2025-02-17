*&---------------------------------------------------------------------*
*& Report  ZCYP_DYNAMIC_PROGRAM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zcyp_dynamic_program.

data: lr_a type ref to i,
      lv_a type i value 90.

get reference of lv_a into lr_a.

write lr_a->*.

lr_a->* = 25.

write lv_a.
