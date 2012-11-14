db-version-updater-mysql
========================

# Description

Keep the verion of the database model updated, using a MySQL script.

With this script, you can keep the version of the database model without needing another tool than MySQL console.

It is the simplest and easiest way to perform this task so common, without the need to using other extra tools.

To work, creates an auxiliar database table (database\_version)  to register the executed scripts, and prevent to execute any executed script.


# Configuration

Simply chance the database name to use, or remove it to select manually.

<pre>USE databaseName</pre>


# Use

## From MySQL console

<pre>source /path/to/db_updater.sql;</pre>

If "USE database" is removed, then:

<pre>USE databaseName;
source /path/to/db_updater.sql;</pre>


## From terminal or command line

<pre>mysql -u USER -p &lt; /path/to/db_updater.sql</pre>

or

<pre>mysql -u USER -pPASS databaseName < /path/to/db_updater.sql</pre>
