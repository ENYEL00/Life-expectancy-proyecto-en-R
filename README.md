# Bienvenidos a mi primer proyecto con algoritmos de Machine Learning

En este primer proyecto aplique un algoritmo de machine learning basico, que es la regresion lineal. Este compara una variable dependiente para validar si hay una relacion con otra variable independiente. Para que
a partir de esta ultima se puedan realizar predicciones con datos no vistos por el modelo.

En este proyecto personal se utilizó el dataset [Life Expectancy Data.csv](https://github.com/user-attachments/files/18114581/Life.Expectancy.Data.csv) que tambien se puede encontrar entre los archivos subidos.

Fue extraido desde [Kaggle](https://www.kaggle.com/datasets/kumarajarshi/life-expectancy-who?select=Life+Expectancy+Data.csv)

En esta pagina tambien se indican las preguntas para ejecutar el proyecto. Son las siguientes

### 1. Son todas las variables escogidas inicialmente en el dataset relevantes para la expectativa de vida?
   Cuales son las variables que realmente afectan a la expectativa de vida?

Esta pregunta se puede responder con un modelo de regresion lineal multiple, el cual toma todas las variables inicialmente.
Luego se van eliminando del modelo dependiendo de su relevancia estadistica y sus p-values. Asi pues, se encontraron cuales son las variables
que afectan realmente la expectativa de vida, segun el modelo:

#Status1                          1.828e+00  3.128e-01   5.846 5.80e-09 ***
#Adult.Mortality                 -1.934e-02  9.087e-04 -21.285  < 2e-16 ***
#infant.deaths                    1.081e-01  9.680e-03  11.164  < 2e-16 ***
#Alcohol                          7.059e-02  2.930e-02   2.409   0.0161 *  
#Hepatitis.B                     -2.047e-02  4.591e-03  -4.458 8.68e-06 ***
#BMI                              5.321e-02  5.270e-03  10.097  < 2e-16 ***
#under.five.deaths               -8.172e-02  7.118e-03 -11.481  < 2e-16 ***
#Polio                            3.227e-02  5.453e-03   5.918 3.77e-09 ***
#Diphtheria                       3.453e-02  5.635e-03   6.128 1.05e-09 ***
#HIV.AIDS                        -4.843e-01  2.046e-02 -23.672  < 2e-16 ***
#GDP                              3.973e-05  7.863e-06   5.053 4.72e-07 ***
#Income.composition.of.resources  6.000e+00  7.443e-01   8.061 1.23e-15 ***

En resumen, todas estas variables tienen al menos un asterisco al final de la fila. Ese asterisco indica la relevancia estadistica que tienen cada una de las variables en el modelo.
En otras palabras, son estas las variables que afectan a la expectativa de vida segun el modelo.


### 2. Un pais con una expetativa menor a 65 deberia incrementar su gasto en salud para mejorar su expectativa?

Segun el analisis realizado, no hay ninguna relacion entre el gasto en salud y la expectativa de vida. Por lo que no seria necesario el aumento del gasto en salud.


### 3.Como afecta la mortalidad infantil y adulta a la expectativa de vida?

Entre las dos variables de mortalidad, la que mas afecta a la expectativa de vida es la variable 
de mortalidad adulta.
Esta toma el numero de habitantes muertos por cada 1000 habitantes de la poblacion entre los 15 y 60 anios.
La tendencia muestra que en promedio, mientras menor expectativa de vida haya, mayor sera la mortalidad adulta.

En el caso de la mortalidad infantil, tiene su significancia estadistica para la prediccion de la expectativa de vida,
lo cual se puede apreciar en las variables independientes en el modelo de regresion lineal.
Sin embargo, en los graficos de puntos, se nota que la tendencia no es tan marcada, y el coeficiente de correlacion no es tan
favorable, el cual da -0.19, por lo que hay poca relacion.

Para terminar, el factor que mas afecta entre los dos, es el de la mortalidad adulta


### 4.La variable Life.expectancy tiene una correlacion positiva o negativa con los habitos de comida, estilo de vida, ejercicio, habito de fumar, bebida de alcohol, etc?

Para responder esta pregunta vamos a tomar algunas variables como la delgadez de ninos de 10 a 19
y de ninos de 5 a 9, en este primer caso vemos que la correlacion es negativa, y efectivamente si dibujamos
un grafico para representar la relacion, vemos que es negativa. Por lo que, mientras menos expectativa de vida
haya, mayor va a ser la delgadez.

Tambien se tomo la variable del indice de masa corporal (BMI), que en este caso, la correlacion
es positiva. Y si se dibuja un grafico, se nota una ligera relacion positiva entre
ambas variables. Por lo que mientras mayor sea la expectativa de vida, el indice de masa corporal, tiende a aumentar ligeramente

Tambien se toma la variable del alcohol, que recoge la cantidad de litros de puro alcohol per capita
que son consumidos. Y en este caso, si bien la correlacion muestra un valor relativamente positivo (0.39)
al dibujar un grafico no muestra una tendencia tan marcada. Por lo que no hay una relacion directa, positiva o
negativa, entre el consumo de alcohol y la expectativa de vida.


### 5. Como es el impacto de la escolaridad en la esperanza de vida?
En promedio mientras mayor sean los anios de escolaridad
la esperanza de vida aumenta. Esto debido a que mientras mas tiempo se pase preparandose academicamente
mas preparado estaria para entrar al mercado laboral, y por ende mejores ingresos podria devengar.
Y por lo tanto, la esperanza de vida aumentaria.


### 6.Tienen los paises densamente poblados, una expectativa de vida mas baja?
No hay ninguna relacion entre la densidad poblacional y la expectativa de vida.
Por lo que la densidad no afecta a la expectativa de vida, en general.


### 7.Cual es el impacto de la covertura de inmunizacion en la expectativa de vida?
En general, para concluir, mientras mayor covertura de inmunizacion haya en la poblacion, esta tendra una mejor y mayor
#expectativa de vida.


### Conclusiones
Con esto, las conclusiones son:

Esforzar las gestiones economicas y fiscales para el aumento de la produccion y por ende del PIB,
Mientras mas educacion haya en los paises, mejor va a ser la expectativa de vida.
Las inmunizaciones son importantes, ya que alargan la expectativa de vida.
Hacer lo posible para realizar ejercicio y comer sanamente para aumentar los indices de masa corporal
pero hasta cierto punto. Con precaucion.
