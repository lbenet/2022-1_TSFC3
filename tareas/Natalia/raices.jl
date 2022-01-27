
export Raiz, ceros_newton

"""
   Estructura Raiz
   La estructura Raiz define a un vector o "arreglo" el cual consiste de dos entradas
   la primera es: 
   -raiz la cual es de tipo Intervalo 
   -unicidad la cual es de tipo booleano e indicara si se cumple en esta componente 
   la unicidad
"""

struct Raiz #Definimos la estructura Raiz
	raiz::Intervalo; unicidad::Bool #Toma dos entradas, la primera definida como
                                  #raiz 
end #Fin

#Operador de Newton intervalar utilizando la división extendida 

"""
   Función Newton con división extendida
   La función "N_divext" calcula la derivada de f en el "dominio", despues calcula
   el punto medio del intervalo introducido ("dom") y posteriormente realiza la 
   resta de ese punto medio con la división extendida de "f(m)" con "f´(m)".
   Dicha función consta de 3 parametros: 
   -El primero es "f", el cual es la función a la cual se le hara este proceso detallado
   anteriormente
   -El segundo es el dominio o el intervalo donde se aplicara esta función "N_divext"
"""
function N_divext(f, dom) #Definimos la función N_divext
    f′ = ForwardDiff.derivative(f, dom) #Calculamos la derivada de "f" evaluada en dom
    m = mid(dom) #Calculamos el punto medio de "dom"
    Nm = m .- [division_extendida(f(m), f′)...] #Definimos el resultado que es un 
                                                #vector de intervalos el cual hace la resta
                                                #del punto medio con la div extendida de "f(m)" con
                                                #"f´(m)" 
                                                #Lo definimos Nm dado que se calcula el proximo intervalo
                                                #donde se aplica el metodo clasico de Newton 
                                                #para calcular el siguiente punto para la sucesión de la 
                                                #raiz
    return Nm #Nos regresa el nuevo intervalo el cual viene siendo una suceción de intervalos 
              #que convergen a la raiz.
end


#NEWTON INTERVALAR 

"""
   Función Newton 
   La función Newton aplica el metodo de Newton-Raphon a intervalos. Dicha función
   consta de tres variables: 
   -La primera es el vector de intervalos donde se quiere ver si hay ceros o raices
   -La segunda es la función a la cual se le aplicara el metodo de Newton
   -La tercera es la tolerancia con la que se calcularan las raices. 
"""

function Newton!(v_candidatos, f, tol)

    for _ in eachindex(v_candidatos) #Checamos cada vector de "v_candidatos" 
                                     #(vector de intervalos)
	dom = popfirst!(v_candidatos) #Extrae y borra la primer entrada de "v_candidatos" a "dom"
                vf = f(dom) #le asignamos a "vf" el valor que adquiere f evaluada en "dom"
	0 ∉ vf && continue #Si no hay un cero el la imagen del dominio que consideramos como candidato
                     #continua y sino continua lo siguiente
	if diam(dom) < tol #Como la raiz tiene una tolerancia checamos que el diametro sea menor que la 
                     #tolerancia asignada
                	push!(v_candidatos, dom) #Se incluye a `dom` (al final de `v_candidatos`)
                else #En caso contrario hacemos
	n0ext = N_divext(f,dom) #Definimos 
		for n0 in n0ext #iteramos sobre cada valor que adquiera n0ext
			dom1 = n0 ∩ dom #el nuevo dominio sera la intersección de n0 con dom
			append!(v_candidatos, dom1) 
		end
        end
    end
    return nothing
end

# Función Newton2 

""" 
  Función Newton 
  La función Newton2 es la implementación del metodo de Newton-Raphson el cual 
  esta aplicado a intervalos. Dicha función tiene tres parametros:
  -El primero de ellos es la función a la cual se le aplica el metodo. 
  -El segundo es el intervalo donde se verificara si vive una raiz. 
  -El tercero es la tolerancia con la cual se define el tamaño del intervalo donde
  vive la raiz buscada.

"""
function Newton2(f, dom::Intervalo, tol) #Definimos la función del metodo de Newton
    bz = !(0 ∈ f(dom)) #Definimos un booleano el cual se define sino esta la raiz
                       #en la función evaluada en el dominio.
    v_candidatos = [dom]  #Definimos el vector de intervalos en los cuales viviran
                          #las posibles raices de la función. 
	
    while !bz #Como bz adquiere un False si el cero esta en la función evaluada en 
              #el posible dominio donde esta la raiz. Mientras sea verdadero o se
              #cumpla lo anterior se realiza lo siguiente.
        Newton!(v_candidatos, f, tol) #Aqui aplicamos el metodo de Newton a cada 
                                      #candidato 
        bz = maximum(diam.(v_candidatos)) < tol #Definimos ahora a bz como el booleano que 
                                                #verifica la comparación del maximo
                                                #diametro de los posibles candidatos
                                                #con la tolerancia  que la tolerancia
                                                #de esta manera cuando el diametro maximo
                                                #sea mas pequeño que la tolerancia, se deja
                                                #de aplicar Newton. #AhPrroo
    end

    #Filtra los intervalos que no incluyan al 0
    vind = findall(0 .∈ f.(v_candidatos)) #A "vind" le asignamos todos los indices que
                                          #cumplen tener un cero en la función evaluada en 
                                          #"v_candidatos" y checamos todos.
    return v_candidatos[vind] #Nos regresa el vector "v_candidatos" con los indices que cumplan
                              #tener un cero o la raiz pues :v
end #Fin de la funcion xD

"""
   Función ceros Newton
   La función ceros_newton consta de aplicar la función 
   newton2 a la función a la que le queremos aplicar ceros Newton y posteriormente 
   aplicamos la función es monotona a los "v_candidatos" (intervalos donde se cree que
   viven las raices) devueltos por Newton2 y devolver el resultado de su monoticidad
   false (no es monotona) o true (si es monotona) y tambien consta de 3 variables:
   La primera-La función a la cual se le aplicara esta función
   La segunda-El dominio donde se verificara si hay raices "dom"
   La tercera-La tolerancia con la que se quiere tener esta seguridad de que haya una 
   raiz
"""

#Ceros Newton

function ceros_newton(f, dom::Intervalo, tol=1024) #Definimos la funcion "ceros_newton"
	v_candidatos = Newton2(f, dom, tol) #Los intervalos en los cuales tenemos mayor precisión de saber que
                                      #las raices
	unicidad = esmonotona.(f, v_candidatos) #Aplicamos la monoticidad para tener un vector de booleanos
                                          #el cual arroja el resultado de la misma para cada intervalo de 
                                          #"v_candidatos"
	return Raiz.(v_candidatos, unicidad) #ahora regresamos Raiz la cual es un vector de intervalos con sus 
                                       #respectivos estados de monoticidad de cada intervalo.
end  #Fin
