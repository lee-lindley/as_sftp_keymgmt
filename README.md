# as_sftp_keymgmt

Manage SSH private keys for Anton Scheffer's [as_sftp](https://github.com/antonscheffer/as_sftp).

# Use Case and Detail

See [blog_post/hiding_data.md](blog_post/hiding_data.md) for an explanation.

# Installation

Clone this repository or download it as a [zip](https://github.com/lee-lindley/app_html_table_pkg/archive/refs/heads/main.zip) archive.

`git clone https://github.com/lee-lindley/app_html_table_pkg.git`

## install.sql

*install.sql* is a simple compile of the package specification and body.

`sqlplus YourLoginConnectionString @install.sql`

# Use Case

Present HTML Table markup from an Oracle query while right aligning numeric data in the cells.
This is not a full HTML document, but a section that you can include in a larger HTML body. For example:

    SELECT app_html_table_pkg.query2html(q'!SELECT * FROM hr.departments!')
    FROM dual;

The resulting markup text is enclosed with a \<div\> tag and can be added to an HTML email or otherwise included
in an HTML document.

While here, it turned out to be not so difficult to provide a way for you to insert your own
style choices for the table via CSS. You do not need to be a CSS guru to do it. The pattern
from the examples will be enough for most. That said, it got a bit harder when trying
to support legacy HTML rendering engines like Outlook. Gmail web client is style stupid.
There is a special option to output dumbed down HTML for Gmail.

The common method for generating HTML markup tables from SQL queries in Oracle
is to use DBMS_XMLGEN and XSLT conversions via XMLType. A search of the web will
turn up multiple demonstrations of the technique. It works reasonably well, but there are
some gotchas like column headers with spaces get munged to \_x0020\_ and all data is left justified
in the cells.

A big drawback is that we often want to right justify numeric data. In plain text output we can use LPAD(TO_CHAR... 
(or just TO_CHAR) to simulate right justification, 
but HTML does not respect spaces unless we use **pre**, and even then I'm not sure
we can count on the font to not mess up our alignment. I'm not an HTML or XSLT expert, but I do not think
preserving white space helps.

We need to use a right alignment style modifier on the table data tag when we want numbers right aligned. We 
can do so with a custom local scoped style that sets the alignment for particular columns.

# Manual Page

## query2html

```sql
    FUNCTION query2html(
        p_sql                       CLOB
        ,p_right_align_col_list     VARCHAR2 := NULL -- comma separated integers in string
        ,p_caption                  VARCHAR2 := NULL
        ,p_css_scoped_style         VARCHAR2 := NULL
        ,p_older_css_support        VARCHAR2 := NULL
        -- 'G' means nuclear option for gmail, 'Y' means your css cannot be too modern and we need to work harder
        -- like for Outlook clients.
        ,p_odd_line_bg_color        VARCHAR2 := NULL -- header row is 1
        ,p_even_line_bg_color       VARCHAR2 := NULL

    ) RETURN CLOB
    ;
```
The returned CLOB using the default
scoped style, modern css support, and no caption looks as follows;
however, the two style elements at the end of the style section
with "**text-align:right;**" are customized via
a *p_right_align_col_list* value of '1, 4'. 

	<div id="plsql-table">
	<style type="text/css" scoped>
	table {
	    border: 1px solid black;
	    border-spacing: 0;
	    border-collapse: collapse;
	}
    caption {
        font-style: italic;
        font-size: larger;
        margin-bottom: 0.5em;
    }
    th {
        text-align:left;
    }
	th, td {
	    border: 1px solid black;
	    padding:4px 6px;
	}
	tr > td:nth-of-type(1) {
	    text-align:right;
	}
	tr > td:nth-of-type(4) {
	    text-align:right;
	}
	</style>
	<table>
    <tr>
        <th>Emp ID</th>
        <th>Full Name</th>
        <th>Date_x002C_Hire</th>
        <th>Salary</th>
    </tr>
    <tr>
      <td>000999</td>
      <td>  Baggins, Bilbo &quot;badboy&quot; </td>
      <td>12/31/1999</td>
      <td>     $123.45</td>
    </tr>
    <tr>
      <td> 000206</td>
      <td>Gietz, William</td>
      <td>06/07/2002</td>
      <td>   $8,300.00</td>
    </tr>
    ...
	</table></div>

### p_sql

A string containing the SQL statement to execute.

### p_right_align_col_list

A string that contains a comma separated list of column numbers (like '1, 4'). 
It must be NULL or match the regular expression '^(\s*\d+\s*(,|$))+$'
else an error will be raised. This produces the

    tr > td:nth-of-type(__colnum__) {
	    text-align:right;
	}

elements in the local style where \_\_colnum\_\_ is the column number; however,
see below for what happens with *p_older_css_support* is 'Y'.

### p_caption

If provided, will be wrapped with \<caption\> \</caption\> and inserted following the \<table\> tag.

### p_css_scoped_style

Do not include the \<style\> \</style\> elements as the function will add those. Everything else
that the function provides by default you are responsible for except for the following.

- If *p_older_css_support* is 'Y', then **td.right**, **td.left**, **tr.odd**, and **tr.even** classes
    with colors you provided (or nothing) will be added to your style. 
- Otherwise we optionaly add , 
    - as many as needed "tr > td:nth-of-type(\_\_column number\_\_) { text-align:right; }"
    - tr:nth-child(even) { background-color: \_\_your provided color\_\_ }
    - tr:nth-child(odd)  { background-color: \_\_your provided color\_\_ }

You will notice I've stayed away from specifying actual fonts. You are welcome to set them
in your provided stylesheet.

### p_older_css_support

If 'Y' or 'y' (you need this set to 'Y' for Outlook client email), then we cannot use the modern
"nth-of-type" mechanism for right-aligned columns or "nth-child" for alternating row colors. 
We must apply the class values to the table data elements within the HTML. To do that
we add the classes

- td.right
- td.left
- tr.odd  (will be empty class if *p_odd_line_bg_color*  is null)
- tr.even (will be empty class if *p_even_line_bg_color* is null)

This makes it display mostly correct in the desktop version of Outlook. The web version
of outlook also is mostly correct.

Even with this, you still will not see it correctly in Gmail web client which seems
particularly brutal about ignoring scoped style settings. 

If *p_older_css_support* is set to 'G' or 'g', then the HTML has the style requirements
directly in the \<tr\> and \<td\> elements without refering to CSS style names.

I'm not sure about others.

The code is now so ugly supporting all of these variants that I'm tempted to eliminate all the
fancy style support and just make the dumbed down HTML be the default. Setting the flag to 'G' gives
HTML most likely to be rendered correctly in any client.

### p_odd_line_bg_color

If provided, one of the these two classes will be added to the CSS style:

- tr:nth-child(odd)   { background-color: \_\_your provided color\_\_ }
- tr.odd { background-color: \_\_your provided color\_\_ }

Note that we count the header row for determining odd or even.

### p_even_line_bg_color

If provided, one of the these two classes will be added to the CSS style:

- tr:nth-child(even)   { background-color: \_\_your provided color\_\_ }
- tr.even { background-color: \_\_your provided color\_\_ }

## cursor2html

```sql
    FUNCTION cursor2html(
        p_src                           SYS_REFCURSOR
        ,p_right_align_col_list         VARCHAR2 := NULL -- comma separated integers in string
        ,p_caption                      VARCHAR2 := NULL
        ,p_css_scoped_style             VARCHAR2 := NULL
    ) RETURN CLOB
    ;
```

### p_src

An open SYS_REFCURSOR. This form allows you to use bind variables in your query. *query2html* opens
a SYS_REFCURSOR and calls *cursor2html* to do the work. 

Other parameters are the same as *query2html*.

# Examples

## Example 0

A simple query with no alignment overrides. Everything is left justified.

```sql
SELECT app_html_table_pkg.query2html(q'!SELECT * FROM hr.departments!')
FROM dual;
```

| ![Example 0](images/example0.gif) |
|:--:|
| Example 0 Simple Query |

## Example 1

All kinds of shenanigans going on here. 

- We set *p_right_align_col_list* to '1, 4' to get the first and fourth columns right justified.
- We add a caption.
- We make odd numbered rows (starting with the header row, but the color for that is overriden) **AliceBlue**.
- We make even numbered rows **LightGrey**.
- We provide a custom style that starts with the default one in the package and tweaks it.
    - Make the caption bold/italic instead of just italic.
    - Set the background color for the column headers to **Orange**.

Pretty fancy if a big garish and ugly! But given that you have the default CSS code from the package
plus this example, it is not that
much of a stretch to make your table look the way you want.

In fact I think it would be a fine idea for you to tweak the default CSS in the package
for your organization.

```sql
SELECT app_html_table_pkg.query2html(p_sql => q'[
        SELECT TO_CHAR(employee_id, '099999') AS "Emp ID", last_name||', '||first_name AS "Full Name", hire_date AS "Date,Hire", TO_CHAR(salary,'$999,999.99') AS "Salary"
        from hr.employees
        UNION ALL
        SELECT '000999' AS "Emp ID", '  Baggins, Bilbo "badboy" ' AS "Full Name", TO_DATE('19991231','YYYYMMDD') AS "Date,Hire", TO_CHAR(123.45,'$999,999.99') AS "Salary"
        FROM dual
        ORDER BY "Emp ID" desc]'
                                    ,p_caption              => 'Poorly Paid People'
                                    ,p_right_align_col_list => '1,4'
                                    --,p_older_css_support => 'Y'
                                    ,p_odd_line_bg_color    => 'AliceBlue'
                                    ,p_even_line_bg_color   => 'LightGrey'
                                    ,p_css_scoped_style     => q'!
table {
    border: 1px solid black; 
    border-spacing: 0; 
    border-collapse: collapse;
}
caption {
    font-style: italic;
    font-weight: bold;
    font-size: larger;
    margin-bottom: 0.5em;
}
th {
    text-align:left;
    background-color: Orange
}
th, td {
    border: 1px solid black; 
    padding:4px 6px;
}
!'
    )
FROM dual;
```

| ![Example 1](images/example1.gif) |
|:--:|
| Example 1 Fancy Shenanigans |

The function changed '\_x0020\_' to spaces in the column headers, thus dealing with one common problem
of using DBMS_XMLGEN, but we did not try to fix the issue of having a comma in your column alias. Other XML identifier
"special" characters could be encoded as well. You are on your own for that.

Overall this is a pretty fancy result for a bit of copy/pasting and tweaking of the provided style.
