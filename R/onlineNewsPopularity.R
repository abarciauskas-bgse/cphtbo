# ----------------------------------------------------------------------
# Removes url and id columns
# ----------------------------------------------------------------------
#' remove.extra.cols
#' Removes url and id columns
#' 
#' @param data
#'
#' @return data without url and id columns
#' @export
#'
#' @examples
#' data.train <- data('news_popularity_training')
#' data.test <- data('news_popularity_test')
#' training.data <- remove.extra.cols(data)
#' test.data <- remove.extra.cols(data)
#' 
remove.extra.cols <- function(data) {
  see_if(is.matrix(data) || is.data.frame(data))
  # Remove id and url
  data <- data[,setdiff(colnames(data), c('url','id'))]
  return(data)
}

# ----------------------------------------------------------------------
# Setup datasets for training and validation
# ----------------------------------------------------------------------
#' training.partitions
#' Split data into training and validation sets
#'
#' @param data.train a data frame or matrix of training data to split
#' @param p portion of data for validation
#'
#' @return data.train and data.validation
#' @export
#'
#' @examples
#' train <- remove.extra.cols(news_popularity_training)
#' test <- news_popularity_test
#' partitions <- training.paritions(train, p = 0.2)
#' 
training.partitions <- function(data.train, p = 0.2) {
  see_if(is.matrix(data.train) || is.data.frame(data.train))
  see_if(is.number(p))

  nobs <- nrow(data.train)
  val.idcs <- sample(nobs, p*nobs)
  data.validation <- data.train[val.idcs,]
  data.train <- data.train[-val.idcs,]
  return(list(
    data.train = data.train,
    data.validation = data.validation))
}

# ----------------------------------------------------------------------
# Generate predictions on the test data
# ----------------------------------------------------------------------
#' generatePredictionsFile
#' Generates predictions on the test data using the model passed as an argument 
#' and then writes them to a file for submission
#'
#' @param model model for generating predictions on test data
#'
#' @return filename - filename of generated predictions file (just written to disk)
#' @export
#'
#' @examples
#' train <- remove.extra.cols(data('news_popularity_training'))
#' test <- data('news_popularity_test')
#' model <- train.randomForest(train)
#' generate.predictions.file(model, test)
#' 
generate.predictions.file <- function(model, test.data) {
  see_if(is.list(model))

  # remove id and url
  x.test <- remove.extra.cols(test.data)

  # Make predictions
  preds <- predict(model, x.test)

  # Add ids to predictions
  predictions <- cbind(id = test.data[,'id'], popularity = preds)
  filename <- paste0(as.numeric(Sys.time()),'-predictions.csv')

  print(paste0('Writing predictions to file: ', filename))
  write.csv(predictions, filename, row.names = FALSE)
  return(filename)
}
