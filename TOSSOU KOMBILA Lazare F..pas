program gestionnaire;
{Rédiger par Lazare Fortune}
uses crt;

type 
	etudiant = record
	nom,prenom: string[20];
	moyenne:real;
	end;
	
fichier = file of etudiant;

var 
f:fichier;
choix:integer;


{Creation du fichier de donnees f}
PROCEDURE creation(var f: fichier);
var choix3: integer;
c:char;
begin
	writeln;
	repeat
		writeln('ATTENTION si la BDD existe deja en cliquant (1)');
		writeln('vous allez perdre vos donnees');
		write('tapez (1) créer la BDD ou (2) Annuler  :');
		readln(choix3);
	until (choix3=1) or (choix3=2);
	if choix3=1 then
		begin
			rewrite(f);
			close(f);
			writeln;
			writeln('BDD cree avec succes');
			writeln('Presser une touche...');
			c:=readkey;
		end;
end;




{Procedure d'affichage des etudiants}
procedure afficher(var f:fichier);
var 
e:etudiant;
c:char; 
i:integer;
begin
	writeln;writeln;
	reset(f);
	for i:=0 to (filesize(f)-1) do
		begin
			read(f,e);
			writeln(i+1,'-)  ',e.nom,' ',e.prenom,' ',e.moyenne:2:2);
		end;
	if (filesize(f)=0) then writeln('Votre liste est vide , ajoutez y des etudiants si vous le souhaitez');
	close(f);
	writeln;writeln;
	writeln('Presser une touche...');
	c:=readkey;
end;
{procedure du tri des etudiants}
PROCEDURE tri(var f: fichier);
var r1, r2: etudiant;
i, j: integer;
begin
	reset(f);
	for i:=0 to filesize(f)-2 do
		begin
			seek(f,i);
			read(f,r1);
			for j:=i+1 to filesize(f)-1 do
				begin
					seek(f,j);
					read(f,r2);
					if (r1.nom+r1.prenom)>(r2.nom+r2.prenom) then
						begin
						{Permutation}
							seek(f,i);
							write(f,r2);
							seek(f,j);
							write(f,r1);
							r1:=r2;
						end;
				end;
		end;
end;
{procedure d'ajout des etudiants dans le fichier}
PROCEDURE ajout(var f: fichier);
	var  nouveau: etudiant;  
	choix: integer;
	begin  
	{Positionnement en fin de fichier}
		reset(f);
		seek(f,filesize(f));
		repeat{Saisie}
			writeln;
			with nouveau do
				begin
					write('Nom         : ');readln(nom);
					write('Prenom      : ');readln(prenom);
					write('Moyenne     : ');readln(moyenne);
				end;
				{Stockage}
			write(f,nouveau);
			{Stop ou encore}
			writeln;
			write('Saisir (1) pour ajouter encore / (0) pour finir : ');readln(choix);
		until choix=0;
		tri(f);  
		close(f);
	end;
{procedure de formatage du fichier}
procedure efface(var f:fichier);
var c:char;
begin
	rewrite(f);
	writeln('Vous venez d efface la liste avec succes');
	writeln;
	writeln('Presser une touche...');
	c:=readkey;
end;

{Saisie de position dans le fichier f}
FUNCTION saisiepos(var f: fichier): integer;
var pos: integer;
begin
	writeln;
	reset(f);
	repeat
		writeln('taper 0 pour annuler la saisie ');
		write('Quel est le numero de l etudiant? choisir entre [1-',filesize(f),'] : ');
		
		readln(pos);
		if pos=0 then break;
	until (pos>=1) and (pos<=filesize(f));
	pos:=pos-1;
	close(f);
	saisiepos:=pos;
end;

{modification d'un etudiant}
(*
PROCEDURE modif(var f:fichier);
var pos: integer;
r: etudiant;
begin
	pos:=saisiepos(f);
	  {Saisie}
	writeln;
	with r do
		begin
			writeln('Numero               : ',pos+1);
			write('Nouveau nom          : ');readln(nom);
			write('Nouveau prenom       : ');readln(prenom);
			write('Nouvelle moyenne     : ');readln(moyenne);
		end;
	{Positionnement dans le fichier et stockage}
	reset(f);
	seek(f,pos);
	write(f,r);
	close(f);
end;
*)


procedure tout(var f:fichier ; pos:integer);
var r: etudiant;
begin
	with r do
		begin
			write('Nouveau nom          : ');readln(nom);
			write('Nouveau prenom       : ');readln(prenom);
			write('Nouvelle moyenne     : ');readln(moyenne);
		end;
{Positionnement dans le fichier et stockage}
	reset(f);
	seek(f,pos);
	write(f,r);
	close(f);
end;

procedure nom(var f:fichier ; pos:integer);
var b:string;
g:char;
c:real;
e,r: etudiant;
begin
	reset(f);
	seek(f,pos);
	read(f,e);
	b:=e.prenom;
	c:=e.moyenne;
	clrscr;
	with r do
		begin
			write('Nouveau nom          : ');readln(nom);
			prenom:=b;
			moyenne:=c;
		end;
{Positionnement dans le fichier et stockage}
	seek(f,pos);
	write(f,r);
	close(f);
	writeln;
	writeln('Le NOM du numero ',pos+1,' a ete changer avec succes');
	writeln;
	writeln('Presser une touche...');
	g:=readkey;
end;

procedure prenom(var f:fichier ; pos:integer);
var a:string;
g:char;
c:real;
e,r: etudiant;
begin
	reset(f);
	seek(f,pos);
	read(f,e);
	a:=e.nom;
	c:=e.moyenne;
	clrscr;
	with r do
		begin
			write('Nouveau prenom          : ');readln(prenom);
			nom:=a;
			moyenne:=c;
		end;
{Positionnement dans le fichier et stockage}
	seek(f,pos);
	write(f,r);
	close(f);
	writeln;
	writeln('Le PRENOM du numero ',pos+1,' a ete changer avec succes');
	writeln;
	writeln('Presser une touche...');
	g:=readkey;
end;

procedure moyenne(var f:fichier ; pos:integer);
var a,b:string;
g:char;
e,r: etudiant;
begin
	reset(f);
	seek(f,pos);
	read(f,e);
	a:=e.nom;
	b:=e.prenom;
	clrscr;
	with r do
		begin
			write('Nouvelle moyenne          : ');readln(moyenne);
			nom:=a;
			prenom:=b;
		end;
{Positionnement dans le fichier et stockage}
	seek(f,pos);
	write(f,r);
	close(f);
	writeln;
	writeln('La MOYENNE du numero ',pos+1,' a ete changer avec succes');
	writeln;
	writeln('Presser une touche...');
	g:=readkey;
end;

{modification d'un etudiant}
PROCEDURE modif(var f:fichier);
var pos,m: integer;
r: etudiant;
begin
	
	repeat
		clrscr;
		afficher(f);
		pos:=saisiepos(f);
		if pos=-1 then break
		else
			begin
		  {Saisie}
				writeln;
				writeln('Numero               : ',pos+1);
				writeln('Que voulez vous modifier ?');
				writeln('1-) nom ?');
				writeln('2-) prenom ?');
				writeln('3-) moyenne ?');
				writeln('4-) tout ?');
				writeln;writeln;
				writeln('0-) Fin de la modification');
				readln(m);
				case m of
					1:nom(f,pos);
					2:prenom(f,pos);
					3:moyenne(f,pos);
					4:tout(f,pos);
				end;
			end;
	until m=0;
end;














{Suppression d'un etudiant a partir de sa position dans le fichier f}
PROCEDURE suppression(var f:fichier);
var pos, i: integer;
c:char;
r: etudiant;
temp: fichier;
begin
	clrscr;
	afficher(f);
	pos:=saisiepos(f);
	//if pos=-1 then break
	if pos<>-1 then
		begin
			assign(temp, 'temp.fic');
			rewrite(temp);
			reset(f);
			  {Copie du fichier f dans le fichier temp jusqu'a la position pos-1}
			for i:=0 to pos-1 do
				begin
					seek(f,i);
					read(f,r);
					write(temp,r);
				end;
				
		{Copie du fichier f dans le fichier temp de la position pos+1 a la fin}
			for i:=pos+1 to filesize(f)-1 do
				begin
					seek(f,i);
					read(f,r);
					write(temp,r);
				end;  
			close(f);
			close(temp);
		{Suppression de l'ancien fichier f et remplacement par temp}
			erase(f);
			rename(temp, 'rep.fic');
			assign(f, 'rep.fic');
			writeln;
			writeln('Suppression Ok.');
			writeln('Presser une touche...');
			c:=readkey;
	end;
end;






{PROGRAMME PRINCIPALE}
begin
	assign(f,'etudiant.txt');
	repeat
	clrscr;
	writeln;
	writeln('1) Ajouter un/des etudiant(s)');
	writeln('2) Consulter la liste des etudiants + moyennes');
	writeln('3) effacer la liste des etudiants');
	writeln('4) modifier un etudiant');
	writeln('5) supprimer un etudiant');
	writeln;
	writeln('9) Creer la Base de donnees des etudiant');
	writeln;
	writeln('0) Fin');
	writeln;
	writeln;
	write('Votre choix : ');
	readln(choix);
	case choix of
		1: ajout(f);
		2: afficher(f);
		3: efface(f);
		4:modif(f);
		5:suppression(f);
		9:creation(f);
	end;
	until choix=0;
	clrscr;
	writeln('MERCI d avoir utiliser le programme de');writeln;writeln;
	writeln('TOSSOU KOMBILA LAzare Fortune');writeln;
	writeln('A bientot pour des MAJ');writeln;writeln;
	writeln('appuyer une touche');
	readln;
end.	


