CREATE OR REPLACE PACKAGE as_sftp_keymgmt AS
    --
    -- Important! The private key lookup is case sensitive on i_host and i_user.
    --
    PROCEDURE login(i_host VARCHAR2, i_user VARCHAR2, i_passphrase VARCHAR2 := NULL, i_log_level pls_integer := null);
-- comment out this function when done testing. It should not be public
    --FUNCTION get_priv_key(i_host VARCHAR2, i_user VARCHAR2) RETURN CLOB;
    --
    -- When keymgmt_security is activated (fine grained access control)
    -- These three methods are the only way to manipuate the data in the table as_sftp_private_keys
    -- other than to truncate it or do the task as sysdba.
    -- You cannot read the data at all as get_priv_key is a private function that only login() can call.
    --
    PROCEDURE insert_priv_key(i_host VARCHAR2, i_user VARCHAR2, i_key CLOB);
    PROCEDURE update_priv_key(i_host VARCHAR2, i_user VARCHAR2, i_key CLOB);
    PROCEDURE delete_priv_key(i_host VARCHAR2, i_user VARCHAR2);
END as_sftp_keymgmt;
/
show errors
