create or replace package body as_sftp_keymgmt_security is
    FUNCTION user_data_select_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2
    is
        v_owner varchar2(1024);
        v_name varchar2(1024);
        v_lineno number;
        v_caller_t varchar2(1024);

        v_depth BINARY_INTEGER := UTL_CALL_STACK.dynamic_depth;
    begin
        IF v_depth < 4 THEN
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.GET_PRIV_KEY.');
            dbms_output.put_line('call stack less than 4: '||v_depth);
            DBMS_OUTPUT.put_line('Not allowing rows to be selected.');
            RETURN '1=0';
        END IF;
        /*
        FOR i in 1..v_depth
        LOOP
            v_owner := UTL_CALL_STACK.owner(i);
            v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(i));
            dbms_output.put_line('i='||i||' owner: '||v_owner||' name: '||v_name);
        END LOOP;
        */
        v_owner := UTL_CALL_STACK.owner(4);
        v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(4));
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name);
        --owa_util.who_called_me(v_owner, v_name, v_lineno, v_caller_t);
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name||' lineno: '||v_lineno||' caller_t: '||v_caller_t);
        --dbms_output.put_line(DBMS_UTILITY.format_call_stack);
        IF v_owner = 'LEE' AND v_name = 'AS_SFTP_KEYMGMT.GET_PRIV_KEY' THEN 
            RETURN NULL;
        ELSE 
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.GET_PRIV_KEY.');
            DBMS_OUTPUT.put_line('was called by owner: '||v_owner||' name: '||v_name);
            DBMS_OUTPUT.put_line('Not allowing rows to be selected.');
            RETURN '1=0';
        END IF;
        --RETURN NULL;
    end user_data_select_security
    ;

    FUNCTION user_data_insert_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2
    is
        v_owner varchar2(1024);
        v_name varchar2(1024);
        v_lineno number;
        v_caller_t varchar2(1024);

        v_depth BINARY_INTEGER := UTL_CALL_STACK.dynamic_depth;
    begin
        IF v_depth < 4 THEN
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.INSERT_PRIV_KEY.');
            dbms_output.put_line('call stack less than 4: '||v_depth);
            DBMS_OUTPUT.put_line('Not allowing rows to be selected.');
            RETURN '1=0';
        END IF;
        /*
        FOR i in 1..v_depth
        LOOP
            v_owner := UTL_CALL_STACK.owner(i);
            v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(i));
            dbms_output.put_line('i='||i||' owner: '||v_owner||' name: '||v_name);
        END LOOP;
        */
        v_owner := UTL_CALL_STACK.owner(4);
        v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(4));
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name);
        --owa_util.who_called_me(v_owner, v_name, v_lineno, v_caller_t);
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name||' lineno: '||v_lineno||' caller_t: '||v_caller_t);
        --dbms_output.put_line(DBMS_UTILITY.format_call_stack);
        IF v_owner = 'LEE' AND v_name = 'AS_SFTP_KEYMGMT.INSERT_PRIV_KEY' THEN 
            RETURN NULL;
        ELSE 
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.INSERT_PRIV_KEY.');
            DBMS_OUTPUT.put_line('was called by owner: '||v_owner||' name: '||v_name);
            DBMS_OUTPUT.put_line('Not allowing rows to be inserted.');
            RETURN '1=0';
        END IF;
        --RETURN NULL;
    end user_data_insert_security
    ;
    FUNCTION user_data_update_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2
    is
        v_owner varchar2(1024);
        v_name varchar2(1024);
        v_lineno number;
        v_caller_t varchar2(1024);

        v_depth BINARY_INTEGER := UTL_CALL_STACK.dynamic_depth;
    begin
        IF v_depth < 4 THEN
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.UPDATE_PRIV_KEY.');
            dbms_output.put_line('call stack less than 4: '||v_depth);
            DBMS_OUTPUT.put_line('Not allowing rows to be selected.');
            RETURN '1=0';
        END IF;
        /*
        FOR i in 1..v_depth
        LOOP
            v_owner := UTL_CALL_STACK.owner(i);
            v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(i));
            dbms_output.put_line('i='||i||' owner: '||v_owner||' name: '||v_name);
        END LOOP;
        */
        v_owner := UTL_CALL_STACK.owner(4);
        v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(4));
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name);
        --owa_util.who_called_me(v_owner, v_name, v_lineno, v_caller_t);
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name||' lineno: '||v_lineno||' caller_t: '||v_caller_t);
        --dbms_output.put_line(DBMS_UTILITY.format_call_stack);
        IF v_owner = 'LEE' AND v_name = 'AS_SFTP_KEYMGMT.UPDATE_PRIV_KEY' THEN 
            RETURN NULL;
        ELSE 
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.UPDATE_PRIV_KEY.');
            DBMS_OUTPUT.put_line('was called by owner: '||v_owner||' name: '||v_name);
            DBMS_OUTPUT.put_line('Not allowing rows to be updated.');
            RETURN '1=0';
        END IF;
        --RETURN NULL;
    end user_data_update_security
    ;

    FUNCTION user_data_delete_security (owner VARCHAR2, objname VARCHAR2)
    RETURN VARCHAR2
    is
        v_owner varchar2(1024);
        v_name varchar2(1024);
        v_lineno number;
        v_caller_t varchar2(1024);

        v_depth BINARY_INTEGER := UTL_CALL_STACK.dynamic_depth;
    begin
        IF v_depth < 4 THEN
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.DELETE_PRIV_KEY.');
            dbms_output.put_line('call stack less than 4: '||v_depth);
            DBMS_OUTPUT.put_line('Not allowing rows to be selected.');
            RETURN '1=0';
        END IF;
        /*
        FOR i in 1..v_depth
        LOOP
            v_owner := UTL_CALL_STACK.owner(i);
            v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(i));
            dbms_output.put_line('i='||i||' owner: '||v_owner||' name: '||v_name);
        END LOOP;
        */
        v_owner := UTL_CALL_STACK.owner(4);
        v_name := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(4));
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name);
        --owa_util.who_called_me(v_owner, v_name, v_lineno, v_caller_t);
        --dbms_output.put_line('owner: '||v_owner||' name: '||v_name||' lineno: '||v_lineno||' caller_t: '||v_caller_t);
        --dbms_output.put_line(DBMS_UTILITY.format_call_stack);
        IF v_owner = 'LEE' AND v_name = 'AS_SFTP_KEYMGMT.DELETE_PRIV_KEY' THEN 
            RETURN NULL;
        ELSE 
            DBMS_OUTPUT.put_line('security check found not called by LEE.AS_SFTP_KEYMGMT.DELETE_PRIV_KEY.');
            DBMS_OUTPUT.put_line('was called by owner: '||v_owner||' name: '||v_name);
            DBMS_OUTPUT.put_line('Not allowing rows to be deleted.');
            RETURN '1=0';
        END IF;
        --RETURN NULL;
    end user_data_delete_security
    ;
end as_sftp_keymgmt_security;
/
show errors
