#Download and unzip the data file
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="curl")
unzip(filename)

#Get all labels in the project
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features_mean_std <- grep(".*mean.*|.*std.*", features[,2])
features_names <- features[features_mean_std,2]
features_names <- gsub('-mean', 'Mean', features_names)
features_names <- gsub('-std', 'Std', features_names)
features_names <- gsub('[-()]', '', features_names)

#Read, label and merge all data in the project
train_X <- read.table("UCI HAR Dataset/train/X_train.txt")[features_mean_std]
train_Y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_Sub <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_Sub, train_Y, train_X)

test_X <- read.table("UCI HAR Dataset/test/X_test.txt")[features_mean_std]
test_Y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_Sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_Sub, test_Y, test_X)
HARDataset <- rbind(train, test)
colnames(HARDataset) <- c("subject", "activity", features_names)

#Refine the dataset
HARDataset$activity <- factor(HARDataset$activity, levels = activity_labels[,1], labels = activity_labels[,2])
HARDataset$subject <- as.factor(HARDataset$subject)
HARDataset_tidy <- melt(HARDataset, id = c("subject", "activity"))
HARDataset_tidy <- dcast(HARDataset_tidy, subject + activity ~ variable, mean)

#Output the tidy dataset
write.table(HARDataset_tidy, "tidy.txt", row.names = FALSE, quote = FALSE)
