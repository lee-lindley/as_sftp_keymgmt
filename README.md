# as_sftp_keymgmt

Manage SSH private keys for Anton Scheffer's [as_sftp](https://github.com/antonscheffer/as_sftp).

# Use Case and Detail

See [blog_post/hiding_data.md](blog_post/hiding_data.md) for an explanation.

# Installation

Clone this repository or download it as a zip archive.

Note: [as_sftp](https://github.com/antonscheffer/as_sftp)
is provided as a submodule,
so use the clone command with recursive-submodules option:

`git clone --recursive-submodules https://github.com/lee-lindley/as_sftp_keymgmt.git`

or download it separately as a zip archive and extract the content of root folder
into *as_ftp* folder. You do not need to do so if you have already installed *as_sftp*
or want to do so independently. There is a compile directive in *install.sql* you can
set to TRUE or FALSE.

Follow the instructions in [install.sql](#installsql)

## install.sql

There are two *define* statements at the top of
*install.sql*.

- compile_as_sftp if set to TRUE will cause *install.sql* to compile code in the cloned
submodule directory *as_sftp*.
- compile_keymgmt_security if set to TRUE will cause *install.sql* to compile the
*as_sftp_keymgmt* package and associate it with Fine Grained Access Control on the
table *as_sftp_private_keys*.

`sqlplus YourLoginConnectionString @install.sql`

If you have not been granted EXECUTE on package *DBMS_RLS*, then even if you set
*compile_keymgmt_security* to TRUE, it will not be compiled or associated with the table.

## Usage Example

```sql
--
-- install my private key
--
begin
as_sftp_keymgmt.insert_priv_key('localhost','lee',
q'!-----BEGIN RSA PRIVATE KEY-----
xxx my key data xxx
-----END RSA PRIVATE KEY-----!');
end;
/
--
-- one time call to seed the server as trusted
--
begin
as_sftp.open_connection(ihost => 'localhost', i_trust_server => TRUE);
end;
/

--
-- then mostly from Anton's example except for the call to login
--
set serveroutput on;
declare
  l_file blob;
  l_dir_listing as_sftp.tp_dir_listing;
begin
  as_sftp.open_connection( i_host => 'localhost' );

  --
  -- new functionality with keymgmt
  --
  as_sftp_keymgmt.login(i_log_level => 3, i_user => 'lee', i_host => 'localhost');
  --
  --
  --
  -- remainder is from Anton's example
  --
  as_sftp.set_log_level( 0 );
  dbms_output.put_line( as_sftp.pwd );
  l_dir_listing := as_sftp.read_dir( i_path => '.' );
  for i in 1 .. l_dir_listing.count
  loop
    dbms_output.put_line( l_dir_listing( i ).file_name );
  end loop;
  l_file := utl_raw.cast_to_raw( 'just a small test file for testing purposes.
It contains multiple lines.
This is the third.' ); 
  /* create a file in the current directory */
  as_sftp.put_file( i_path => 'small_file.txt', i_file => l_file );  
  /* create a file in a existing subdirectory of current directory */
--  as_sftp.put_file( i_path => 'src/small_file.txt', i_file => l_file );
  l_file := utl_raw.cast_to_raw( 'dummy' );
  /* read the just created file */  
  as_sftp.get_file( i_path => 'small_file.txt', i_file => l_file );  
  dbms_output.put_line( utl_raw.cast_to_varchar2( l_file ) );
  dbms_lob.freetemporary( l_file );
  as_sftp.close_connection;
end;
/
```
