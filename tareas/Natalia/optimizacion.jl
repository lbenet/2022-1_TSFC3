export minimiza, maximiza

#midpoint 


"""
      midpoint(I)
Esta función toma los extremos de un intervalo I y te devuelve el punto medio. 

Ejemplo: midpoint(Intervalo(a,b) ) =(a+2)/2
"""
function midpoint(I::Intervalo)
   m = (I.supremo + I.infimo)/2 
return m 
end 

# bisecta 
function bisecta(dom::Intervalo)
    return Intervalo(dom.infimo,midpoint(dom)), Intervalo(midpoint(dom),dom.supremo)
end

#bisecta2
function bisecta2(D)
	for _ in eachindex(D)
		dom = popfirst!(D) 
		append!(D, bisecta(dom))
	end
	return D
end

"""
		PSuvInt(f, I)
Esta función se encarga de tomar una función "f" y un vector de intervalos "I" de entrada para regresarnos un arreglo de puntos. 
Dicha función iterara sobre los elementos de "I" para justamente checar la longitud del arreglo y posteriormente calcular el la imagen de "f" en el punto medio del intervalo del "l-esimo" valor que vaya iterando en I (Recordemos que es un vector de intervalos). 
PSuvInt = Puntos de los Sub-Intervalos
f = Función
I = Vector de Intervalos o vector de subintervalos

Ejemplo: PSuvInt(x^2, I = (Intervalo(1,2), Intervalo(2,3) ) ) = ( f( (1+2)/2 ), f( (2+3)/2) )

"""
function PSuvInt(f, dom)  #Esta función nos devolvera los puntos asociados a cada 
						#subintervalo de la partición
	m = length(dom)  #Verificamos la longitud de los subintervalos que cumplen 		
				   #la tolerancia 
	PSuvInt = ones(m) #Creamos la lista de unos
	for l in 1:m #Iteramos sobre el numero de elementos del vector de intervalos
		PSuvInt[l] = f(midpoint(dom[l])) #Devolvemos la imagen de f
						 #con el valor medio del 
						 #"l-esimo" elemento de "I"
	end
	
	return PSuvInt #Regresamos este nuevo arreglo de puntos medios correspondientes a 					 
		       #los elementos de "I" evaluados evaluados en "f"
end


"""
	minimiza(f, I, tol)

Encuentre el intervalo o los intervalos que contiene el mínimo de la función "f" en el intervalo inicial ingresado "I", hasta que el rango o la longitud de dicho intervalo que contenga el minimo cumpla una condición de tolerancia que ofrece la función para ingresar como "tol". De esta manera la función minimiza garantiza con cierta tolerancia donde vive el minimo.

Entrada: f - Función, I - Intervalo de tipo intervalo, tol - Tolerancia

Salida: Intervalos - Vector de intervalos o vector de tipo intervalos

Ejemplo: 
minimiza(f = x^2, I = Intervalo(-15, 9), tol = 1/1024) = Intervalo( 0.0 ,0.0 )

Dicha función utiliza subdivide() para particionar el intervalo en sub intervalos. 
"""
function minimiza(f, dom::Intervalo, tol=1/1024)
		
	v_candidatos= [dom] #Inicialmente sabemos que existe un minimo en ese intervalo
			    #Asi que definimos el intervalo donde vive el minimo como
			    #"Intervalos" dado que despues se fragmentara para encontrar 
			    #varios minimos y ver cual infimo de todos ellos es el menor de
			    #todos
	while true 
			
		dom1 = bisecta2(v_candidatos)#Subdividimos el intervalo y eso lo guardamos
					     #en partición dado que ahora tenemos un vector
					     #de intervalos para ver el minimo de cada uno
			
		n = length(dom1)  		#Checamos el numero de elementos que tiene 
		                                #nuestra subintervalos o la
						#partición para iterar sobre esos elementos.
							 
		sups = ones(n);   infs = ones(n)   #Definimos listas donde iremos guardando la
						   #información de los valores que tomen los 
						   #supremos y minimos de cada subintervalo o 
						   #cada elemento de la partición.
						   #Dichas listas tienen dimensión "n" dado 
						   #que corresponderia al numero de supremos e
						   #infimos asociados al numero de elementos 
						   #de la partición. Y le ponemos ceros dado
						   #se iran agregando valores a las mismas.
			
		for j in 1:n #iteramos sobre el numero de subintervalos
			     #Como cada elemento de la partición tiene asociado un supremo y este orden
			     #Lo denotamos con la dimensión del arreglo de "supremos" e "infimos"
				
			sups[j] = f(dom1[j]).supremo #Agregamos el supremo "j-esimo" a la lista
						     #de supremos correspondiente al elemento 
						     #"j-esimo" de la partición generada por 
						     #"subdivide"
				
			infs[j] = f(dom1[j]).infimo  #Agregamos el infimo "j-esimo" a la lista
						     #de infimos correspondiente al elemento 
						     #"j-esimo" de la partición generada por 
						     #"subdivide" 
		end
			
		Min_sup = minimum(sups) #Tomamos el minimo de los supremos dado que cada 
					#cada vez que hacemos una subdivisión, un supremo
					#se vuelve el minimo de la partición que sigue
					#tambien para solo agregar a la lista de posibles 
					#candidatos los valores menores al minimo de los 
					#supremos, es decir descartamos los intervalos donde
					#el infimo "k-esimo" sea mayor que el minimo de los 
					#supremos
			
		PC = Vector{Intervalo}() #Creamos una lista donde guardaremos los nuevos 
					 #Posibles Candidatos, debe ser del tipo vector{Intervalo}
			
		#Iteramos sobre el numero de elementos de la partición. para agregar a los 
		#candidatos que sumplen el siguiente criterio.
			
		for k in 1:n  #iteramos sobre el numero de elementos de la partición.
				
			if infs[k] < Min_sup #Si se cumple que el menor de los infimos "j-esimo"
					     #es menor que el minimo de los supremos de esta
					     #forma descartamos los casos "j-esimos" donde el 
					     #infimo "j-esimo" es mayor que el minimo de los 
					     #supremos. Tambien cheque que el minimo de los
					     #intervalos es el segundo infimo mas pequeño de todos
					
				append!(PC, dom1[k]) #Si se sumple agregamos el elemento "k-esimo" de 
						     #la iteración a la lista vacia que contendra a los 
						     #posibles candidatos.
			end
				
		end
		v_candidatos = PC   #Ya con los candidatos, los sustituimos por "intervalos" que
				    #son justo los valores que subdividiamos para encontrar el 
				    #el minimo. 
			
		#Checamos que el tamaño del intervalo que es candidato a ser el minimo es tan
		#pequeño como la tolerancia que definimos en la funcion
			
		P0 = v_candidatos[1]   # Checamos para un elemento del nuevo intervalo a 
				       #subdividir (si es el caso) y si un elemento cumple la 
				       #tolerancia se termina el ciclo.
				       #Definimos un elemento de intervalos solo para checar su
				       #longitud
			
		if diam(P0) < tol #Checamos la longitud del intervalo
				  #para ver si es menor que la tolerancia
			PSuvIn = PSuvInt(f, v_candidatos)
				
			return v_candidatos, PSuvIn	
		end
			
	end
end

"""
	maximiza(f, I, tol)

Encuentre el intervalo o los intervalos que contiene el maximo de la función "f" en el intervalo inicial ingresado "I", hasta que el rango o la longitud de dicho intervalo que contenga el minimo cumpla una condición de tolerancia que ofrece la función para ingresar como "tol". De esta manera la función maximiza garantiza con cierta tolerancia donde vive el maximo.

Entrada: f - Función, I - Intervalo de tipo intervalo, tol - Tolerancia

Salida: Intervalos - Vector de intervalos o vector de tipo intervalos

Ejemplo: 
maximiza(f = x^2, I = Intervalo(-15, 9), tol = 1/1024) = Intervalo(-15)

Dicha función utiliza subdivide() para particionar el intervalo en sub intervalos. 
"""
function maximiza(f, dom::Intervalo, tol=1/1024)
	v_candidatos = [dom]
	while true
	dom1 = bisecta2(v_candidatos)
	L = length(dom1)   
	sups = ones(L)
	infs = ones(L)
	for n in 1:L
		sups[n] = f(dom1[n]).supremo
		infs[n] = f(dom1[n]).infimo
	end
	INF = maximum(infs)
	V = Vector{Intervalo}()
	for j in 1:L
		if INF < sups[j]
		 	append!(V, dom1[j])
		end
	end
	v_candidatos = V   
	I1 = v_candidatos[1]  
	if diam(I1) < tol
		F1 = PSuvInt(f, v_candidatos)
			return v_candidatos, F1
		end
	end
end
