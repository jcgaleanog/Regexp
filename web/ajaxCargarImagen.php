<?php
    // Copia el archivo temporal al archivo en el server
    // en $dir se especifica directorio de escritura.
    $dir = 'archivo/';
    if (isset($_POST['id'])) {
        if (!copy($_FILES[$_POST['id']]['tmp_name'], 'archivo/'.$_FILES[$_POST['id']]['name']))
            print '<script> alert("Error al Subir el Archivo");</script>';
    }
    else
	 {
        print "El archivo se Almaceno.";
	}
		
		
?> 