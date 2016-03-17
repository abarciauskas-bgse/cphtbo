# ----------------------------------------------------------------------
# Train randomForest model on training data
# ----------------------------------------------------------------------
#' train.randomForest
#' 
#' @param data.train matrix or data frame with training data
#' @param label column name of the class identified with the row
#' @param seed if required for recreating exact results
#' @param use.classwts boolean for whether or not to use priors on the classes in the forest. Defaults to TRUE
#' 
#' @return randomForest model trained on training data
#' @export
#'
#' @examples
#' # train.randomForest(data.train)
#' 
train.randomForest <- function(
  data.train,
  seed = 0214,
  label = 'popularity',
  use.classwts = TRUE) {
  # set the seed for replicating results
  set.seed(seed)
  
  # Test arguments (new new years resolution)
  see_if(is.matrix(data.train) || is.data.frame(data.train))
  see_if(is.number(seed))
  see_if(is.string(label))
  see_if(is.logical(use.classwts))

  # factor the classes
  data.train[,label] <- factor(data.train[,label])

  # generate priors on all the classes if requested
  classwts <- NA
  if (use.classwts) {
    no.classes <- length(unique(data.train[,label]))
    classwts <- sapply(1:no.classes, function(cl) {
      sum(data.train[,label] == cl)/nrow(data.train)
    })
  }

  # run the model
  model <- randomForest(
    x = data.train[,setdiff(colnames(data.train), label)],
    y = data.train[,label],
    classwt = classwts)
  return(model)
}
