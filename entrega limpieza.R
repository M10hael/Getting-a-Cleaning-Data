# Obtención y limpieza de datos 
install.packages("data.table")
library(data.table)

#Descargamos los archivos
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( url, destfile = "data.zip" )
unzip("data.zip")

#Debemos cambiar el directorio de trabajo porque debemos usar los archivos descargados
setwd("C:/Users/Usuario/Desktop/Cuarta entrega Coursera/UCI HAR Dataset")

subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

#Se esta obteniendo los datos y de una vez combinando para realizar la tarea
#PUNTO1.Combinamos los datos: entrenamiento y los conjuntos de pruebas
xdatos <- rbind(xTrain, xTest)
ydatos <- rbind(yTrain, yTest)
subjectdatos <- rbind(subjectTrain, subjectTest)

#PUNTO 2. Extraemos la media y la ds para cada conjunto de datos
xdatos_sd_mean <- xdatos[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xdatos_sd_mean) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 

#PUNTO 3. Asignar nombres de actividad descripitvos para asignar un nombre a cada actividad
ydatos[, 1] <- read.table("activity_labels.txt")[ydatos[, 1], 2]
names(ydatos) <- "Activity"

#PUNTO 4. Etiqueta el conjunto de datos con nombres de actividades descriptivos
names(subjectdatos) <- "Subject"

#Organizamos y combinamos todos los datos en uno solo
totaldata <- cbind(xdatos_sd_mean, ydatos, subjectdatos)

# Definimos los nombres descriptivos por actividad para cada variable

names(totaldata) <- make.names(names(totaldata))
names(totaldata) <- gsub('Acc',"Acceleration",names(totaldata))
names(totaldata) <- gsub('GyroJerk',"AngularAcceleration",names(totaldata))
names(totaldata) <- gsub('Gyro',"AngularSpeed",names(totaldata))
names(totaldata) <- gsub('Mag',"Magnitude",names(totaldata))
names(totaldata) <- gsub('^t',"TimeDomain.",names(totaldata))
names(totaldata) <- gsub('^f',"FrequencyDomain.",names(totaldata))
names(totaldata) <- gsub('\\.mean',".Mean",names(totaldata))
names(totaldata) <- gsub('\\.std',".StandardDeviation",names(totaldata))
names(totaldata) <- gsub('Freq\\.',"Frequency.",names(totaldata))
names(totaldata) <- gsub('Freq$',"Frequency",names(totaldata))


#PUNTO5. Creamos un segundo conjunto de datos con el promedio de cada variable para cada actividad y sujeto
Data2<-aggregate(. ~Subject + Activity, singleDataSet, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]

#Obtenemos el archivo en formatp .txt
write.table(Data2, file = "DATA.txt",row.name=FALSE)
View(Data2)
