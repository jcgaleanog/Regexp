<?php

if(isset($_GET['confir']))
{	
		$confirmacion2 = $_GET['confir'];
		if($confirmacion2==1)
		{
			foreach (glob("archivo/*") as $filename) {
			  @unlink($filename);
			}	
		}
		echo '<script language="JavaScript">window.location.href = "index.php"</script>';			
}	

//ruta del archivo PHP actual. Con dirname obtenemos la carpeta.
$ruta = dirname(__FILE__)."/archivo/";

//Vemos si hay algo en el GET
if (isset($_GET)){
    foreach($_GET as $campo=>$valor){
        switch ($campo) {
            //Obtenemos una ruta, carpeta o archivo
            case "una-ruta":
                $ruta = htmlspecialchars($valor, ENT_QUOTES);
                if (get_magic_quotes_gpc() == 1) $ruta = stripslashes($ruta);
                break;
            //Vemos la codificación
            case "una-codificacion":
                $codificacion = htmlspecialchars($valor, ENT_QUOTES);
                if (get_magic_quotes_gpc() == 1) $codificacion = stripslashes($codificacion);
                break;

        }
    }
}

//Si la ruta es vacía, pone la del presente script
if ($ruta == "") $ruta = dirname(__FILE__)."/archivo/";

//Esta variable contendrá la lista de nodos (carpetas y archivos)
$presenta_nodos = "";

//Esta variable es para el contenido del archivo
$presenta_archivo = "";

//Si la ruta es una carpeta, la exploramos. Si es un archivo
//sacamos también el contenido del archivo.
if (is_dir($ruta)){//ES UNA CARPETA
    //Con realpath convertimos los /../ y /./ en la ruta real
    $ruta = realpath($ruta)."/";
    //exploramos los nodos de la carpeta
    $presenta_nodos = explora_ruta($ruta);
} else {//ES UN ARCHIVO
    $ruta = realpath($ruta);
    //Sacamos también los nodos de la carpeta
    $presenta_nodos = explora_ruta(dirname($ruta)."/");
    //Y sacamos el contenido del archivo
    $presenta_archivo = '<br/><p align="center">CONTENIDO DEL ARCHIVO: </p><br />'.'<table width="600" height="158" border="1" align="center">
      <tr >
        <td style="width:800">'.explora_archivo($ruta, "UTF-8")."</td>
      </tr>
    </table>"."";
}
//Función para explorar los nodos de una carpeta
//El signo @ hace que no se muestren los errores de restricción cuando
//por ejemplo open_basedir restringue el acceso a algún sitio
function explora_ruta($ruta){
    //En esta cadena haremos una lista de nodos
    $cadena = "";
	    $valor1 = "";
		$valor = "";
    //Para agregar una barra al final si es una carpeta
    //$barra = "";
    //Este es el manejador del explorador
    $manejador = @dir($ruta);
	$valor1 .="<h3>Listado de Archivos cargados</h3>";
	 $valor1 .= '<TABLE BORDER=1 CELLSPACING=1 CELLPADDING=1 align="center">
			<TR>
	<td width="180" align="center" valign="middle" bordercolor="#000033" bgcolor="#e03b40"><div align="center"><span style="color:#FFF">Archivo</span></div></td> 
 <td width="210" align="center" valign="middle" bordercolor="#000033" bgcolor="#e03b40"><div align="center"><span style="color:#FFF" >Generar Resultados ExpReg</span></div></td>
 </TR>';  
    while ($recurso = $manejador->read()){
        //El recurso sera un archivo o una carpeta
        $nombre = "$ruta$recurso";

       //Vemos si el recurso existe y se puede leer

        if (@is_readable($nombre) && !@is_dir($nombre)){
	        
			//$cadena .= "ARCHIVO: ";
           
		    $cadena = "<a href=\"".$_SERVER["PHP_SELF"].
            "?una-ruta=$nombre\">$recurso</a>";
		    $valor1 .= "<tr>"."<td bgcolor='#ffffff'><div align='left'><span>$cadena</span></div></td>";
			//$valor ="   <input type=button name=Modificar value=Evaluar  onClick=javascript:Modificar2('gramaticas/Resultados.html?codigo=$recurso',700,500)>";
			$valor ="   <input type=button name=Modificar value=Evaluar  onClick=javascript:Modificar2('generarGramatica.php?codigo=$recurso',750,600)>";
			 $valor1 .="<td bgcolor='#ffffff'><div align='center'><span>$valor</span></div></td>"."</tr>"; 
	        $cadena = $valor1;
			//$cadena .= "<br />";
			//$cadena .= "<br />";
        }
    }
    $manejador->close();
	$cadena .= "</TABLE>";
    return $cadena;
}

//Función para extraer el contenido de un archivo
function explora_archivo($ruta, $codif){
    //abrimos un buffer para leer el archivo
    ob_start();
    readfile($ruta);
    //volcamos el buffer en una variable
    $contenido = ob_get_contents();
    //limpiamos el buffer
    ob_clean();
    //retornamos el contenido después de limpiarlo
    //aplicando la codificación seleccionada
    return htmlentities($contenido, ENT_NOQUOTES);
}

?>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Demo Expresiones Regulares</title>
<script type="text/javascript" src="uploader.js" ></script>
    <style type="text/css">
    body strong {
	font-size: 24px;
	color: #FFF;
	font-style: normal;
	font-variant: normal;
	background-color: #C00;
	margin: 0px;
	padding-top: 100px;
	padding-right: 100px;
	padding-bottom: 20px;
	padding-left: 100px;
}
    </style>
</head>
    <style>
    h3 {
	color: #009
}
    p {color: #00F; margin: 2px; padding: 2px;}
    #PRINCIPAL {
	font-size: 24px;
	color: #F00;
}
    .nueva {
	color: #C03;
	font-size: 24px;
	font-weight: bold;
}
    h4 {
	color: #063;
	font-size: 18px;
}
    .pob {
	font-weight: bold;
}
    .conf {
	font-size: 22px;
	font-weight: bold;
	color: #009;
}
    </style>
    
<body>
<div align="center" style="width: auto; color: #C00; font-size: 24px; font-weight: bold;" id="pureba">   


<p>
<strong>Demo Carga de Expresiones Regulares</strong>
</p> 
  

<form action="<?php echo $_SERVER["PHP_SELF"] ?>" method="get">
</form>

<p>
  <?php
    // Carpeta donde se guardan los archivos subido
    $upDir = "archivo/";
    
    //    Incluimos Clase
    require_once("ajaxCargarArchivo.php");
    
    //    Creamos Objeto
    $Archivo = new AjaxFileuploader($upDir);
    
    // Escaneamos los archivos en el servidor
    $archivo = $Archivo->scanDir();
    
    //foreach ($archivo as $nombre_archivo)
      //  print '<p>'.$upDir.'<b>'.$nombre_archivo.'</b></p>';
    
    
    //print '<br><br><p>Seleccione el archivo a Revisar</p>';
    
        // Formulario de subida 1
        print $Archivo->showFileUploader('id1');

        // Formulario de subida 2
       // print $Archivo->showFileUploader('id2');
    
?>
</p>

    <table width="643" border="0">
      <tr>
        <td colspan="3" class="conf" align="center">Parámetros de ejecución
        <input name="confir" type="hidden" id="confir" size="40" maxlength="20" value="<?PHP echo $confir; ?>" /></td>
      </tr>
      <tr>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td width="312" height="33" align="center" class="nueva">Ingrese el valor a Buscar</td>
        <td width="262"><label for="poblacion7" class="pob">Tamaño de la población</label></td>
        <td width="55"><select name="poblacion" id="poblacion">
          <option value="5" selected="selected">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
          <option value="30">30</option>
          <option value="40">40</option>                   
          <option value="50">50</option>
        </select></td>
      </tr>
      <tr>
        <td rowspan="2" align="center"><input type="text" name="buscarV" id="buscarV"></td>
        <td height="30"><label for="poblacion8" class="pob">Máxima generaciones</label></td>
        <td><select name="generaciones" id="generaciones">
          <option value="1" selected="selected">1</option>
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
          <option value="30">30</option>
          <option value="40">40</option>
        </select></td>
      </tr>
      <tr>
        <td height="35"><label for="poblacion9" class="pob">Tamaño del cromosoma en codones</label></td>
        <td><select name="cromosoma" id="cromosoma">
          <option value="7" selected="selected">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option value="10">10</option>
          <option value="11">11</option>
          <option value="12">12</option>
          <option value="13">13</option>                    
        </select></td>
      </tr>
      <tr>
        <td height="35" colspan="3" align="center">
<input  type='button' name='Limpiar' id='Limpiar' value='Limpiar' onClick=<?php 
/*
	foreach (glob("archivo/*") as $filename) {
  	 //echo "$filename size " . filesize($filename) . "\n";
  	 @unlink($filename);
	}*/
print "javascript:hacersubmit2()"; ?> >

		</td>
      </tr>
    </table> 
    <p>
      <?php
       echo "$presenta_nodos";
        echo "$presenta_archivo";
    ?>
</div>
</body>
</html>
<script language="javascript">
function Modificar2(url,ancho,alto)
{
	
	if(document.getElementById("buscarV").value == "")
		alert('Ingrese un valor de busqueda');
	else
	{
		var palabra
		palabra=confirm("Esta seguro de ver los Resultados")
		if(palabra)
		{
			var opciones="toolbar=0,location=1,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width="+ancho+",height="+alto;
			var Nueva_ventana;
			var nombre="Resultados";
			var buscar=document.getElementById("buscarV").value;
			var pobla=document.getElementById("poblacion").value
			var gene=document.getElementById("generaciones").value
			var cromo=document.getElementById("cromosoma").value
			
			url=url+"&bus="+String(buscar)+"&pob="+String(pobla)+"&gen="+String(gene)+"&crom="+String(cromo);

//			alert("el valor es: "+document.getElementById("generaciones").value+"url "+url);
			
			Nueva_ventana = window.open(url,nombre,opciones); 
			Nueva_ventana.moveTo(120,70); 
		}	
	}
}

function hacersubmit2()
{
	//document.getElementById("confir2").value=1
	window.location.href = "index.php?confir=1";

}
</script>