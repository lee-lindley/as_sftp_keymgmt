CREATE OR REPLACE PACKAGE BODY as_sftp_keymgmt AS
    --
    -- This is the only method to select the private key when fine grained access control is added to the table
    -- with as_sftp_keymgt_security package
    --
    FUNCTION get_priv_key(i_host VARCHAR2, i_user VARCHAR2) 
    RETURN CLOB
    IS
        v_clob CLOB;
    BEGIN
        SELECT key INTO v_clob
        FROM as_sftp_private_keys k
        WHERE UPPER(k.host) = UPPER(i_host) AND UPPER(k.id) = UPPER(i_user)
        ;
        RETURN v_clob;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20713, 'no record found in table as_sftp_private_keys for host='||UPPER(i_host)||', id='||UPPER(i_user));
    END ;

    PROCEDURE login(i_host VARCHAR2, i_user VARCHAR2, i_passphrase VARCHAR2 := NULL, i_log_level pls_integer := null)
    IS
        v_priv_key VARCHAR2(32767) := get_priv_key(i_host, i_user);
    BEGIN
        as_sftp.login(i_log_level => i_log_level, i_user => i_user, i_priv_key => v_priv_key, i_passphrase => i_passphrase);
    END;
END as_sftp_keymgmt;
/
show errors
