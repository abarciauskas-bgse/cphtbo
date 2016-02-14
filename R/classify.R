library(randomForest)
# ----------------------------------------------------------------------
# Train randomForest model on training data
# ----------------------------------------------------------------------
#' randomForest.train
#' 
#' @param data.train matrix or data frame with training data
#' @param label column name of the class identified with the row
#' @param seed if required for recreating exact results
#'
#' @return randomForest model trained on training data
#' @export
#'
#' @examples
#' # model <- randomForest.train(data.train.full)
#' 
randomForest.train <- function(data.train, seed = 187, label = 'popularity') {
  set.seed(seed)
  data.train[,label] <- factor(data.train[,label])
  randomForest(x = data.train[,setdiff(colnames(data.train), label)], y = data.train[,label])
}
