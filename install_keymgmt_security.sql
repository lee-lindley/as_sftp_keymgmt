prompt as_sftp_keymgmt_security.pks
@@as_sftp_keymgmt_security.pks
prompt as_sftp_keymgmt_security.pkb
@@as_sftp_keymgmt_security.pkb
GRANT EXECUTE ON as_sftp_keymgmt_security TO public;
CREATE OR REPLACE PUBLIC SYNONYM as_sftp_keymgmt_security FOR &&compile_schema..as_sftp_keymgmt_security ;
BEGIN
    BEGIN
        DBMS_RLS.drop_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_SELECT_POLICY');
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_RLS.add_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_SELECT_POLICY',
                      '&&compile_schema.', 'AS_SFTP_KEYMGMT_SECURITY.USER_DATA_SELECT_SECURITY',
                      'SELECT');
    BEGIN
        DBMS_RLS.drop_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_INSERT_POLICY');
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_RLS.add_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_INSERT_POLICY',
                      '&&compile_schema.', 'AS_SFTP_KEYMGMT_SECURITY.USER_DATA_INSERT_SECURITY',
                      'INSERT'
                    ,TRUE -- needed because insert does not have where clause. check condition after insert
                );
    BEGIN
        DBMS_RLS.drop_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_UPDATE_POLICY');
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_RLS.add_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_UPDATE_POLICY',
                      '&&compile_schema.', 'AS_SFTP_KEYMGMT_SECURITY.USER_DATA_UPDATE_SECURITY',
                      'UPDATE');
    BEGIN
        DBMS_RLS.drop_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_DELETE_POLICY');
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_RLS.add_policy('&&compile_schema.', 'AS_SFTP_PRIVATE_KEYS', 'USER_DATA_DELETE_POLICY',
                      '&&compile_schema.', 'AS_SFTP_KEYMGMT_SECURITY.USER_DATA_DELETE_SECURITY',
                      'DELETE');
END;
/
