CREATE OR REPLACE PACKAGE as_sftp_keymgmt AS
    PROCEDURE login(i_host VARCHAR2, i_user VARCHAR2, i_passphrase VARCHAR2 := NULL, i_log_level pls_integer := null);
-- comment out this function when done testing. It should not be public
    --FUNCTION get_priv_key(i_host VARCHAR2, i_user VARCHAR2) RETURN CLOB;
    --
    PROCEDURE insert_priv_key(i_host VARCHAR2, i_user VARCHAR2, i_key CLOB);
    PROCEDURE update_priv_key(i_host VARCHAR2, i_user VARCHAR2, i_key CLOB);
    PROCEDURE delete_priv_key(i_host VARCHAR2, i_user VARCHAR2);
END as_sftp_keymgmt;
/
show errors
