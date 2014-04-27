library(reshape2)
# Assume Samsung dataset is unpacked in our working directory

# Read test and train tables into memory
test.x<- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y<- read.table("./UCI HAR Dataset/test/y_test.txt")
test.subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")

train.x<- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y<- read.table("./UCI HAR Dataset/train/y_train.txt")
train.subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors =FALSE)

labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors =FALSE)

# Combine test and train datasets
test_data<-cbind(test.subject,test.y,test.x)
train_data<-cbind(train.subject,train.y,train.x)
data_set<-rbind(test_data,train_data)

# Set descriptive names
names(data_set)[3:563]<-features[,2]
names(data_set)[1]<-"Subject"
names(data_set)[2]<-"Activity"

for (i in 1:6){
  data_set$Activity[data_set$Activity ==i] <- labels[i,2]}


Mean<-grep("mean()",features[,2],fixed=TRUE)
SD<-grep("std()",features[,2],fixed=TRUE)
selected_columns<-c(-1, 0, Mean,SD)
selected_dataset<-data_set[,selected_columns + 2]

# Create tidy dataset
melted<-melt(selected_dataset,id=c("Subject","Activity"))
Tidy<-dcast(melted,Subject+Activity~variable,mean)

# Write tidy dataset to file
write.table(Tidy,file="Tidy.txt")
