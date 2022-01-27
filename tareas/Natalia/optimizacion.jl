export minimiza, maximiza

"""
   Función minimiza 
   La función se encarga de encontrar el mínimo global de la función "f" en el 
   dominio "a" o mejor dicho el intervalo. Dicha función consta de 3 parametros 
   Primero: "f" el cual es la función que se introduce a conseguir el minimo
   Segundo: "a" el intervalo donde se calculara el minimo global
   Tercero: "pasito" El paso pequeño con el cual se calculara el minimo
"""
function minimiza(f, a::Intervalo, pasito=1/1024) #Función que minimiza y encuentra el minimo
  y=f(a.infimo) #Evaluamos la función en el extremo izquierdo del intervalo
  x=a.infimo #De la misma manera definimos de forma tradicional a x como el extremo
             #izquierdo del intervalo a verificar
  for i in a.infimo:pasito:a.supremo #Hacemos una lista de puntos de a.infimo a
                                     #a.supremo separados un "pasito" de separación 
                                     #e iteramos sobre la misma
    if f(i) < y #como el minimo de todos por default es "x", "y" si el punto "i" evaluado
                #en "f(i)" es menor que y, significa que dentro del mismo intervalo
                #hay otro punto que es menor y de esta forma renombramos al minimo que
                #habiamos asignado.
      y = f(i) #Reescribimos al minimo como "f(i)"
      x = i #De esta misma manera renombramos a x al nuevo punto minimo que cumple ser
            #el minimo
    end
  end

  return [Intervalo(x)],[y] #devolvemos el valor x,y donde esta el minimo global en el intervalo

end #fin


"""
   Función maximiza
   La función se encarga de encontrar el maximo global de la función "f" en el 
   dominio "a" o mejor dicho el intervalo. Dicha función consta de 3 parametros 
   Primero: "f" el cual es la función que se introduce a conseguir el maximo
   Segundo: "a" el intervalo donde se calculara el maximo global
   Tercero: "pasito" El paso pequeño con el cual se calculara el maximo
"""
function maximiza(f, a::Intervalo, pasito=1/1024) #Función que maximiza y encuentra el maximo
  y=f(a.infimo) #Evaluamos la función en el extremo izquierdo del intervalo
  x=a.infimo #De la misma manera definimos de forma tradicional a x como el extremo
             #izquierdo del intervalo a verificar
  for i in a.infimo:pasito:a.supremo #Hacemos una lista de puntos de a.infimo a
                                     #a.supremo separados un "pasito" de separación 
                                     #e iteramos sobre la misma
    if f(i) > y #como el maximo de todos por default es "x", "y" si el punto "i" evaluado
                #en "f(i)" es menor que y, significa que dentro del mismo intervalo
                #hay otro punto que es menor y de esta forma renombramos al maximo que
                #habiamos asignado.
      y = f(i) #Reescribimos al maximo como "f(i)"
      x = i #De esta misma manera renombramos a x al nuevo punto maximo que cumple ser
            #el maximo
    end
  end

  return [Intervalo(x)],[y] #devolvemos el valor x,y donde esta el maximo global en el intervalo

end #fin