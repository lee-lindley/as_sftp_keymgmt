CREATE OR REPLACE PACKAGE BODY as_sftp_keymgmt AS
    --
    -- This is the only method to select the private key when fine grained access control is added to the table
    -- with as_sftp_keymgt_security package. It is a package private function only called by login()
    --
    FUNCTION get_priv_key(i_host VARCHAR2, i_user VARCHAR2) 
    RETURN CLOB
    IS
        v_clob CLOB;
    BEGIN
        SELECT key INTO v_clob
        FROM as_sftp_private_keys k
        WHERE host = i_host AND k.id = i_user
        ;
        RETURN v_clob;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20713, 'no record found in table as_sftp_private_keys for host='||i_host||', id='||i_user);
    END ;

    --
    -- The method for obtaining the private key and using it to call as_sftp.login
    --
    PROCEDURE login(
         i_user         VARCHAR2
        ,i_host         VARCHAR2
        ,i_trust_server BOOLEAN := FALSE
        ,i_passphrase   VARCHAR2 := NULL
        ,i_log_level    pls_integer := null
    )
    IS
        v_priv_key VARCHAR2(32767) := get_priv_key(i_host, i_user);
    BEGIN
        IF i_trust_server THEN
            as_sftp.open_connection(i_host => i_host, i_trust_server => TRUE);
            -- not sure required to close and reopen, but that is how Anton's example works
            as_sftp.close_connection;
        END IF;
        as_sftp.open_connection(i_host => i_host);
        as_sftp.login(i_log_level => i_log_level, i_user => i_user, i_priv_key => v_priv_key, i_passphrase => i_passphrase);
    END;

    --
    -- 3 DML methods for manipulating the key table records
    --
    PROCEDURE insert_priv_key(i_host VARCHAR2, i_user VARCHAR2, i_key CLOB) 
    IS
    BEGIN
        INSERT INTO as_sftp_private_keys(host, id, key) VALUES(i_host, i_user, i_key);
        COMMIT;
    END insert_priv_key;

    PROCEDURE update_priv_key(i_host VARCHAR2, i_user VARCHAR2, i_key CLOB) 
    IS
    BEGIN
        UPDATE as_sftp_private_keys
            SET key = i_key
            WHERE host = i_host AND id = i_user
            ;
        COMMIT;
    END update_priv_key;

    PROCEDURE delete_priv_key(i_host VARCHAR2, i_user VARCHAR2) 
    IS
    BEGIN
        DELETE FROM as_sftp_private_keys
            WHERE host = i_host AND id = i_user
            ;
        COMMIT;
    END delete_priv_key;
END as_sftp_keymgmt;
/
show errors
