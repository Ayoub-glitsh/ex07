-- 1) Création de la base + jeux d’essai
create database ex07 ;
use ex07 ;

create table client(
    idc int auto_increment primary key,
    nom varchar(30) not null ,
    prenom varchar(30) not null ,
    ville varchar(30) not null 
);

create table produit(
    idp int auto_increment primary key,
    libelle varchar(50) not null ,
    prixunitaire decimal not null 
);

create table commande(
    idcmd int auto_increment primary key,
    idc int,
    idp int,
    datecmd date not null ,
    qtitecmd int not null ,
    foreign key (idc) references client(idc),
    foreign key (idp) references produit(idp)
);

-- jeux d’essai
insert into client(nom, prenom, ville) values
('ahmed','ali','marrakech'),
('sara','bennani','ouarzazate'),
('hiba','rajeb','casablanca');

insert into produit(libelle, prixunitaire) values
('laptop', 12000),
('souris', 150),
('clavier', 300);

insert into commande(idc, idp, datecmd, qtitecmd) values
(1,1,'2025-01-10',1),
(2,2,'2025-03-15',2),
(3,3,'2025-05-12',3);


-- 2) Procédures d’ajout : ajoutclient, ajoutproduit, commander

delimiter $$

create procedure ajoutclient(in nom varchar(30), in prenom varchar(30), in ville varchar(30))
begin
    insert into client(nom, prenom, ville) values(nom, prenom, ville);
end $$

create procedure ajoutproduit(in lib varchar(50), in prix float)
begin
    insert into produit(libelle, prixunitaire) values(lib, prix);
end $$

create procedure commander(in idc int, in idp int, in datecmd date, in qtite int)
begin
    insert into commande(idc, idp, datecmd, qtitecmd)
    values(idc, idp, datecmd, qtite);
end $$

delimiter ;


-- 3) Utiliser la procédure ajoutclient

call ajoutclient('youssef', 'naji', 'agadir');


-- 4) Lister les clients dont le nom commence par une lettre donnée

delimiter $$

create procedure listerclientslettre(in lettre char(1))
begin
    select * from client
    where nom like concat(lettre, '%');
end $$

delimiter ;


-- 5) Lister les commandes entre deux dates + période


delimiter $$

create procedure commandesparperiode(in d1 date, in d2 date)
begin
    declare nb int;

    select * from commande 
    where datecmd between d1 and d2;

    select count(*) into nb from commande 
    where datecmd between d1 and d2;

    if nb > 100 then 
        select 'période rouge' as observation;
    elseif nb between 50 and 100 then
        select 'période jaune' as observation;
    else
        select 'période blanche' as observation;
    end if;
end $$

delimiter ;

-- 6) Observation clients selon nombre de commandes (année en cours)

DELIMITER ##

CREATE PROCEDURE Observation(IN id_c INT)
BEGIN
    DECLARE nb_c INT;

    -- Compter le nombre de commandes pour l'année en cours
    SELECT COUNT(*) INTO nb_c
    FROM commande
    WHERE idc = id_c
      AND YEAR(datecmd) = YEAR(CURDATE());

    -- Déterminer la classe selon le nombre de commandes
    IF nb_c > 10 THEN
        SELECT 'Class A' AS observation;
    ELSEIF nb_c > 5 THEN
        SELECT 'Class B' AS observation;
    ELSEIF nb_c >= 2 THEN
        SELECT 'Class C' AS observation;
    ELSE
        SELECT 'nbre commande < 2' AS observation;
    END IF;
END ##

DELIMITER ;

-- 7) Vérifier le stock (ajout d’une colonne stock)
-- pass 

-- 8) Lister les clients d’une ville donnée

DELIMITER $$

CREATE PROCEDURE ListerClientParVille(IN v VARCHAR(20))
BEGIN
    DECLARE result INT;

    -- Compter le nombre de clients dans la ville donnée
    SELECT COUNT(*) INTO result 
    FROM Client 
    WHERE ville = v;

    -- Vérifier s’il y a des résultats
    IF result > 0 THEN
        SELECT * FROM Client WHERE ville = v;
    ELSE
        SELECT 'Aucun client trouvé' AS message;
    END IF;
END $$

DELIMITER ;






-- 9)  procédure AfficherClientsVille(ville) qui parcourt les clients d’une ville donnée et affiche leurs noms avec une boucle LOOP.


delimiter ##
create procedure AfficherClientsVille(in v varchar(20))
begin
	declare nbt_c_parVille int ;
	declare i int default 0 ;
	select count(*)  into nbt_c_parVille from Client where ville=v ;
    loop_01 : loop
	    select nom , prenom from client  where ville=v limit i,1 ;
		set i = i + 1 ;
		if i >= nbt_c_parVille then 
			leave loop_01;
		end if ;
	 end loop loop_01;
end ##
delimiter ;
-- tests
call AfficherClientsVille("laayoune");
insert into client(nom,prenom,ville) values ("","","laayoune"),("","","laayoune"),("","","laayoune");


-- 10) une procédure ConcatClients() qui parcourt la table Client et retourneune chaîne contenant tous les noms séparés par une virgule (WHILE).

delimiter ##
create procedure ConcatClients() 
begin 
	declare NombreTotalDesClients int ;
	declare i int default 0 ;
	declare chaine longtext  default "";
	declare varInter varchar(20);
	select count(*) into NombreTotalDesClients from client ;
	while i < NombreTotalDesClients do 
		select nom into varInter from client limit i,1 ;
		set chaine = concat(chaine,varInter,",");
		set i = i + 1 ;  
		
	end while ;
	
	select chaine as message ;
	
end ##
delimiter ;


call ConcatClients();



-- 11) procédure StockProduits() qui parcourt les produits et affiche «Produit cher » si prixunitaire > 1000 sinon « Produit normal ».
  
delimiter ##
create procedure StockProduits() 
begin 
	declare Nbt_p int ;
	declare i int default 0 ;
	declare Prix int ;
	select count(*) into Nbt_p from Produit ; 
	while  i < Nbt_p   do 
		select prixunitaire into Prix from Produit limit i,1 ;
		if Prix > 1000 then 
			select 'Produit cher' as message ;
		else 
			select 'Produit normal' as message ;
		end if ;
		set i = i + 1 ;
	end while;
end ##
delimiter ;

call StockProduits();
drop procedure StockProduits;

-- 12) fonction ExisteClient(idClient) qui retourne TRUE si le client existe, FALSE sinon.
delimiter ##
create function ExisteClient(id_c int )
returns tinyint(1) 
reads sql data  
begin 
	declare nombre int ;
	select count(*) into nombre from client where idc = id_c ;
	if nombre = 1 then 
		return 1 ;
	else 
		return 0 ;
	end if ;
end ##
delimiter ;

select ExisteClient(1) as message ;


-- 13) une fonction NbClientsVille(ville) qui retourne le nombre de clients habitant dans une ville donnée.

delimiter ##
create function NbClientsVille( v varchar(20))
returns int 
reads sql data  
begin 
	declare NbCparVille int ;
	select count(*) into NbCparVille from  client where ville=v ;	

	return NbCparVille;
end ##
delimiter ;

select NbClientsVille("laayoune") as message ;





