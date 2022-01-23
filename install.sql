whenever sqlerror exit failure
define compile_as_sftp="TRUE"
define compile_keymgmt_security="TRUE"
-- for conditional compilation. Define value of do_file will be the script to run
COLUMN :file_name NEW_VALUE do_file NOPRINT
VARIABLE file_name VARCHAR2(128)
--
-- get the current_schema name into a define named compile_schema. Reuse our :file_name/do_file combo for the purpose
--
BEGIN
    :file_name := SYS_CONTEXT('USERENV','CURRENT_SCHEMA');
END;
/
SELECT :file_name FROM dual;

define compile_schema=&&do_file
prompt compiling in schema &&compile_schema
prompt

--
BEGIN
    :file_name := CASE WHEN '&&compile_as_sftp' = 'TRUE' THEN 'install_as_sftp.sql' ELSE 'do_nothing.sql as_sftp' END;
END;
/
SELECT :file_name FROM dual;
prompt calling &&do_file
@@&&do_file
--
whenever sqlerror continue
prompt deploying table as_sftp_private_keys
@@as_sftp_private_keys.sql
prompt ok if table create fails because table already exists
whenever sqlerror exit failure
prompt deploying as_sftp_keymgmt.pks
@@as_sftp_keymgmt.pks
prompt deploying as_sftp_keymgmt.pkb
@@as_sftp_keymgmt.pkb

DECLARE
    l_cnt NUMBER;
BEGIN
    IF '&&compile_keymgmt_security' = 'TRUE' THEN
        select COUNT(*) INTO l_cnt
        FROM all_procedures
        WHERE object_type = 'PACKAGE' AND object_name = 'DBMS_RLS';
        IF l_cnt > 0 THEN
            :file_name := 'install_keymgmt_security.sql';
        ELSE
            :file_name := 'not_installing_keymgmt_security.sql';
        END IF;
    ELSE
        :file_name := 'not_installing_keymgmt_security.sql';
    END IF;
END;
/
SELECT :file_name FROM dual;
prompt calling &&do_file
@@&&do_file


