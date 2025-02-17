data: lv_var type char30 value 'This is a test string'.

field-symbols: <fs_any> type any.
assign lv_var+7(7) to <fs_any>.

write <fs_any>.

break-point.