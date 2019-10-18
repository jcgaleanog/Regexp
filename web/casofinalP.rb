require 'benchmark'
#Este metodo permite realizar el cruce de los padres en la reproduccion de los cromosomas
def cruce(padre1, padre2, codon, pcruce)
  return ""+padre1[:cadenabits] if rand()>=pcruce
  cut = rand([padre1[:cadenabits].size, padre2[:cadenabits].size].min/codon)
  cut *= codon
  p2size = padre2[:cadenabits].size
  val=padre1[:cadenabits][0...cut]+padre2[:cadenabits][cut...p2size]
  return val
end

#Este metodo permite realizar la mutacion de los valores del cromosoma en bits
def mutacion(cadenabits, rate=1.0/cadenabits.size.to_f)
  hijo = ""
  cadenabits.size.times do |i|
    
    if i<=10 
      val=rand(cadenabits.size)
      bit = cadenabits[val].chr
      hijo << ((rand()<rate) ? ((bit=='1') ? "0" : "1") : bit)
    else
      bit = cadenabits[i].chr
      hijo<< bit
    end
  end
  return hijo
end

#Este metodo nos permite generar la reproduccion de los cromosomas
def reproducion(seleccion, poblacion, pcruce, codon)
  hijos = []
  seleccion.each_with_index do |p1, i|
    p2 = (i.modulo(2)==0) ? seleccion[i+1] : seleccion[i-1]
    p2 = seleccion[0] if i == seleccion.size-1
    hijo = {}
    hijo[:cadenabits] = cruce(p1, p2, codon, pcruce)
    hijo[:cadenabits] = mutacion(hijo[:cadenabits])
    hijos << hijo
    break if hijos.size == poblacion
  end
  return hijos
end


#Este metodo maneja la seleccion de los mejores valores evaluados y escoge los mejores cromosomas
def torneo_mejores(pop)
  i, j = rand(pop.size), rand(pop.size)
  j = rand(pop.size) while j==i
  return (pop[i][:fitness] < pop[j][:fitness]) ? pop[i] : pop[j]
end

#Metodo que permite generar el cromosoma en bits
def random_cadenabits(num_bits)
  valor=[]
  valor=(0...num_bits).inject(""){|s,i| s<<((rand<0.5) ? "1" : "0")}
  return valor
end

#Metodo que permite decodificar el cromosoma en bits a un cromosoma en numero decimales 
#Todo depende del tamaño del codon  es decir codon=5  son numeros de 5 bits, el numero maximo es 31
def decode_Cromosoma(cadenabits, codon)
  ints = []
  (cadenabits.size/codon).times do |off|
    codonP = cadenabits[off*codon, codon]
    codonP.reverse!
    sum = 0
    codonP.size.times do |i|
      sum += ((codonP[i].chr=='1') ? 1 : 0) * (2 ** i);
    end
    ints << sum
  end
  
  $generaHtml << '<p>Valor de la Cromosoma:' << ints.to_s << '</p>'
  $generaHtml<< "<p>" << "Valor del Cromosoma en bit:" << "</p>"<<"<p>"<< cadenabits.to_s << "</p>"
  
  return ints
end


#Metodo que permite generar la Expresion regular
def generarExp(gramaticaE, valEntero, max_pro)
  done, offset, depth = false, 0, 0
  symbolic_string = gramaticaE["S"]
  cont3=-1
  $generaHtml<< '<tr><td>'<< "Gramatica" << '</td><td>' << gramaticaE.to_s << '</td></tr>'
  begin
    done = true
    cont3+=1
    gramaticaE.keys.each do |key|
        symbolic_string = symbolic_string.gsub(key) do |k|
          done = false
          set = ((k=="Aval1" && depth>=max_pro-1) || (k=="Fval2" && depth>=max_pro-1))  ? gramaticaE["Gval1"] : gramaticaE[k]
              
          generado = valEntero[offset].modulo(set.size)
          offset = (offset==valEntero.size-1) ? 0 : offset+1
          $generaHtml<< '<tr><td>'<< cont3.to_s << '</td><td>' << symbolic_string.to_s << '</td></tr>'
          set[generado]
      end
    end
    depth += 1
  end until done
  symbolic_string=symbolic_string.gsub(" ","")
  return symbolic_string
end

#Metodo que permite generar la maxima producion de una Expresion Regular
#sirve para determinar el numero de hallazgos o concidencias de la ExpReg
#y con este valor se determina el valor de error de la expresion generada
def funcionPrueba(textoB,rangoCar)
    string = cargar_archivo_p 
    
    cadenaExp= '/('+textoB+')/'  #Expresion Regular
    
    num_expr=cadenaExp.gsub("/","")
    num_expr=num_expr.gsub(" ","")
    num_expr = Regexp.new (num_expr) # expresión regular 
    
    resultado =[]
    posiciones =[]
    indi=-1
    pos=0
    
    #Permite buscar todas los valores en la expresion y determinar la posicion donde se encuentran
    while indi
        encontrados=num_expr.match(string[(indi+1)..-1])
        pos += (num_expr=~string[(indi+1)..-1]).to_i
        pos=1+pos.to_i
        break unless encontrados
        indi +=encontrados.begin(0)+1
        resultado<< encontrados.to_s
        posiciones<< pos.to_i
    end    
  return resultado.size
end

#Metodo que maneja los valores del rango de la expresion
#El rango es un conjunto de caracteres no repetitivos
def rangoCaracteres()
  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  tam_rango=rand(6)+1
  string = (0...tam_rango).map { o[rand(o.length)] }.join
  return string
end

#Metodo que maneja los valores en los rango de la expresion
#El rango 1 debe ser menor al rango 2
def rangoParametrizado()
  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  tam_rango=rand(1)+1
  string = (0...tam_rango).map { o[rand(o.length)] }.join
  string2='a'

  while !(string <= string2)
    string2 = (0...tam_rango).map { o[rand(o.length)] }.join  
  end
  
  return string, string2
end

#Metodo que genera los valores en los rango de la expresion
#El numero 1 debe ser menor al numero 2

def rangoNumeros()
  o = [('1'..'9')].map(&:to_a).flatten
  o2 = [('1'..'10')].map(&:to_a).flatten
  tam_rango=rand(1)+1
  numero1 = (0...tam_rango).map { o[rand(o.length)] }.join
  numero2='1'
  
  while numero1 > numero2
    numero2 = (0...tam_rango).map { o2[rand(o2.length)] }.join  
  end
  
  return numero1 , numero2
end

#Este metodo permite el valor que se va ha evaluar en la expresion regular
#se puede ingresar por un documento externo o por medio de teclado con la funcion gets
def valorBuscarExpReg()
  
lineas=File.readlines("buscar.txt")
valorBuscar=""
  lineas.each do |id|
    valorBuscar+= id.to_s
end
  return valorBuscar
end

#Metodo que permite cargar el archivo de textos de prueba
#En este caso se puede cargar cualquier tipo de archivo (txt, html, jason, php, etc)
def cargar_archivo_p()
  lineas=File.readlines("pruebas.txt")
  archivo=""
  lineas.each do |id|
    archivo+= id.to_s
  end
  return archivo
end


#Metodo que evalua el rendimiento o aptitud de los valores de los cromosma considerando
#los valores esperados de los resultados de evaluacion de cada gramatica
def resultadosMostrados(program, pruebasCromo=1)
  return 0 if program.strip == "Cadena"
  sum_error = 0.0
  result = 0.0
  cont=0
  pruebasCromo.times do
    cont+=1
    textoBus = valorBuscarExpReg()
    rangoPa=""
    expresion=""
    #Esta parte Maneja los valores parametrizados de un Rango [Rango1-Rango2]
    while ((program.strip.include?("Caracter1")) || (program.strip.include?("Caracter2")))
       #$generaHtml<< '<tr><td>Entro 1 Bien' << '</td></tr>' << '<br />'
       rangoPa=rangoParametrizado()
       program = program.sub("Caracter1",rangoPa[0])
       program = program.sub("Caracter2",rangoPa[1]+" ")       
    end
    
    #En esta parte se maneja los valores cuando hay un rango en la expresion [Rango]
    rangoCar=""
    if (program.strip.include?("Caracteres")) 
       rangoCar=rangoCaracteres()
       program=program.gsub("Caracteres", rangoCar.to_s)
    end
    
    #En esta parte se maneja los valores cuando hay un rango de numero en la expresion {num1-num2}
    rangoNum=""
    if (program.strip.include?("num1")) || (program.strip.include?("num2"))
       rangoNum=rangoNumeros()
       program=program.gsub("num1", rangoNum[0].to_s)
       program=program.gsub("num2", rangoNum[1].to_s)
    end
    
    expresion = program.gsub("Cadena", textoBus.to_s)
    string = cargar_archivo_p
    expresion=expresion.gsub("/","")
    num_expr = Regexp.new (expresion) # expresión regular 

    resultado =[]
    posiciones =[]
    indi=-1
    pos=0
    cont2=0

    while indi
        encontrados=num_expr.match(string[(indi+1)..-1])
        pos += (num_expr=~string[(indi+1)..-1]).to_i
        pos=1+pos.to_i
        break unless encontrados
        indi +=encontrados.begin(0)+1
        if (encontrados.to_s != "") 
          resultado<< encontrados.to_s
          valorP=pos.to_i
          posiciones<< valorP.to_i        
        end 
    end

    cont2+=1    
    tamExp=0
    
    $generaHtml3<< '<tr><td>Expresión regular: '<< num_expr.to_s << '</td></tr>'
    $generaHtml3<< '<tr><td>Encontrados: ' << resultado.to_s << '</td></tr>'
    $generaHtml3<< '<tr><td>Posiciones de los valores encontrados ' << posiciones.to_s << '</td></tr></table>'
  
    begin puntos = resultado.size.to_f rescue puntos = 0.0/0.0 end
    
   
    if puntos.to_f > 0
        tamExp=num_expr.to_s.size
    end

    return 0 if puntos.nan? or puntos.infinite?
    sum_error += (puntos+tamExp.to_f)
    result=puntos.to_s
    
  end
    if sum_error.to_f < 0
        sum_error=0
    end
  return (sum_error)
end



#Metodo que evalua el rendimiento o aptitud de los valores de los cromosma considerando
#los valores esperados de los resultados de evaluacion de cada gramatica
def valorAptitud(program, pruebasCromo=5)
  return 0 if program.strip == "Cadena"
  sum_error = 0.0
  result = 0.0
  cont=0
  pruebasCromo.times do
    cont+=1
    $generaHtml<< '<p>Pruebas #: '<< cont.to_s << '</p>'
    textoBus = valorBuscarExpReg()
    rangoPa=""
    expresion=""
    #Esta parte Maneja los valores parametrizados de un Rango [Rango1-Rango2]
    while ((program.strip.include?("Caracter1")) || (program.strip.include?("Caracter2")))
       rangoPa=rangoParametrizado()
       program = program.sub("Caracter1",rangoPa[0])
       program = program.sub("Caracter2",rangoPa[1]+" ")       
    end
    
    #En esta parte se maneja los valores cuando hay un rango en la expresion [Rango]
    rangoCar=""

    if (program.strip.include?("Caracteres")) 
       rangoCar=rangoCaracteres()
       program=program.gsub("Caracteres", rangoCar.to_s)
    end
    
    #En esta parte se maneja los valores cuando hay un rango de numero en la expresion {num1-num2}
    rangoNum=""

    if (program.strip.include?("num1")) || (program.strip.include?("num2"))
       rangoNum=rangoNumeros()
       program=program.gsub("num1", rangoNum[0].to_s)
       program=program.gsub("num2", rangoNum[1].to_s)
    end
    
    expresion = program.gsub("Cadena", textoBus.to_s)
    string = cargar_archivo_p
    expresion=expresion.gsub("/","")
    num_expr = Regexp.new (expresion) # expresión regular 

    $generaHtml<< '<tr><td>Rendimiento en tamaño de la derivacion: ' << program.size.to_s << '</td></tr>'

    resultado =[]
    posiciones =[]
    indi=-1
    pos=0
    cont2=0

    while indi
        encontrados=num_expr.match(string[(indi+1)..-1])
        pos += (num_expr=~string[(indi+1)..-1]).to_i
        pos=1+pos.to_i
        break unless encontrados
        indi +=encontrados.begin(0)+1
        if (encontrados.to_s != "") 
          resultado<< encontrados.to_s
          valorP=pos.to_i
          posiciones<< valorP.to_i        
        end 
    end

    cont2+=1
    tamExp=0    
    $generaHtml<< '<p>Expresión regular: '<< num_expr.to_s << '<br /> <br />'
    $generaHtml<< '<p>Los Valores entrenamiento: '<< cont2.to_s << '<br />'
    $generaHtml<< '<table width="440" height="132" border="1">'
    $generaHtml<< '<tr><td>Encontrados: ' << resultado.to_s << '</td></tr>'
    $generaHtml<< '<tr><td>Posiciones de los valores Encontrados ' << posiciones.to_s << '</td></tr>'
    
    begin puntos = resultado.size.to_f rescue puntos = 0.0/0.0 end
    
    $generaHtml<< '<tr><td>Putuación de Rendimiento: ' << puntos.to_s << '</td></tr>'
   
    if puntos.to_f < 0
        tamExp=num_expr.to_s.size
    end

    return 0 if puntos.nan? or puntos.infinite?
    sum_error += (puntos+tamExp.to_f)
    result=puntos.to_s
    $generaHtml<< '<tr><td>Valor Total de diferencia de Error: ' << sum_error.to_s << '</td></tr>' << '</table>'
    
  end
    if sum_error.to_f < 0
        sum_error=0
    end
  return (sum_error)
end

#Metodo que permite Evaluar todos los parametro utilizados en la generacion de la Expresion Regular
def evalucion_R(candidata, codon, gramaticaE, max_pro)
  #Valor para la codificacion del cromosoma para valores enteros
  candidata[:valEntero] = decode_Cromosoma(candidata[:cadenabits], codon)
  $generaHtml<< '<p>Produciones</p>'
  $generaHtml<< '<table width="600" height="161" border="1">'
  #condicionar las producciones
  valorResult=generarExp(gramaticaE, candidata[:valEntero], max_pro)
  
  if (valorResult.strip.include?"(Cadena)") 
    valorResult=""
  end 
  
    $mejorEva.each do |valor|
      if valor.include?(valorResult) 
          valorResult=""
      end
    end



  #Valores de las producciones generadas de las derivaciones de la GE
  candidata[:program] = valorResult
  $generaHtml<< '</table>'
  $generaHtml<< '<p>Expresión candidata:'<< candidata[:program] << '</p>'  

  #Asignacion para el valor resultado del entrenamiento de cada individuo

  if (valorResult=="") 
    candidata[:fitness] = 0
  else
    candidata[:fitness] = valorAptitud(candidata[:program])      
    if (candidata[:fitness].to_f > 0) 
      $generaHtml2<< '<td>'<< candidata[:fitness].to_s << '</td>'
      $generaHtml2 << '<td>' << valorResult.to_s << '</td></tr>'
    end
  end
end

#Metodo Principal que realiza todos los procesos para determinar el rendimiento de la ExpReg
#donde se aplican todos los concetos de computacion evolutiva para el manejo de Gramaticas
#evolutivas
def busqueda(max_gens, poblacion, codon, num_bits, pcruce, gramaticaE, max_pro )
    
    pop = Array.new(poblacion) {|i| {:cadenabits=>random_cadenabits(num_bits)}}
    $mejorEva=pop
    $generaHtml2 << '<p><strong style="color: #FF5533; font-size: 24px; text-align: center;">Producciones de la Población Iniciales ER</strong></p>'
    $generaHtml2 << '<p></p>' << '<table width="700" height="132" border="1">'
    $generaHtml2<< '<td>Valor resultado:</td>'
    $generaHtml2<< '<td>Expresion Generada</td></tr>'
    pop.each{|c| evalucion_R(c,codon, gramaticaE, max_pro)}
    $generaHtml2 << '</table>'
    $mejorEva = pop.sort{|x,y| x[:fitness] <=> y[:fitness]}.last
    $numGen=""
    max_gens.times do |gen|
    
    seleccion = Array.new(poblacion){|i| torneo_mejores(pop)}    
    hijos = reproducion(seleccion, poblacion, pcruce,codon)  
    $generaHtml2 << '<p><strong style="color: #FF5533; font-size: 24px; text-align: center;">Producciones de Expresiones Correctas</strong></p>'
    $generaHtml2 << '<p></p>' << '<table width="700" height="132" border="1">'  
    $generaHtml2<< '<td>Valor resultado:</td>'
    $generaHtml2<< '<td>Expresion Generada</td></tr>'
    hijos.each{|c| evalucion_R(c, codon, gramaticaE, max_pro)}
    $generaHtml2 << '</table>'

    hijos.sort!{|x,y| x[:fitness] <=> y[:fitness]}
    $mejorEva = hijos.last if hijos.first[:fitness] >= $mejorEva[:fitness]
    pop=(hijos+pop).sort{|x,y| y[:fitness]<=>x[:fitness]}.last(poblacion)
    
   
    $generaHtml << '<p><strong style="color: #FF5533; font-size: 24px; text-align: center;">Resultados Generado</strong></p>'
    $generaHtml << '<br />'
    $generaHtml << '<p></p>' << '<table width="440" height="132" border="1">'
    $generaHtml << '<tr><td>Generación: ' << gen.to_s << '</td></tr>'
    $generaHtml << '<tr><td>Mejor Diferencia de Puntuación: ' << $mejorEva[:fitness].to_s << '</td></tr>'
    $generaHtml << '<tr><td>Mejor Cromosoma en bits: ' << $mejorEva[:cadenabits].to_s << '</td></tr>'
    $generaHtml << '<tr><td>Mejor Cromosoma: ' << $mejorEva[:valEntero].to_s << '</td></tr>'
    $generaHtml << '<tr><td>Expresion Candidata: ' << $mejorEva[:program].to_s << '</td></tr></table>'

    $generaHtml2 << '<p><strong style="color: #FF5533; font-size: 24px; text-align: center;">Resultados Generado</strong></p>'
    $generaHtml2 << '<br />'
    $generaHtml2 << '<p></p>' << '<table width="440" height="132" border="1">'
    $generaHtml2 << '<tr><td>Generación: ' << gen.to_s << '</td></tr>'
    $generaHtml2 << '<tr><td>Mejor Diferencia de Puntuación: ' << $mejorEva[:fitness].to_s << '</td></tr>'
    $generaHtml2 << '<tr><td>Mejor Cromosoma en bits: ' << $mejorEva[:cadenabits].to_s << '</td></tr>'
    $generaHtml2 << '<tr><td>Mejor Cromosoma: ' << $mejorEva[:valEntero].to_s << '</td></tr>'
    $generaHtml2 << '<tr><td>Expresion Candidata: ' << $mejorEva[:program].to_s << '</td></tr></table>'

    $numGen=gen.to_s
  end
  return $mejorEva
end

if __FILE__ == $0
  
  
  gramaticaE = {
    "S"=>"Expresion",
    "Expresion"=>["Aval1"],
    "sim"=>['Cadena'],
    "RanX"=>['Caracteres'],
    "Rango1"=>['Caracter1'],
    "Rango2"=>['Caracter2'],
    "Min"=>['num1'],
    "Max"=>['num2'],
    "ReglaPre"=>['Aval2'],
    "ReglaPos"=>['Bval3'],
    
    "Aval1"=>['(Bval1','(Cval1'],
    "Bval1"=>['ReglaPre Dval1'],
    "Cval1"=>['sim Dval1'],
    "Dval1"=>['ReglaPos Eval1',')Fval1'],
    "Eval1"=>[')Fval1'],
    #{}"Fval1"=>['Gval1','|Aval1'],  #Revisar para que no hallan ciclos
    "Fval1"=>['Gval1'],  #Revisar para que no hallan ciclos
    "Gval1"=>[""],
    
    #Valores para las reglas Pre
    "Aval2"=>['Bval2','Cval2'],
    "Bval2"=>['^Dval2'],
    "Cval2"=>['.Cval2','.Dval2'],
    "Dval2"=>['sim Eval2'],
    "Eval2"=>['Fval2'],
    "Fval2"=>['Cval2','Gval1'],  #revisar Ciclo
    
    #Valores para las reglas Pos
    "Bval3"=>['Cval3'],
    #{}"Cval3"=>['[Dval3','Jval3','$Lval3','|Nval3','{Oval3','*Tval3','+Tval3','?Tval3'],
    "Cval3"=>['[Dval3','Jval3','$Lval3','{Oval3','*Tval3','+Tval3','?Tval3'],
    "Dval3"=>['^Eval3','Rango1 Fval3','RanX Kval3'],
    "Eval3"=>['Rango1 Fval3'],
    "Fval3"=>['-Gval3'],
    "Gval3"=>['Rango2 Hval3'],
    "Hval3"=>[']Jval3','Rango1 Fval3'],
    "Ival3"=>['Jval3'],  
    "Jval3"=>["Fval1"],  
    "Kval3"=>[']Jval3'],
    "Lval3"=>['Mval3'],
    "Mval3"=>['Fval1'], 
    "Nval3"=>['sim Cval3'],
    "Oval3"=>['Min Pval3'],
    "Pval3"=>[',Rval3','}Ival3'],
    "Rval3"=>['Max Sval3','}Ival3'],
    "Sval3"=>['}Ival3'],
    "Tval3"=>['Lval3'],  #revisar
    #{}"Tval3"=>['sim''Lval3','Lval3'],  #revisar
   
  }
 

  config=File.readlines("configuracion.txt")
  valorConf= Array.new
  cont=0
  config.each do |id|
      valorConf[cont]= id.to_s
      cont=cont+1
  end

 #Valores para configurar la generarcion de los cromosomas
  max_pro = valorConf[9].to_i #Maxima profundidad para el tamaño de las expresiones regulares
  max_gens = valorConf[3].to_i #Maximas Generaciones
  poblacion = valorConf[1].to_i #Tamaño de la población
  codon = valorConf[7].to_i #Valor del tamaño de bits que se van a tomar para generar los valores enteros
  genes=valorConf[5].to_i
  num_bits = genes*codon #Numero de bits y tamaño del cromosoma
  pcruce = valorConf[11].to_f #Porentaje de Cruce 
  $generaHtml="" 
  $generaHtml2="" 
  $generaHtml3="" 
  $configuracion="" 

  $configuracion << '<p><strong font-size: 23px; text-align: center;>Parámetros de configuración Inicial del Prototipo</strong></p>'
  $configuracion << '<p> <strong font-size: 18px;>Máxima profundidad de las derivaciones:  ' << max_pro.to_s
  $configuracion << '<br />Generaciones:                                  ' << max_gens.to_s
  $configuracion << '<br />Tamaño de la población:                        ' << poblacion.to_s
  $configuracion << '<br />Tamaño del codón:                              ' << codon.to_s
  $configuracion << '<br />Número de genes:                              ' << genes.to_s
  $configuracion << '<br />Numero de bits del cromosoma:                  ' << num_bits.to_s << '</strong></p><br />'

Benchmark.bm (7) do |x|
    
    x.report ("Duración:") {
    $mejorEva = busqueda(max_gens, poblacion, codon, num_bits, pcruce, gramaticaE, max_pro)
   
    $generaHtml << '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Prueba</title></head>'
    
    if ($mejorEva[:fitness].to_i == 0)

        $generaHtml << '<br />'
        $generaHtml << '<p><strong style="color: #11aF00; font-size: 30px; text-align: center;">Resultados Final</strong></p>'
        $generaHtml << '<br />'
        $generaHtml << '<p><strong style="color: #00aF00; font-size: 20px; text-align: center;">NO HAY EXP PARA ESTE CASO</strong></p>'
        $generaHtml << '<br />'
        
        $generaHtml3 << '<p><strong style="color: #11aF00; font-size: 30px; text-align: center;">Resultados Final</strong></p>'        
        $generaHtml3 << '<br />'
        $generaHtml3 << '<p><strong style="color: #FF0055; font-size: 20px; text-align: center;">NO HAY EXP PARA ESTE CASO</strong></p>'
        $generaHtml3 << '<br />'
        $generaHtml3 << '<br />'

    else
        $generaHtml << '<br/>'
        $generaHtml << '<p><strong style="color: #11aF00; font-size: 30px; text-align: center;">Resultados Final</strong></p>'
        $generaHtml << '<br/>'
        $generaHtml << '<p></p>' << '<table width="500" height="132" border="1">'
        $generaHtml << '<tr><td>Expresion Regular Generada: ' << '<br /> <br />' << $mejorEva[:program].to_s << '</td></tr></table>'

        $generaHtml3 << '<p><strong style="color: #11aF00; font-size: 30px; text-align: center;">Resultados Final</strong></p>'
        $generaHtml3 << '<p></p>' << '<table width="700" height="100" border="1">'
        $generaHtml3 << '<tr><td>Generación: ' << $numGen.to_s << '</td></tr>'
        $generaHtml3 << '<tr><td>Expresion Regular Final' << '<br /> <br />' << $mejorEva[:program].to_s << '</td></tr>'
        $generaHtml3 << '<tr><td>Mejor Diferencia de Puntuación: ' << $mejorEva[:fitness].to_s << '</td></tr>'
        $generaHtml3 << '<tr><td>Mejor Cromosoma en bits: ' << $mejorEva[:cadenabits].to_s << '</td></tr>'
        $generaHtml3 << '<tr><td>Mejor Cromosoma: ' << $mejorEva[:valEntero].to_s << '</td></tr>'

        resultadosMostrados($mejorEva[:program].to_s)

      end
    
    File.open("prueba.html","w") do |textos|
      textos << '<p><strong style="color: #06C; font-size: 24px; text-align: center;">Resultados de la Ejecución gramática evolutiva para ER</strong></p>'
      textos << $generaHtml << '</body> </html>'
    end

    $generaHtml2 << '</table>'
    File.open("Resultados.html","w") do |textos2|
      textos2 << '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>GexExp</title></head>'    
      textos2 << '<p><strong style="color: #06C; font-size: 24px; text-align: center;">Resultados de la Ejecución gramática evolutiva para ER</strong></p>'
      textos2 << $configuracion
      textos2 << $generaHtml3
      textos2 << $generaHtml2 << '</body> </html>'
    end

    system("./script1", "argX")}

  end
end
