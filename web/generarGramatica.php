<!DOCTYPE html>
<html>
<body>
<?php

////Se cargan los valores de configuración

	$archivo = $_GET['codigo'];
	$bus = $_GET['bus'];
	$pob = $_GET['pob'];
	$gen = $_GET['gen'];
	$crom = $_GET['crom'];
	
////Se borran los archivos para iniciar sin inconvenientes

$file = "configuracion.txt";
@unlink($file);

$file = "buscar.txt";
@unlink($file);

$file = "prueba.txt";
@unlink($file);

$file = "prueba.html";
@unlink($file);

$file = "Resultados.html";
@unlink($file);


/*Parametros para configuracion del algoritmo*/

$file = fopen("configuracion.txt","w+");
	fwrite($file,"///Tamaño de la población html\n".$pob."\n///Numero de generaciones\n".$gen."\n///Tamaño del cromosoma en genes\n".$crom."\n///Tamaño del codon\n3\n///Profundidad\n10\n//Porcentaje cruce\n0.30");

fclose($file);

/////////////////////////////////////////////////

//Valores para buscar el valor
$file2 = fopen("buscar.txt","w+");
 fwrite($file2,$bus);

fclose($file2);

///////////////////////////////////////////////////

//Carga los valores para el archivo de prueba

copy ("archivo/".$archivo,"pruebas.txt");

//Cerramos el archivo y abrimos los resultados

//exec('start run.bat');
exec('start ruby casofinalP.rb');

$nombre_fichero = "Resultados.html";
$valorPrue=1;
while($valorPrue==1)
{
	if(file_exists($nombre_fichero)) {
		echo '<script language="JavaScript">
window.location.href = "Resultados.html"
</script>';
	$valorPrue=0;
	} else {
		echo "--";
	}
	
}
/*	echo '<script language="JavaScript">
window.location.href = "gramaticas1/Resultados.html"
</script>';
*/
?>

</body>
</html>