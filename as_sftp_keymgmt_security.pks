create or replace package as_sftp_keymgmt_security
as
    FUNCTION user_data_select_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2;
    FUNCTION user_data_insert_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2;
    FUNCTION user_data_update_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2;
    FUNCTION user_data_delete_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2;
end as_sftp_keymgmt_security;
/
show errors
