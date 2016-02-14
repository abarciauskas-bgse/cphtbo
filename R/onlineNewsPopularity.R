library(assertthat)
#' setupOnlineNewsData
#' Requires local copies of data from https://inclass.kaggle.com/c/predicting-online-news-popularity/data
#' Removes id and url from data
#' Splits data into train and validation sets, randomly
#' 
#' @param directory local directory with online news datasets (see https://inclass.kaggle.com/c/predicting-online-news-popularity/data)
#'
#' @return list(data.train = data.train, data.validation = data.validation)
#' @export
#'
#' @examples
#' data <- setupOnlineNewsData('~/Projects/kaggle-onlinenewspopularity/data')
#' data.train <- data[['data.train']]
#' data.validation <- data[['data.validation']]
#' 
# TODO:  add argument for size of validation set
setupOnlineNewsData <- function(directory = '') {
  setwd(directory)
  
  # Read in data
  data.train <- read.csv('news_popularity_training.csv')
  nobs <- nrow(data.train)
  
  # Remove id and url
  data.train <- data.train[,3:ncol(data.train)]
  
  # Use 20% for validation
  validation.indices <- sample(nobs, 0.2*nobs)
  train.indices <- setdiff(1:nobs, validation.indices)
  data.validation <- data.train[validation.indices,]
  data.train <- data.train[train.indices,]
  return(list(data.train = data.train, data.validation = data.validation))
}

# ----------------------------------------------------------------------
# Generates predictions on the test data
# ----------------------------------------------------------------------
#' generatePredictionsFile
#' Generates predictions on the test data using the model passed as an argument 
#' and then writes them to a file for submission
#'
#' @param model model for generating predictions on test data
#' @param data.directory data where online news test data is stored, also where predictions file will be written
#'
#' @return n/a
#' @export
#'
#' @examples
#' # data.dir <- '~/Projects/kaggle-onlinenewspopularity/data'
#' # model <- randomForest.train(data.train.full)
#' # Generates a new predictions file using datetime as file prefix
#' # generatePredictionsFile(model, data.dir)
generatePredictionsFile <- function(model, data.directory = '') {
  assert_that(mode(model) == 'list')
  setwd(data.directory)
  data.test <- read.csv('news_popularity_test.csv')
  # remove id and url
  x.test <- data.test[,3:ncol(data.test)]
  preds <- predict(model, x.test)
  predictions <- cbind(id=data.test[,'id'], popularity=preds)
  filename <- paste0(as.numeric(Sys.time()),'-predictions.csv')
  print(paste0('Writing predictions to file: ', filename))
  write.csv(predictions, filename, row.names = FALSE)
}
