whenever sqlerror continue
@@as_sftp/src/as_sftp_known_hosts.sql
prompt OK if failed for table already exists
whenever sqlerror exit failure
-- he does not have the slash after END. not sure why
prompt as_sftp.pks
@@as_sftp/src/as_sftp.pks
/
prompt as_sftp.pkb
@@as_sftp/src/as_sftp.pkb
/
