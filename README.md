 🗄️ PROJECT EX07 – ORDER MANAGEMENT (MYSQL)


 📘 DESCRIPTION

The ex07 project implements a MySQL relational database for managing clients, products, and orders of a small business. It includes table creation, sample data insertion, and several stored procedures and SQL functions to automate data management tasks.

 🧩 DATABASE STRUCTURE

Client(idc, nom, prenom, ville)
Product(idp, libelle, prixunitaire)
Order(idcmd, #idc, #idp, datecmd, qtitecmd)

 ⚙️ FILE CONTENT (EX07.SQL)

The SQL script contains:

* Database and table creation

* Stored Procedures:

  * ajoutclient(), ajoutproduit(), commander()
  * listerclientsparville(), afficherclientsville(), concatclients(), stockproduits(), verifierstock()
  * periodecommandes(), classificationclients()

* Functions:

  * existeclient(idc) returns 1 if the client exists, 0 otherwise
  * nbclientsville(ville) returns the number of clients in a given city

 🎯 LEARNING OBJECTIVES

This project helps you practice:

* Creating and using stored procedures and SQL functions
* Applying control structures (IF, WHILE, LOOP) in MySQL
* Managing relational databases with business logic integration

 🧪 TESTING ENVIRONMENT

* DBMS: MySQL 8.0
* Tool used: DBeaver
* Field: DEVOWFS
* Institution: ISTA Ouarzazate
* Instructor: Nassiri Ilyas

 🚀 HOW TO USE

1. Clone the repository:

   git clone [https://github.com/](https://github.com/)<your-username>/ex07.git
   cd ex07

2. Open the ex07.sql file in DBeaver, MySQL Workbench, or any SQL tool.

3. Execute the script step by step:

* Create the database
* Insert the test data
* Create stored procedures and functions
* Test them using commands like:

  call ajoutclient('Ayoub', 'Aguezar', 'Ouarzazate')
  call listerclientsparville('Marrakech')
  select existeclient(3)

 

🔗 EXERCISE LINK

If you want to see the original exercise instructions, you can access them here:
Original ex07 Exercise : https://drive.google.com/file/d/1Jq8a0kGjAhEiDJAyDeCrfpsI11NXTB5r/view?usp=sharing 


