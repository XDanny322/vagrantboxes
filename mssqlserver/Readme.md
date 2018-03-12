# MSSQL on Linux

This vagrant box was created for me to quickly test MSSQL on linux.  Most of the work was done by Microsoft, as i took a script that already did and just turned it into a box, and fooling around with.  Please see the pervisioner shell script for the script.

See below for quick fooling around ata.

```
[vagrant@mssqlserver ~]$ /opt/mssql-tools/bin/sqlcmd  -S localhost -U SA -P  password1234!
1> CREATE DATABASE TestDB3
2> GO
1>
1> SELECT Name from sys.Databases
2> go
Name
--------------------------------------------------------------------------------------------------------------------------------
master
tempdb
model
msdb
TestDB
TestDB2
TestDB3

(7 rows affected)
1> USE TestDB3
2>
3> go
Changed database context to 'TestDB3'.
Changed database context to 'TestDB3'.
1> CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
2> INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
3> go

(1 rows affected)

(1 rows affected)
1>
1>
1>
1> SELECT * FROM Inventory WHERE quantity > 152;
2> GO
id          name                                               quantity
----------- -------------------------------------------------- -----------
          2 orange                                                     154

(1 rows affected)
1> quit
[vagrant@mssqlserver ~]$
```