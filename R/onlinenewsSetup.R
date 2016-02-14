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
