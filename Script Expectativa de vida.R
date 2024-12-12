#Dataset extraido de Kaggle https://www.kaggle.com/datasets/kumarajarshi/life-expectancy-who?select=Life+Expectancy+Data.csv

library(dplyr)
library(ggplot2)

data <- read.csv("Life Expectancy Data.csv")

View(data)


#The data-set aims to answer the following key questions:
  
  # 1.Does various predicting factors which has been chosen initially really affect the Life expectancy? 
  #What are the predicting variables actually affecting the life expectancy? $

  #2.Should a country having a lower life expectancy value(<65) increase its healthcare expenditure in order to improve its average lifespan?

  #3.How does Infant and Adult mortality rates affect life expectancy?

  #4.Does Life Expectancy has positive or negative correlation with eating habits, lifestyle, exercise, smoking, drinking alcohol etc.

  #5.What is the impact of schooling on the lifespan of humans?

  #6.Do densely populated countries tend to have lower life expectancy?

  #7.What is the impact of Immunization coverage on life Expectancy?


summary(data)

#Taking missing values

#I use de mean value of each column and Country to set the values of NAs

data$Life.expectancy = ifelse(is.na(data$Life.expectancy),
                               ave(x = data$Life.expectancy, data$Country, FUN = function(x) mean(data$Life.expectancy, na.rm = TRUE)),
                               data$Life.expectancy)
  
data$Adult.Mortality = ifelse(is.na(data$Adult.Mortality),
                              ave(x = data$Adult.Mortality, data$Country, FUN = function(x) mean(data$Adult.Mortality, na.rm = TRUE)),
                              data$Adult.Mortality)
  
data$Alcohol = ifelse(is.na(data$Alcohol),
                              ave(x = data$Alcohol, data$Country, FUN = function(x) mean(data$Alcohol, na.rm = TRUE)),
                              data$Alcohol)
  
data$Hepatitis.B = ifelse(is.na(data$Hepatitis.B),
                      ave(x = data$Hepatitis.B, data$Country, FUN = function(x) mean(data$Hepatitis.B, na.rm = TRUE)),
                      data$Hepatitis.B)
  
data$BMI = ifelse(is.na(data$BMI),
                          ave(x = data$BMI, data$Country, FUN = function(x) mean(data$BMI, na.rm = TRUE)),
                          data$BMI)

data$Polio = ifelse(is.na(data$Polio),
                          ave(x = data$Polio, data$Country, FUN = function(x) mean(data$Polio, na.rm = TRUE)),
                          data$Polio)
  
data$Total.expenditure = ifelse(is.na(data$Total.expenditure),
                          ave(x = data$Total.expenditure, data$Country, FUN = function(x) mean(data$Total.expenditure, na.rm = TRUE)),
                          data$Total.expenditure)

data$Diphtheria = ifelse(is.na(data$Diphtheria),
                          ave(x = data$Diphtheria, data$Country, FUN = function(x) mean(data$Diphtheria, na.rm = TRUE)),
                          data$Diphtheria)

data$thinness..1.19.years = ifelse(is.na(data$thinness..1.19.years),
                          ave(x = data$thinness..1.19.years, data$Country, FUN = function(x) mean(data$thinness..1.19.years, na.rm = TRUE)),
                          data$thinness..1.19.years)
  
data$thinness.5.9.years = ifelse(is.na(data$thinness.5.9.years),
                          ave(x = data$thinness.5.9.years, data$Country, FUN = function(x) mean(data$thinness.5.9.years, na.rm = TRUE)),
                          data$thinness.5.9.years)

data$Income.composition.of.resources = ifelse(is.na(data$Income.composition.of.resources),
                          ave(x = data$Income.composition.of.resources, data$Country, FUN = function(x) mean(data$Income.composition.of.resources, na.rm = TRUE)),
                          data$Income.composition.of.resources)

data$Schooling = ifelse(is.na(data$Schooling),
                          ave(x = data$Schooling, data$Country, FUN = function(x) mean(data$Schooling, na.rm = TRUE)),
                          data$Schooling)

data$GDP <- ifelse(is.na(data$GDP),
                   ave(data$GDP, FUN = function(x) mean(data$GDP, na.rm = TRUE)),
                   data$GDP)

data$Population <- ifelse(is.na(data$Population),
                          ave(data$Population, FUN = function(x) mean(data$Population, na.rm = TRUE)),
                          data$Population)


data %>%
  select(Year, Country, Life.expectancy) %>%
  slice_max(order_by = Life.expectancy, n = 1, by = Year) %>%
  arrange(Year)
#Taking the max value of life expectancy every year


data %>%
  select(Year, Alcohol) %>%
  group_by(Year) %>%
  summarise(mean_alcohol = mean(Alcohol, na.rm = TRUE))
#Taking consumption worldwide per year
  
  



#Tomando en cuenta que hay una variable categorica (Status), vamos a transformar esta variable en una dummy variable

data %>%
  distinct(Status)

data$Status <- factor(data$Status,
                      levels = c("Developing", "Developed"),
                      labels = c(0,1))
#En este caso, convertimos los valores de la variable para que Developing tome el valor de 0 y Developed tome el valor de 1


#Ahora, en este punto vamos a realizar la creacion de los sets de prueba y de entrenamiento

library(caTools)
set.seed(123)

split <- sample.split(data$Life.expectancy, SplitRatio = 0.75)
training_set <- subset(data, split == TRUE)
test_set <- subset(data, split == FALSE)


#Ahora que esta listo el dataset de entrenamiento y el de prueba, vamos a generar el modelo.
#Pero mientras generamos el modelo, vamos a verificar si todas las variables independientes aportarian para el modelo y la prediccion.
#Por lo tanto vamos a utilizar el metodo de generacion de modelo Backward elimination.
#Este consiste en agarrar todas las variables en el modelo, y a partir de un valor p base (en mi caso voy a utilizar 0.05)
#Ir eliminando el mayor de los valores p hasta que queden las variables menores al valor p base.

#Con este metodo, podremos responder la primera pregunta del proyecto:
#Las variables dadas inicialmente realmente afectan la expectativa de vida? Cuales afectan en realidad?


regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol + percentage.expenditure +
                 Hepatitis.B + Measles + BMI + under.five.deaths + Polio + Total.expenditure + Diphtheria + HIV.AIDS + GDP +
                 Population + thinness..1.19.years + thinness.5.9.years + Income.composition.of.resources + Schooling,
               data = training_set)
summary(regresor)
#En este caso, la primera variable que aparece con el valor p mas alto es thinness.5.9.years, con un valor p de 0.9069
#Esto quiere decir que esta variable no tiene una significancia estadistica para la prediccion de la variable dependiente.
#Por lo tanto, esta variable no afecta a la expectativa de vida.

regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol + percentage.expenditure +
                 Hepatitis.B + Measles + BMI + under.five.deaths + Polio + Total.expenditure + Diphtheria + HIV.AIDS + GDP +
                 Population + thinness..1.19.years + Income.composition.of.resources + Schooling,
               data = training_set) #Modelo sin la variable thinness.5.9.years
summary(regresor)
#Para esta ocasion, vemos que la variable con el valor p mas alto es Population, con un valor de 0.6751. Por lo tanto
#este tampoco tiene una significancia estadistica para el modelo, y no serviria para el ajuste del modelo y no predeciria
#la variable Life.expectancy

regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol + percentage.expenditure +
                 Hepatitis.B + Measles + BMI + under.five.deaths + Polio + Total.expenditure + Diphtheria + HIV.AIDS + GDP +
                 thinness..1.19.years + Income.composition.of.resources + Schooling,
               data = training_set) #Modelo sin la variable thinness.5.9.years ni Population
summary(regresor)
#Por lo visto en este caso, la otra variable con el valor p mas alto es percentage.expenditure, con un valor de 0.4951, por lo
#que esta variable no tiene aporte estadistico al modelo y no seria relevante para realizar las predicciones.

regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol +
                 Hepatitis.B + Measles + BMI + under.five.deaths + Polio + Total.expenditure + Diphtheria + HIV.AIDS + GDP +
                 thinness..1.19.years + Income.composition.of.resources + Schooling,
               data = training_set) #Modelo sin la variable thinness.5.9.years ni Population, ni percentage.expenditure
summary(regresor)
#En este ajuste al modelo, vemos que la otra variable con mayor valor p es Total.expenditure, con un valor de 0.4219
#Por lo tanto esta variable no tiene significancia estadistica y no aportaria al modelo, y menos a la prediccion de la variable 
#Life.expenditure

regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol +
                 Hepatitis.B + Measles + BMI + under.five.deaths + Polio + Diphtheria + HIV.AIDS + GDP +
                 thinness..1.19.years + Income.composition.of.resources + Schooling,
               data = training_set) #Modelo sin la variable thinness.5.9.years ni Population, ni percentage.expenditure, ni Total.expenditure
summary(regresor)
#En este ajuste, vemos que la siguiente variable con un valor p mayor, es thinness..1.19.years, con un valor de 0.1386
#Esta variable no tiene significancia estadistica por lo que tampoco aporta a la prediccion de Life.expenditure.

regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol +
                 Hepatitis.B + Measles + BMI + under.five.deaths + Polio + Diphtheria + HIV.AIDS + GDP +
                 Income.composition.of.resources + Schooling,
               data = training_set) #Modelo sin la variable thinness.5.9.years ni Population, ni percentage.expenditure, ni Total.expenditure, ni thinness..1.19.years
summary(regresor)
#En este otro ajuste vemos que la unica variable que tiene un valor p mayor, es Measles con un valor de 0.1157. Por lo que
#esta variable no aporta al modelo ni a la prediccion de la variable Life.expectancy

regresor <- lm(formula = Life.expectancy ~ Status + Adult.Mortality + infant.deaths + Alcohol +
                 Hepatitis.B + BMI + under.five.deaths + Polio + Diphtheria + HIV.AIDS + GDP +
                 Income.composition.of.resources + Schooling,
               data = training_set) #Modelo sin la variable thinness.5.9.years,ni Population, ni percentage.expenditure, ni Total.expenditure, ni thinness..1.19.years, ni Measles
summary(regresor)
#En este caso, al sacar de la formula esta ultima variable, no hay ninguna otra variable que tenga un valor p mayor a 0.05.
#Por lo que el modelo esta optimizado y todas sus variables tienen significancia estadistica para el mismo. Por lo tanto
#pueden realizar la prediccion para la variable Life.expectancy.

#Ahora se puede responder la primera pregunta.
#Las variables que pueden predecir la variable dependiente son:
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
#Schooling





#La segunda pregunta indica:
#Un pais con una expetativa menor a 65 deberia incrementar su gasto en salud para mejorar su expectativa?
#Para responderla, hay que verificar, cuales paises tienen una menor expectativa de vida
#Para esto, vamos a obtener el promedio de la expectativa de vida por pais

paisesmenos65 <- data%>%
  group_by(Country) %>%
  filter(mean(Life.expectancy) < 65) %>%
  select(Life.expectancy, Country, Total.expenditure)

paisesmenos65

#Posteriormente vamos a obtener el promedio de expectativa de vida por los paises mayores o iguales a 65


paisesmayorigual65 <- data%>%
  filter(mean(Life.expectancy) >= 65) %>%
  select(Life.expectancy, Country, Total.expenditure)%>%
  group_by(Country)

paisesmayorigual65

#Luego verifiquemos a traves de graficos de puntos como seria la relacion entre ambas variables
#La expectativa de vida y el gasto en salud

ggplot(paisesmayorigual65)+
  geom_point(mapping = aes(x = Total.expenditure, y = Life.expectancy), color = "blue")
#Por lo visto en este grafico, de los paises expectativa de vida mayor a 65, no hay ninguna relacion entre la expectativa y el gasto

ggplot(paisesmenos65)+
  geom_point(mapping = aes(x = Total.expenditure, y = Life.expectancy), color = "blue")
#Lo mismo pasa con los paises con una expectativa menor a 65. Es decir, no hay relacion entre el aumento o disminucion del gasto y
#la expectativa de vida en el pais.
#De igual forma esto se puede validar en el modelo de regresion, ya que la variable Total.expenditure no se encuentra en el modelo
#debido a su poca significancia estadistica para predecir la expectativa de vida



#Ahora pasemos a la siguiente pregunta
#Como afecta la mortalidad infantil y adulta a la expectativa de vida?
ggplot(data = data) +
  geom_point(mapping = aes(x = Adult.Mortality, y = Life.expectancy), color = "red")

ggplot(data = data) +
  geom_point(mapping = aes(x = infant.deaths, y = Life.expectancy), color = "blue")

ggplot(data = data) +
  geom_point(mapping = aes(x = under.five.deaths, y = Life.expectancy), color = "green")

cor(data$Life.expectancy, data$infant.deaths)

cor(data$Life.expectancy, data$Adult.Mortality)

cor(data$Life.Expectancy, data$infant.deaths, data$Adult.Mortality)

cor(data$thinness..1.19.years,data$infant.deaths)

#En conclusion, entre las dos variables de mortalidad, la que mas afecta a la expectativa de vida es la variable 
#de mortalidad adulta.
#Esta toma el numero de habitantes muertos por cada 1000 habitantes de la poblacion entre los 15 y 60 anios.
#La tendencia muestra que en promedio, mientras menor expectativa de vida haya, mayor sera la mortalidad adulta.

#En el caso de la mortalidad infantil, tiene su significancia estadistica para la prediccion de la expectativa de vida,
#lo cual se puede apreciar en las variables independientes en el modelo de regresion lineal.
#Sin embargo, en los graficos de puntos, se nota que la tendencia no es tan marcada, y el coeficiente de correlacion no es tan
#favorable, el cual da -0.19, por lo que hay poca relacion.

#Para terminar, el factor que mas afecta entre los dos, es el de la mortalidad adulta


#Pasemos a la pregunta 4
#La variable Life.expectancy tiene una correlacion positiva o negativa con los habitos de comida, estilo de vida, ejercicio, habito de fumar, bebida de alcohol, etc?

#Correlacion entre delgadez infantil y expectativa de vida
cor(data$Life.expectancy, data$thinness..1.19.years) #-0.4721619
cor(data$Life.expectancy, data$thinness.5.9.years)  #-0.4666292

ggplot()+
  geom_point(data = data, mapping = aes(x = thinness..1.19.years, y = Life.expectancy), color = "blue")

ggplot()+
    geom_point(data = data, mapping = aes(x = thinness.5.9.years, y = Life.expectancy), color = "blue")


#Correlacion entre el indice de masa corporal (BMI) y la expectativa de vida
cor(data$Life.expectancy, data$BMI) #0.5592553

ggplot()+
  geom_point(data = data, mapping = aes(x = BMI, y = Life.expectancy), color = "blue")


#Correlacion entre el consumo de alcohol y la expectativa de vida
cor(data$Life.expectancy, data$Alcohol) #0.3915983

ggplot()+
  geom_point(data = data, mapping = aes(x = Alcohol, y = Life.expectancy), color = "blue")


#Para responder esta pregunta vamos a tomar algunas variables como la delgadez de ninos de 10 a 19
#y de ninos de 5 a 9, en este primer caso vemos que la correlacion es negativa, y efectivamente si dibujamos
#un grafico para representar la relacion, vemos que es negativa. Por lo que, mientras menos expectativa de vida
#haya, mayor va a ser la delgadez.

#Tambien se tomo la variable del indice de masa corporal (BMI), que en este caso, la correlacion
#es positiva. Y si se dibuja un grafico, se nota una ligera relacion positiva entre
#ambas variables. Por lo que mientras mayor sea la expectativa de vida, el indice de masa corporal, tiende a aumentar ligeramente


#Tambien se toma la variable del alcohol, que recoge la cantidad de litros de puro alcohol per capita
#que son consumidos. Y en este caso, si bien la correlacion muestra un valor relativamente positivo (0.39)
#al dibujar un grafico no muestra una tendencia tan marcada. Por lo que no hay una relacion directa, positiva o
#negativa, entre el consumo de alcohol y la expectativa de vida



#Pasemos a la pregunta 5
#Como es el impacto de la escolaridad en la esperanza de vida?
plot(data$Schooling, data$Life.expectancy)

#Por lo que se aprecia en el grafico, en promedio mientras mayor sean los anios de escolaridad
#la esperanza de vida aumenta. Esto debido a que mientras mas tiempo se pase preparandose academicamente
#mas preparado estaria para entrar al mercado laboral, y por ende mejores ingresos podria devengar.
#Y por lo tanto, la esperanza de vida aumentaria.


#Pasemos a la 6ta pregunta
#Tienen los paises densamente poblados, una expectativa de vida mas baja?

#Tomando en cuenta que la densidad poblacional se calcula en base a la cantidad de personas por metro cuadrado
#y que no hay una variable indicando los metros cuadrados por cada pais,
#se va a importar datos correspondientes al territorio de cada uno de los paises
#para poder realizar los calculos a base de estos.

library(rvest)

link <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_area"

page <- read_html(link)

info <- html_text(page)
info

table <- html_table(page)

table <- table[-1]
table <- table[-2,-3]

table <- table[-2]
table <- table[-3]
table <- table[-2]
table
#Extraccion de tabla con superficie por pais de internet
 
superficiesMundo <- as.data.frame(table)
View(superficiesMundo)

superficiesMundo$Totalin.km2..mi2. <- NULL
superficiesMundo$Waterin.km2..mi2. <- NULL
superficiesMundo$Var.7 <- NULL
superficiesMundo$X.water <- NULL
dim(superficiesMundo)
#Eliminacion de columnas innecesatias

superficiesMundo$Country...dependency <- as.list(superficiesMundo$Country...dependency)

paisesDATA <- data %>%
  distinct(Country)
paisesDATA

paisesMundo <- as.data.frame(superficiesMundo$Country...dependency)
paisesMundo <- t(paisesMundo)
summary(paisesMundo)
paisesMundo <- as.data.frame(paisesMundo)
paisesMundo
row.names(paisesMundo) <- row_number(paisesMundo)

paisesMundo

colnames(paisesMundo$V1,prefix = "col")
colnames(paisesMundo$V1) <- Country

paisesMundo <- paisesMundo %>%
  rename(Country = V1)

inner_join(paisesDATA, paisesMundo, by = "Country")

superficiesMundo$Var.1 = NULL
superficiesMundo <- superficiesMundo %>% rename(Country = Country...dependency)

superficiesMundo$Landin.km2..mi2. <- gsub(",","",superficiesMundo$Landin.km2..mi2.)
superficiesMundo$Landin.km2..mi2. <- sub("(..........)$","",superficiesMundo$Landin.km2..mi2.)

superficiesMundo$Landin.km2..mi2. <- as.numeric(superficiesMundo$Landin.km2..mi2.)

superficiesMundo$Country <- as.character(superficiesMundo$Country)




densidad <- data %>%
  left_join(superficiesMundo, by = "Country") %>%
  filter(!is.na(superficiesMundo$Landin.km2..mi2.) & (Country %in% unique_country)) %>%
  select(Life.expectancy, Population, Country, superficie = Landin.km2..mi2.)

densidad1 <- densidad %>%
  mutate(densidad_poblacional = Population / superficie)
View(densidad1)

class(densidad1$densidad_poblacional)
densidad1$densidad_poblacional <- round(densidad1$densidad_poblacional, digits = 2)

densidad2 <- densidad1 %>%
  select(Life.expectancy, Country, Population, densidad_poblacional) %>%
  distinct(Country, .keep_all = TRUE)
  
View(densidad2)

ggplot(data = densidad2)+
  geom_point(mapping = aes(x = densidad_poblacional, y = Life.expectancy), color = "blue")

ggplot()+
  geom_point(data = densidad2, mapping = aes(x = densidad_poblacional, y = Life.expectancy), color = "blue")

#Segun el analisis antes realizado, no hay ninguna relacion entre la densidad poblacional y la expectativa de vida.
#Por lo que la densidad no afecta a la expectativa de vida, en general.



#Pasemos a la pregunta 7
#Cual es el impacto de la covertura de inmunizacion en la expectativa de vida?

#Para esta ultima pregunta, hay que verificar cuales son las variables que muestran datos de inmunizacion
#HepatitisB:immunization coverage among 1-year-olds (%)
#Polio: immunization coverage among 1-year-olds (%)
#Difteria: immunization coverage among 1-year-olds (%)

#Para esta pregunta, ya sabemos cuales son las variables que toman en cuenta la inmunizacion. 
#Y sabemos que se encuentran dentro del modelo de prediccion y son estadisticamente significativas
#con un valor p bajo.

#Adicionalmente, veamos que tendencia muestran realizando un grafico para cada una

ggplot(data = data)+
  geom_point(mapping = aes(x = Hepatitis.B, y = Life.expectancy), color = "blue") #tendencia con inmunizacion de HepatitisB
#En el caso de la Hepatitis.B la tendencia no se ve tan marcada, sin embargo, se nota levemente que a mayor inmunizacion
#la expectativa de vida aumenta

ggplot(data = data)+
  geom_point(mapping = aes(x = Polio, y = Life.expectancy), color = "blue") #Tendencia con inmunizacion de Polio
#Para el caso de la inmunizacion contra la Polio, es evidente la tendencia, mientras mayor inmunizacion haya
#mayor sera la expectativa de vida. La tendencia es mas marcada.

ggplot(data = data)+
  geom_point(mapping = aes(x = Diphtheria, y = Life.expectancy), color = "blue") #Tendencia con inmunizacion de Diphteria
#Pasa lo mismo para la Difteria. Tiene una tendencia mas marcada con respecto a la expectativa de vida.

#En general, para concluir, mientras mayor covertura de inmunizacion haya en la poblacion, esta tendra una mejor y mayor
#expectativa de vida.


#Para concluir, me gustaria realizar predicciones con los datos y entrenar el modelo de regresion para hacer las predicciones
#Las voy a hacer con todas y cada una de las variables que se encuentran dentro del modelo.

#Para realizar las predicciones se usara el test_set

y_pred <- predict(regresor, newdata = test_set)

ggplot()+ #Mortalidad adulta
  geom_point(test_set, mapping = aes(x = Adult.Mortality, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = Adult.Mortality, y = y_pred), color = "red")+
  ggtitle("Mortalidad adulta ~ Expectativa de vida")
#En este caso, la tendencia indica que, a mayor mortalidad adulta registrada, menor expectativa de vida habra

ggplot()+ #Mortalidad infantil
  geom_point(test_set, mapping = aes(x = infant.deaths, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = infant.deaths,  y = y_pred), color = "red")+
  ggtitle("Mortalidad infantil ~ Expectativa de vida")
#En este caso, se nota una tendencia a la baja al inicio del grafico, sin embargo, sube ligeramente mintras mayor expectativa de vida.

ggplot()+ #Alcohol
  geom_point(test_set, mapping = aes(x = Alcohol, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = Alcohol, y = y_pred), color = "red")+
  ggtitle("Consumo de alcohol ~ Expectativa de vida")
#En el caso del consumo de alcohol, muestra una ligera tendencia positiva con respecto a la expectativa de vida.

ggplot()+ #Inmunizacion contra Hepatitis B
  geom_point(test_set, mapping = aes(x = Hepatitis.B, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = Hepatitis.B, y = y_pred), color = "red")+
  ggtitle("Inmunizacion contra la Hepatitis B ~ Expectativa de vida")
#Muestra una tendencia muy lineal y neutra al inicio del grafico, sin embargo, mientras va avanzando
#aumenta ligeramente la expectativa de vida.

ggplot()+# Indice de masa corporal
  geom_point(test_set, mapping = aes(x = BMI, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = BMI, y = y_pred), color = "red")+
  ggtitle("Indice de masa corporal ~ Expectativa de vida")
#El indice de masa corporal muestra cierta parabola dentro del modelo. Con una tendencia positiva a mayor masa corporal.
#Pero llega un punto en el que el modelo vuelve a disminuir, al alcanzar cierto punto.

ggplot()+ #Muertes antes de los 5 anios
  geom_point(test_set, mapping = aes(x = under.five.deaths, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = under.five.deaths, y = y_pred), color = "red")+
  ggtitle("Mortalida infantil antes de los 5 anios ~ Expectativa de vida")
#Muestra exactamente la misma tendencia que el grafico de la mortalidad infantil.

ggplot()+ #Inmunizacion contra la Polio
  geom_point(test_set, mapping = aes(x = Polio, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = Polio, y = y_pred), color = "red")+
  ggtitle("Polio ~ Expectativa de vida")
#Va mostrando una ligera tendencia positiva a medida que la inmunizacion va aumentando.

ggplot()+ #Inmunizacion contra la difteria
  geom_point(test_set, mapping = aes(x = Diphtheria, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = Diphtheria, y = y_pred), color = "red")+
  ggtitle("Inmunizacion contra la difteria ~ Expectativa de vida")
#Muestra una conducta similar al grafico de la inmunizacion contra la polio

ggplot()+ #VIH Y SIDA
  geom_point(test_set, mapping = aes(x = HIV.AIDS, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = HIV.AIDS, y = y_pred), color = "red")+
  ggtitle("Mortalidad por SIDA y VIH ~ Expectativa de vida")
#En este caso, la tendencia es muy marcada y evidente. A medida que aumenten las muertes por VIH
#la expectativa de vida se va a ver afectada.

ggplot()+ #PIB
  geom_point(test_set, mapping = aes(x = GDP, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = GDP, y = y_pred), color = "red")+
  ggtitle("PBI ~ Expectativa de vida")
#En el caso de la PIB y la expectativa de vida, la expectativa de vida se ve mejorada mientras sube el PIB
#Esto hasta cierto punto.

ggplot()+ #Escolaridad
  geom_point(test_set, mapping = aes(x = Schooling, y = Life.expectancy), color = "blue")+
  geom_smooth(test_set, mapping = aes(x = Schooling, y = y_pred), color = "red")+
  ggtitle("Anios de escolaridad ~ Expectativa de vida")
#Pasa lo mismo con la educacion, mientras mas anios tenga la nacion de educacion en su programa,
#la expectativa de vida va a aumentar.


#Con esto, las conclusiones son:

#Esforzar las gestiones economicas y fiscales para el aumento de la produccion y por ende del PIB,
#Mientras mas educacion haya en los paises, mejor va a ser la expectativa de vida.

#Las inmunizaciones son importantes, ya que alargan la expectativa de vida.
#Hacer lo posible para realizar ejercicio y comer sanamente para aumentar los indices de masa corporal
#pero hasta cierto punto. Con precaucion.